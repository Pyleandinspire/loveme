import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_config.dart';
import '../models/game_save.dart';
import '../models/character.dart';
import '../managers/memory_manager.dart';

class AIService {
  final AIConfig config;
  final MemoryManager _memoryManager = MemoryManager();

  AIService(this.config);

  // 流式生成回复
  Stream<String> streamResponse(
    String userInput,
    GameSave save,
    Character character,
  ) async* {
    final prompt = _buildPrompt(userInput, save, character);

    try {
      final response = await _sendRequest(prompt);

      // 模拟流式输出
      for (int i = 0; i < response.length; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        yield response[i];
      }
    } catch (e) {
      yield '抱歉，我现在有点累了，我们改天再聊吧。';
    }
  }

  // 发送API请求
  Future<String> _sendRequest(String prompt) async {
    final url = config.baseUrl ?? _getDefaultUrl(config.provider);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${config.apiKey}',
    };

    final body = jsonEncode({
      'model': config.model,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'stream': false,
      'max_tokens': 1000,
      'temperature': 0.9,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('API request failed: ${response.statusCode}');
    }
  }

  // 构建Prompt
  String _buildPrompt(String userInput, GameSave save, Character character) {
    final memories = _memoryManager.retrieveMemories(save, userInput);

    final prompt = '''
【角色设定】
你扮演的是${character.name}，一个${character.personality}的女孩。
角色背景：${character.backstory}
外貌描述：${character.appearanceDescription}

【性格特征】
${_formatTraits(character.traits)}

【当前关系】
好感度：${save.affection}
关系阶段：${_getAffectionLevel(save.affection)}
对话风格：${_getDialogueStyle(save.affection)}

【记忆系统】
$memories

【对话历史】
${_formatDialogueHistory(save.dialogueHistory)}

【用户输入】
$userInput

【回复要求】
1. 根据角色设定和当前关系阶段回复
2. 保持角色一致性，使用符合角色性格的说话方式
3. 适当融入情感变化
4. 回复长度适中（50-200字）
5. 结束时不要添加多余说明

请以${character.name}的身份回复：
''';

    return prompt;
  }

  // 格式化性格特征
  String _formatTraits(Map<String, int> traits) {
    final buffer = StringBuffer();
    traits.forEach((key, value) {
      buffer.writeln('- $key: $value');
    });
    return buffer.toString();
  }

  // 格式化对话历史
  String _formatDialogueHistory(List<dynamic> history) {
    final buffer = StringBuffer();
    final items = history.length > 10 ? history.sublist(history.length - 10) : history;
    for (final dialogue in items) {
      buffer.writeln('${dialogue.speaker}: ${dialogue.content}');
    }
    return buffer.toString();
  }

  // 获取好感度等级
  String _getAffectionLevel(int affection) {
    if (affection < 25) return '陌生人';
    if (affection < 50) return '初识';
    if (affection < 75) return '熟悉';
    if (affection < 100) return '朋友';
    if (affection < 125) return '好朋友';
    if (affection < 150) return '暧昧初期';
    if (affection < 175) return '暧昧升温';
    if (affection < 200) return '告白前夕';
    if (affection < 250) return '恋人初期';
    if (affection < 500) return '热恋期';
    if (affection < 750) return '稳定期';
    if (affection < 1000) return '终身承诺';
    return '永恒结局';
  }

  // 获取对话风格
  String _getDialogueStyle(int affection) {
    if (affection < 25) return '礼貌、疏远、正式';
    if (affection < 50) return '好奇、试探、礼貌';
    if (affection < 100) return '友好、轻松、关心';
    if (affection < 150) return '暧昧、试探、心跳';
    if (affection < 250) return '甜蜜、亲昵、热恋';
    if (affection < 750) return '温馨、默契、未来规划';
    return '深情、责任、一生约定';
  }

  // 获取默认URL
  String _getDefaultUrl(String provider) {
    switch (provider) {
      case 'openai':
        return 'https://api.openai.com/v1/chat/completions';
      case 'claude':
        return 'https://api.anthropic.com/v1/messages';
      default:
        return 'https://api.openai.com/v1/chat/completions';
    }
  }

  // 测试API连接
  Future<bool> testConnection() async {
    try {
      final url = config.baseUrl ?? _getDefaultUrl(config.provider);

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${config.apiKey}',
      };

      final body = jsonEncode({
        'model': config.model,
        'messages': [
          {'role': 'user', 'content': 'Hi'}
        ],
        'max_tokens': 5,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
