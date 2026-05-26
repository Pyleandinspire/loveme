import '../models/emotion_state.dart';

class EmotionManager {
  // 分析文本情感（简化实现）
  Map<String, double> analyzeEmotion(String text) {
    final emotions = {
      'happy': 0.0,
      'sad': 0.0,
      'angry': 0.0,
      'fearful': 0.0,
      'surprised': 0.0,
      'disgusted': 0.0,
    };

    // 简单关键词匹配
    final happyKeywords = ['开心', '高兴', '快乐', '喜欢', '爱你', '真好', '棒'];
    final sadKeywords = ['难过', '伤心', '悲伤', '哭泣', '哭'];
    final angryKeywords = ['生气', '愤怒', '讨厌', '烦'];
    final surprisedKeywords = ['惊讶', '吃惊', '哇', '什么'];
    final disgustedKeywords = ['恶心', '讨厌', '厌恶'];

    for (final keyword in happyKeywords) {
      if (text.contains(keyword)) {
        emotions['happy'] = (emotions['happy']! + 10).clamp(0, 100);
      }
    }

    for (final keyword in sadKeywords) {
      if (text.contains(keyword)) {
        emotions['sad'] = (emotions['sad']! + 10).clamp(0, 100);
      }
    }

    for (final keyword in angryKeywords) {
      if (text.contains(keyword)) {
        emotions['angry'] = (emotions['angry']! + 10).clamp(0, 100);
      }
    }

    for (final keyword in surprisedKeywords) {
      if (text.contains(keyword)) {
        emotions['surprised'] = (emotions['surprised']! + 10).clamp(0, 100);
      }
    }

    for (final keyword in disgustedKeywords) {
      if (text.contains(keyword)) {
        emotions['disgusted'] = (emotions['disgusted']! + 10).clamp(0, 100);
      }
    }

    return emotions;
  }

  // 更新情感状态
  EmotionState updateEmotion(EmotionState state, String text) {
    final emotions = analyzeEmotion(text);

    emotions.forEach((emotion, value) {
      if (value > 0) {
        state.updateEmotion(emotion, value);
      }
    });

    return state;
  }

  // 应用情感衰减
  EmotionState applyDecay(EmotionState state) {
    state.decay();
    return state;
  }

  // 获取情感描述
  String getEmotionDescription(EmotionState state) {
    final dominant = state.dominantEmotion;

    switch (dominant) {
      case 'happy':
        return '开心';
      case 'sad':
        return '难过';
      case 'angry':
        return '生气';
      case 'fearful':
        return '害怕';
      case 'surprised':
        return '惊讶';
      case 'disgusted':
        return '厌恶';
      default:
        return '平静';
    }
  }

  // 创建新的情感状态
  EmotionState createEmotionState(String characterId) {
    return EmotionState(characterId: characterId);
  }
}
