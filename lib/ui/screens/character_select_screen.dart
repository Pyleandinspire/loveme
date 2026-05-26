import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/managers/character_manager.dart';
import '../../core/models/character.dart';
import '../../core/services/storage_service.dart';
import 'main_game_screen.dart';
import 'character_customize_screen.dart';

class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  final CharacterManager _characterManager = CharacterManager();
  bool _isLoading = true;
  Character? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    await _characterManager.loadCharacters();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择你的心动对象'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _characterManager.characters.length,
                    itemBuilder: (context, index) {
                      final character = _characterManager.characters[index];
                      return _buildCharacterCard(character);
                    },
                  ),
                ),
                if (_selectedCharacter != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => _selectCharacter(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('开始恋爱'),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildCharacterCard(Character character) {
    final isSelected = _selectedCharacter?.id == character.id;

    return Card(
      elevation: isSelected ? 8 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? const BorderSide(color: Colors.pinkAccent, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCharacter = character;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 头像
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  character.avatar,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 50),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      character.personality,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      character.description,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 选择指示
              if (isSelected)
                const Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: 32,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectCharacter(BuildContext context) async {
    if (_selectedCharacter == null) return;

    final storage = Provider.of<StorageService>(context, listen: false);
    await storage.createNewGame(_selectedCharacter!.id);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainGameScreen()),
      );
    }
  }
}
