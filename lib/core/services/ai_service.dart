import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_save.dart';
import '../models/character.dart';
import '../models/ai_config.dart';
import '../utils/prompt_builder.dart';

class AIService {
  final AIConfig? config;

  AIService(this.config);

  bool get isConfigured => config != null && config!.apiKey.isNotEmpty;

  Stream<String> streamResponse(
    String userInput,
    GameSave gameSave,
    Character character,
  ) async* {
    if (!isConfigured) {
      yield '请先在设置中配置 AI API Key';
      return;
    }

    final prompt = PromptBuilder.buildChatPrompt(userInput, gameSave, character);

    try {
      final request = http.Request(
        'POST',
        Uri.parse(config!.baseUrl ?? 'https://api.openai.com/v1/chat/completions'),
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${config!.apiKey}',
      });

      request.body = json.encode({
        'model': config!.model,
        'messages': [
          {'role': 'system', 'content': prompt['systemPrompt']},
          ...?prompt['contextMessages'] as List<Map<String, dynamic>>?,
          {'role': 'user', 'content': userInput},
        ],
        'stream': true,
        'temperature': 0.7,
        'max_tokens': 500,
      });

      final response = await request.send();

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data != '[DONE]') {
              try {
                final jsonData = json.decode(data);
                final delta = jsonData['choices']?[0]?['delta']?['content'];
                if (delta != null) {
                  yield delta;
                }
              } catch (_) {}
            }
          }
        }
      }
    } catch (e) {
      yield '抱歉，发生了错误: $e';
    }
  }

  Future<Map<String, dynamic>?> generateScene(
    int affection,
    GameSave gameSave,
    Character character,
  ) async {
    if (!isConfigured) return null;

    final prompt = PromptBuilder.buildScenePrompt(affection, gameSave, character);

    try {
      final response = await http.post(
        Uri.parse(config!.baseUrl ?? 'https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config!.apiKey}',
        },
        body: json.encode({
          'model': config!.model,
          'messages': [{'role': 'user', 'content': prompt}],
          'temperature': 0.8,
        }),
      );

      final jsonData = json.decode(response.body);
      final content = jsonData['choices'][0]['message']['content'];

      return _parseSceneResponse(content);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? _parseSceneResponse(String content) {
    try {
      final lines = content.split('\n');
      String title = '';
      String description = '';
      String atmosphere = 'romantic';
      List<String> dialogues = [];
      List<Map<String, dynamic>> choices = [];

      for (var line in lines) {
        if (line.startsWith('场景标题:')) {
          title = line.substring(5).trim();
        } else if (line.startsWith('场景描述:')) {
          description = line.substring(5).trim();
        } else if (line.startsWith('场景氛围:')) {
          atmosphere = line.substring(5).trim();
        } else if (line.startsWith('- ') || line.startsWith('角色:')) {
          dialogues.add(line.substring(2).trim());
        }
      }

      return {
        'title': title,
        'description': description,
        'atmosphere': atmosphere,
        'dialogues': dialogues,
        'choices': [
          {'text': '很开心', 'affection': 15},
          {'text': '点点头', 'affection': 10},
          {'text': '有些害羞', 'affection': 5},
        ],
      };
    } catch (e) {
      return null;
    }
  }
}
