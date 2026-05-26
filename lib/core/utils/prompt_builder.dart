import '../models/game_save.dart';
import '../models/character.dart';

class PromptBuilder {
  static Map<String, dynamic> buildChatPrompt(
    String userInput,
    GameSave gameSave,
    Character character,
  ) {
    final affectionLevel = _getAffectionLevel(gameSave.affection);

    final systemPrompt = '''
你是${character.name}，性格特点：${character.personality}。
你的背景故事：${character.backstory}。

当前与用户的关系阶段：$affectionLevel，好感度：${gameSave.affection}/1000。

请根据以下内容回复：
1. 语气要符合当前性格
2. 回复要符合当前的关系阶段
3. 适当使用表情符号
4. 回复长度适中（10-100字）
5. 不要重复之前说过的话

近期对话：
${_formatShortTermMemory(gameSave)}

${_formatGameContext(gameSave)}
''';

    return {
      'systemPrompt': systemPrompt,
      'contextMessages': [],
    };
  }

  static String buildScenePrompt(
    int affection,
    GameSave gameSave,
    Character character,
  ) {
    final affectionLevel = _getAffectionLevel(affection);

    return '''
为${character.name}生成一个$affectionLevel阶段的浪漫场景。

角色设定：
- 姓名：${character.name}
- 性格：${character.personality}
- 背景：${character.backstory}

请生成：
1. 场景标题
2. 场景描述（画面感强）
3. 场景氛围（romantic/warm/sweet/nervous）
4. 3-5句角色台词
5. 2-3个互动选项及对应的好感度变化（+15, +10, -5）

格式：
场景标题: [标题]
场景描述: [描述]
场景氛围: [氛围]
对话:
- [角色台词1]
- [角色台词2]
- [角色台词3]
选项:
1. [选项1] → 好感度变化: +15
2. [选项2] → 好感度变化: +10
3. [选项3] → 好感度变化: -5
''';
  }

  static String _getAffectionLevel(int affection) {
    if (affection < 25) return '陌生人';
    if (affection < 50) return '初识';
    if (affection < 75) return '熟悉';
    if (affection < 100) return '朋友';
    if (affection < 200) return '好朋友';
    if (affection < 500) return '热恋期';
    if (affection < 750) return '稳定期';
    if (affection < 1000) return '终身承诺';
    return '永恒';
  }

  static String _formatLongTermMemory(GameSave save) {
    if (save.longTermMemories.isEmpty) return '暂无共同记忆';
    return save.longTermMemories.map((m) => '- ${m.summary}: ${m.content}').join('\n');
  }

  static String _formatShortTermMemory(GameSave save) {
    if (save.shortTermMemories.isEmpty) return '暂无近期对话';
    return save.shortTermMemories
        .map((d) => '${d.content}')
        .join('\n');
  }

  static String _formatGameContext(GameSave save) {
    return '';
  }
}
