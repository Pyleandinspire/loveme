import '../models/game_save.dart';
import '../models/memory_entry.dart';
import '../models/dialogue.dart';

class MemoryManager {
  static const int maxShortTermMemories = 15;
  static const int maxMediumTermMemories = 50;

  // 添加短期记忆
  void addShortTermMemory(GameSave save, DialogueRecord dialogue) {
    final memory = MemoryEntry(
      id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
      content: '${dialogue.speaker}: ${dialogue.content}',
      summary: _generateSummary(dialogue.content),
      timestamp: DateTime.now(),
      type: 'short',
    );

    save.shortTermMemories.add(memory);

    // 如果超过上限，压缩后移入中期记忆
    if (save.shortTermMemories.length > maxShortTermMemories) {
      _moveToMediumTerm(save);
    }
  }

  // 移动到中期记忆
  void _moveToMediumTerm(GameSave save) {
    if (save.shortTermMemories.isEmpty) return;

    final oldMemory = save.shortTermMemories.removeAt(0);
    final compressedMemory = MemoryEntry(
      id: 'med_${DateTime.now().millisecondsSinceEpoch}',
      content: oldMemory.content,
      summary: _compressDialogue(
        save.shortTermMemories.map((m) => m.content).toList(),
      ),
      timestamp: DateTime.now(),
      type: 'medium',
    );

    save.mediumTermMemories.add(compressedMemory);

    // 如果中期记忆超过上限，清理最旧的
    if (save.mediumTermMemories.length > maxMediumTermMemories) {
      save.mediumTermMemories.removeAt(0);
    }
  }

  // 提炼长期记忆
  void extractLongTermMemory(GameSave save) {
    // 从中期记忆中提炼关键信息
    final keyFacts = _extractKeyFacts(save.mediumTermMemories);

    for (final fact in keyFacts) {
      // 检查是否已存在
      final exists = save.longTermMemories.any((m) => m.content == fact);
      if (!exists) {
        save.longTermMemories.add(
          MemoryEntry(
            id: 'long_${DateTime.now().millisecondsSinceEpoch}',
            content: fact,
            summary: fact,
            timestamp: DateTime.now(),
            type: 'long',
          ),
        );
      }
    }
  }

  // 检索记忆
  String retrieveMemories(GameSave save, String query) {
    final memories = StringBuffer();

    // 1. 检索短期记忆
    memories.writeln('\n【短期记忆 - 最近对话】');
    for (final memory in save.shortTermMemories.reversed.take(5)) {
      memories.writeln(memory.content);
    }

    // 2. 检索中期记忆
    memories.writeln('\n【中期记忆 - 对话摘要】');
    for (final memory in save.mediumTermMemories.reversed.take(10)) {
      memories.writeln(memory.summary);
    }

    // 3. 检索长期记忆
    memories.writeln('\n【长期记忆 - 重要事实】');
    for (final memory in save.longTermMemories) {
      memories.writeln('- ${memory.content}');
    }

    return memories.toString();
  }

  // 生成摘要
  String _generateSummary(String content) {
    // 简单实现，实际应用中可以使用AI生成
    if (content.length <= 50) return content;
    return '${content.substring(0, 50)}...';
  }

  // 压缩对话
  String _compressDialogue(List<String> dialogues) {
    if (dialogues.isEmpty) return '';
    if (dialogues.length == 1) return dialogues[0];

    // 简单实现，实际应用中可以使用AI压缩
    return '讨论了${dialogues.length}个话题';
  }

  // 提取关键事实
  List<String> _extractKeyFacts(List<MemoryEntry> mediumMemories) {
    final facts = <String>[];

    // 简单实现，实际应用中可以使用AI分析
    for (final memory in mediumMemories) {
      // 提取关键信息
      if (memory.content.contains('喜欢')) {
        facts.add(memory.content);
      }
      if (memory.content.contains('讨厌')) {
        facts.add(memory.content);
      }
      if (memory.content.contains('想要') ||
          memory.content.contains('希望') ||
          memory.content.contains('想')) {
        facts.add(memory.content);
      }
    }

    return facts.take(5).toList();
  }

  // 获取记忆统计
  Map<String, int> getMemoryStats(GameSave save) {
    return {
      'shortTerm': save.shortTermMemories.length,
      'mediumTerm': save.mediumTermMemories.length,
      'longTerm': save.longTermMemories.length,
    };
  }
}
