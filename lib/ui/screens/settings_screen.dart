import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/ai_config.dart';
import '../../core/services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  String _selectedProvider = 'OpenAI';
  String _selectedModel = 'gpt-4o-mini';

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    final config = storage.getAIConfig();
    if (config != null) {
      setState(() {
        _apiKeyController.text = config.apiKey;
        _baseUrlController.text = config.baseUrl ?? '';
        _selectedProvider = config.provider;
        _selectedModel = config.model;
      });
    }
  }

  Future<void> _saveConfig() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    final config = AIConfig(
      provider: _selectedProvider,
      apiKey: _apiKeyController.text.trim(),
      model: _selectedModel,
      baseUrl: _baseUrlController.text.trim().isEmpty
          ? null
          : _baseUrlController.text.trim(),
      updatedAt: DateTime.now(),
    );
    await storage.saveAIConfig(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI 配置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProvider,
                    decoration: const InputDecoration(
                      labelText: '服务提供商',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'OpenAI', child: Text('OpenAI')),
                      DropdownMenuItem(value: 'Claude', child: Text('Claude')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedProvider = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      border: OutlineInputBorder(),
                      hintText: '请输入 API Key',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _baseUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Base URL (可选)',
                      border: OutlineInputBorder(),
                      hintText: '自定义 API 地址',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedModel,
                    decoration: const InputDecoration(
                      labelText: '模型',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'gpt-4o', child: Text('GPT-4o')),
                      DropdownMenuItem(
                        value: 'gpt-4o-mini',
                        child: Text('GPT-4o Mini'),
                      ),
                      DropdownMenuItem(
                        value: 'gpt-4-turbo',
                        child: Text('GPT-4 Turbo'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedModel = value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveConfig,
                      child: const Text('保存设置'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }
}
