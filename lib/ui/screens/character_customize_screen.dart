import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/managers/character_manager.dart';
import '../../core/models/character.dart';
import '../../core/services/storage_service.dart';

class CharacterCustomizeScreen extends StatefulWidget {
  const CharacterCustomizeScreen({super.key});

  @override
  State<CharacterCustomizeScreen> createState() => _CharacterCustomizeScreenState();
}

class _CharacterCustomizeScreenState extends State<CharacterCustomizeScreen> {
  final CharacterManager _characterManager = CharacterManager();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _appearanceController = TextEditingController();

  String? _selectedBaseCharacterId;
  List<String> _referenceImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    await _characterManager.loadCharacters();
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _personalityController.dispose();
    _descriptionController.dispose();
    _appearanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建专属角色'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 基础角色选择
                  const Text(
                    '选择基础角色',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _characterManager.characters.length,
                      itemBuilder: (context, index) {
                        final character = _characterManager.characters[index];
                        final isSelected = _selectedBaseCharacterId == character.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBaseCharacterId = character.id;
                              _nameController.text = character.name;
                              _personalityController.text = character.personality;
                              _descriptionController.text = character.description;
                              _appearanceController.text = character.appearanceDescription;
                            });
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.pinkAccent : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(character.avatar),
                                  backgroundColor: Colors.grey[300],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  character.name,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 角色名称
                  const Text(
                    '角色名称',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: '输入角色名称',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 参考图片上传
                  const Text(
                    '参考图片',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._referenceImages.map((path) => _buildImageTile(path)),
                      _buildAddImageTile(),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 性格描述
                  const Text(
                    '性格特点',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _personalityController,
                    decoration: const InputDecoration(
                      hintText: '例如：温柔、体贴、有点害羞',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 24),

                  // 角色简介
                  const Text(
                    '角色简介',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: '简要描述这个角色',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  // AI外貌描述生成按钮
                  ElevatedButton.icon(
                    onPressed: _generateAppearanceDescription,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('AI生成外貌描述'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 外貌描述
                  const Text(
                    '外貌描述',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _appearanceController,
                    decoration: const InputDecoration(
                      hintText: '描述角色的外貌特征',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 32),

                  // 确认创建按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createCharacter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('确认创建'),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildImageTile(String path) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _referenceImages.remove(path);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              '添加图片',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    // 在实际应用中，这里会调用image_picker
    // 现在模拟添加一个占位图片路径
    setState(() {
      // 模拟添加图片
      // _referenceImages.add('assets/placeholder.png');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('图片选择功能需要在真机上测试')),
    );
  }

  Future<void> _generateAppearanceDescription() async {
    if (_referenceImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先上传参考图片')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 模拟AI生成
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _appearanceController.text = '长发及腰，黑色直发，眼睛是温柔的棕色。皮肤白皙，笑起来有两个小酒窝。身材苗条，气质温婉。';
    });
  }

  Future<void> _createCharacter() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入角色名称')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final baseCharacter = _selectedBaseCharacterId != null
        ? _characterManager.getCharacterById(_selectedBaseCharacterId!)
        : null;

    final customCharacter = Character(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      avatar: baseCharacter?.avatar ?? 'assets/lin_xiaoyu.png',
      portrait: baseCharacter?.portrait ?? 'assets/lin_xiaoyu.png',
      personality: _personalityController.text,
      description: _descriptionController.text,
      backstory: baseCharacter?.backstory ?? '',
      traits: baseCharacter?.traits ?? {},
      appearanceDescription: _appearanceController.text,
      referenceImagePaths: List.from(_referenceImages),
      isCustom: true,
      sharedMemories: [],
    );

    _characterManager.addCustomCharacter(customCharacter);

    // 保存到存储
    final storage = Provider.of<StorageService>(context, listen: false);
    await storage.saveCharacter(customCharacter);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('角色创建成功！')),
      );
      Navigator.pop(context);
    }
  }
}
