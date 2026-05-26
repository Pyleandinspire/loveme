import '../models/game_save.dart';
import '../models/memory_entry.dart';
import '../models/dialogue.dart';
import '../constants/app_constants.dart';

class MemoryManager {
  void addShortTermMemory(GameSave save, DialogueRecord dialogue) {
    save.shortTermMemory.add(dialogue);
    if (save.shortTermMemory.length > AppConstants.shortTermMemoryLimit) {
      final oldestDialogue = save.shortTermMemory.removeAt(0);
      _compressToMediumTerm(save, oldestDialogue);
    }
  }

  void _compressToMediumTerm(GameSave save, DialogueRecord dialogue) {
    final summary =
        '${dialogue.speaker}: ${dialogue.content.substring(0, dialogue.content.length > 50 ? 50 : dialogue.content.length)}...';
    save.mediumTermMemory.add(summary);
    if (save.mediumTermMemory.length > AppConstants.mediumTermMemoryLimit) {
      save.mediumTermMemory.removeAt(0);
    }
  }

  void addLongTermMemory(GameSave save, String key, String value, String source) {
    final existingIndex = save.longTermMemory.indexWhere((m) => m.key == key);
    if (existingIndex >= 0) {
      save.longTermMemory.removeAt(existingIndex);
    }

    save.longTermMemory.add(MemoryEntry(
      key: key,
      value: value,
      source: source,
      timestamp: DateTime.now(),
    ));
  }

  List<String> getRelevantMemories(GameSave save, String query) {
    final List<String> memories = [];

    for (final entry in save.longTermMemory) {
      if (query.toLowerCase().contains(entry.key.toLowerCase()) ||
          entry.value.toLowerCase().contains(query.toLowerCase())) {
        memories.add('${entry.key}: ${entry.value}');
      }
    }

    return memories;
  }
}
