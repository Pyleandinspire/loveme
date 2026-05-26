import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/ai_config.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/ai_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _apiKeyController;
  late TextEditingController _baseUrlController;
  String _selectedProvider = 'openai';
  String _selectedModel = 'gpt-4o-mini';
  int _typingSpeed = 1;
  String _theme = 'system';
  bool _soundEnabled = true;
  bool _showApiKey = false;

  final List<String> _openaiModels = ['gpt-4o-mini', 'gpt-4o', 'gpt-4-turbo'];
  final List<String> _claudeModels = ['claude-3-opus', 'claude-3-sonnet'];

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
    _baseUrlController = TextEditingController();
    _loadSettings();
  }

  void _loadSettings() {
    final storage = Provider.of<StorageService>(context, listen: false);
    final config = storage.getAIConfig();
    _apiKeyController.text = config.apiKey;
    _baseUrlController.text = config.baseUrl ?? '';
    _selectedProvider = config.provider;
    _selectedModel = config.model;
    _typingSpeed = config.typingSpeed;
    _theme = config.theme;
    _soundEnabled = config.soundEnabled;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI 服务配置
          const Text(
            'AI 服务配置',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 服务商选择
          const Text('服务商'),
          DropdownButton<String>(
            value: _selectedProvider,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
              DropdownMenuItem(value: 'claude', child: Text('Claude')),
              DropdownMenuItem(value: 'custom', child: Text('自定义')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedProvider = value!;
                if (value == 'openai') {
                  _selectedModel = 'gpt-4o-mini';
                } else if (value == 'claude') {
                  _selectedModel = 'claude-3-sonnet';
                }
              });
            },
          ),
          const SizedBox(height: 16),

          // 模型选择
          const Text('模型'),
          DropdownButton<String>(
            value: _selectedModel,
            isExpanded: true,
            items: (_selectedProvider == 'claude'
                    ? _claudeModels
                    : _openaiModels)
                .map((model) => DropdownMenuItem(
                      value: model,
                      child: Text(model),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedModel = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // API Key
          const Text('API Key'),
          TextField(
            controller: _apiKeyController,
            obscureText: !_showApiKey,
            decoration: InputDecoration(
              hintText: '输入你的 API Key',
              suffixIcon: IconButton(
                icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _showApiKey = !_showApiKey;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 自定义 Base URL
          if (_selectedProvider == 'custom') ...[
            const Text('Base URL'),
            TextField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                hintText: '输入自定义 API 地址',
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 保存按钮
          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('保存设置'),
          ),
          const SizedBox(height: 16),

          // 测试连接按钮
          OutlinedButton.icon(
            onPressed: _testConnection,
            icon: const Icon(Icons.wifi_tethering),
            label: const Text('测试连接'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 32),

          // 打字速度
          const Text(
            '打字速度',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('慢')),
              ButtonSegment(value: 1, label: Text('中')),
              ButtonSegment(value: 2, label: Text('快')),
            ],
            selected: {_typingSpeed},
            onSelectionChanged: (selection) {
              setState(() {
                _typingSpeed = selection.first;
              });
            },
          ),
          const SizedBox(height: 32),

          // 主题设置
          const Text(
            '主题设置',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'light', label: Text('浅色')),
              ButtonSegment(value: 'dark', label: Text('深色')),
              ButtonSegment(value: 'system', label: Text('跟随系统')),
            ],
            selected: {_theme},
            onSelectionChanged: (selection) {
              setState(() {
                _theme = selection.first;
              });
            },
          ),
          const SizedBox(height: 32),

          // 音效开关
          SwitchListTile(
            title: const Text('音效'),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          const SizedBox(height: 32),

          // 清除数据
          ElevatedButton(
            onPressed: _showClearDataDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('清除所有数据'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    final config = AIConfig(
      provider: _selectedProvider,
      apiKey: _apiKeyController.text,
      model: _selectedModel,
      baseUrl: _baseUrlController.text.isNotEmpty ? _baseUrlController.text : null,
      typingSpeed: _typingSpeed,
      theme: _theme,
      soundEnabled: _soundEnabled,
    );

    await storage.saveAIConfig(config);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存')),
      );
    }
  }

  Future<void> _testConnection() async {
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入 API Key')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('正在测试连接...'),
          ],
        ),
      ),
    );

    try {
      final config = AIConfig(
        provider: _selectedProvider,
        apiKey: _apiKeyController.text,
        model: _selectedModel,
        baseUrl: _baseUrlController.text.isNotEmpty ? _baseUrlController.text : null,
        typingSpeed: _typingSpeed,
        theme: _theme,
        soundEnabled: _soundEnabled,
      );
      
      final aiService = AIService(config);
      final success = await aiService.testConnection();

      if (mounted) {
        Navigator.pop(context);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('连接成功！'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('连接失败，请检查 API Key 和网络'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('连接错误: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除所有数据'),
        content: const Text('确定要清除所有存档数据吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final storage = Provider.of<StorageService>(context, listen: false);
              await storage.clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('数据已清除')),
                );
              }
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
