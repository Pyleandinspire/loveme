import '../models/emotion_state.dart';
import '../models/game_save.dart';

class EmotionManager {
  void updateEmotion(GameSave save, String emotion, int delta) {
    final emotionState = _getEmotionState(save);
    switch (emotion) {
      case 'happy':
        emotionState.happy = (emotionState.happy + delta).clamp(0, 100);
        break;
      case 'shy':
        emotionState.shy = (emotionState.shy + delta).clamp(0, 100);
        break;
      case 'angry':
        emotionState.angry = (emotionState.angry + delta).clamp(0, 100);
        break;
      case 'sad':
        emotionState.sad = (emotionState.sad + delta).clamp(0, 100);
        break;
      case 'coquettish':
        emotionState.coquettish = (emotionState.coquettish + delta).clamp(0, 100);
        break;
    }
    emotionState.lastUpdated = DateTime.now();
    save.emotionState = emotionState.toMap();
  }

  EmotionState _getEmotionState(GameSave save) {
    if (save.emotionState.isEmpty) {
      return EmotionState(lastUpdated: DateTime.now());
    }
    return EmotionState(
      happy: save.emotionState['happy'] ?? 0,
      shy: save.emotionState['shy'] ?? 0,
      angry: save.emotionState['angry'] ?? 0,
      sad: save.emotionState['sad'] ?? 0,
      coquettish: save.emotionState['coquettish'] ?? 0,
      lastUpdated: DateTime.now(),
    );
  }

  void decayEmotions(GameSave save) {
    final emotionState = _getEmotionState(save);
    final now = DateTime.now();
    final timeSinceLastUpdate = now.difference(emotionState.lastUpdated);

    if (timeSinceLastUpdate.inMinutes >= 1) {
      final decayRate = timeSinceLastUpdate.inMinutes * 2;
      emotionState.happy = (emotionState.happy - decayRate).clamp(0, 100);
      emotionState.shy = (emotionState.shy - decayRate).clamp(0, 100);
      emotionState.angry = (emotionState.angry - decayRate).clamp(0, 100);
      emotionState.sad = (emotionState.sad - decayRate).clamp(0, 100);
      emotionState.coquettish = (emotionState.coquettish - decayRate).clamp(0, 100);
      emotionState.lastUpdated = now;
      save.emotionState = emotionState.toMap();
    }
  }
}
