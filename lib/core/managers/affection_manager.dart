import '../models/game_save.dart';

class AffectionManager {
  // 好感度等级定义
  static const Map<int, String> affectionLevels = {
    0: '陌生人',
    25: '初识',
    50: '熟悉',
    75: '朋友',
    100: '好朋友',
    125: '暧昧初期',
    150: '暧昧升温',
    175: '告白前夕',
    200: '恋人初期',
    250: '热恋期',
    500: '稳定期',
    750: '终身承诺',
    1000: '永恒结局',
  };

  // 对话风格定义
  static const Map<int, String> dialogueStyles = {
    0: '礼貌、疏远、正式',
    25: '好奇、试探、礼貌',
    50: '友好、轻松、关心',
    75: '亲密、分享、信任',
    100: '亲密、关心、默契',
    125: '暧昧、试探、心跳',
    150: '暧昧、撒娇、暗示',
    175: '紧张、期待、深情',
    200: '甜蜜、亲昵、热恋',
    250: '甜蜜、依赖、承诺',
    500: '温馨、默契、未来规划',
    750: '深情、责任、一生约定',
    1000: '永恒、圆满、专属结局',
  };

  // 每日好感度上限
  static const int dailyAffectionLimit = 100;

  // 获取当前等级名称
  String getAffectionLevelName(int affection) {
    int level = 0;
    for (final entry in affectionLevels.entries) {
      if (affection >= entry.key && entry.key > level) {
        level = entry.key;
      }
    }
    return affectionLevels[level] ?? '陌生人';
  }

  // 获取对话风格
  String getDialogueStyle(int affection) {
    int level = 0;
    for (final entry in dialogueStyles.entries) {
      if (affection >= entry.key && entry.key > level) {
        level = entry.key;
      }
    }
    return dialogueStyles[level] ?? '礼貌、疏远、正式';
  }

  // 检查是否达到新的里程碑
  bool checkMilestone(int oldAffection, int newAffection) {
    // 每25点触发一次里程碑事件
    final oldMilestone = (oldAffection / 25).floor();
    final newMilestone = (newAffection / 25).floor();
    return newMilestone > oldMilestone;
  }

  // 获取下一个里程碑
  int getNextMilestone(int currentAffection) {
    final currentMilestone = (currentAffection / 25).floor() + 1;
    return currentMilestone * 25;
  }

  // 获取进度百分比
  double getProgress(int currentAffection) {
    return (currentAffection / 1000).clamp(0.0, 1.0);
  }

  // 计算好感度变化
  int calculateAffectionChange(String conversationType) {
    switch (conversationType) {
      case 'greeting':
        return _randomInRange(2, 5); // 友好问候
      case 'care':
        return _randomInRange(5, 10); // 关心体贴
      case 'humor':
        return _randomInRange(3, 8); // 幽默风趣
      case 'deep':
        return _randomInRange(8, 15); // 深入交流
      case 'gift':
        return _randomInRange(10, 20); // 送礼物
      case 'game_win':
        return _randomInRange(10, 20); // 小游戏胜利
      case 'game_lose':
        return _randomInRange(-10, -5); // 小游戏失败
      case 'negative':
        return _randomInRange(-15, -5); // 负面对话
      default:
        return 0;
    }
  }

  // 添加好感度
  void addAffection(GameSave save, int amount) {
    final newAffection = (save.affection + amount).clamp(0, 1000);
    save.affection = newAffection;
  }

  // 减少好感度
  void reduceAffection(GameSave save, int amount) {
    final newAffection = (save.affection - amount).clamp(0, 1000);
    save.affection = newAffection;
  }

  // 应用好感度衰减（连续未登录）
  void applyDecay(GameSave save, int daysSinceLastPlay) {
    if (daysSinceLastPlay >= 7) {
      final decayRate = 0.05 * (daysSinceLastPlay - 6); // 每天衰减5%
      final decayFactor = (1 - decayRate).clamp(0.5, 1.0); // 最多衰减至50%
      save.affection = (save.affection * decayFactor).round();
    }
  }

  // 获取等级进度（用于显示）
  Map<String, dynamic> getLevelProgress(int currentAffection) {
    int currentLevel = 0;
    int nextLevel = 25;

    for (final entry in affectionLevels.entries) {
      if (currentAffection >= entry.key && entry.key > currentLevel) {
        currentLevel = entry.key;
      }
    }

    // 找到下一个等级
    for (final entry in affectionLevels.entries) {
      if (entry.key > currentAffection) {
        nextLevel = entry.key;
        break;
      }
    }

    final progress = currentAffection - currentLevel;
    final total = nextLevel - currentLevel;
    final percentage = total > 0 ? progress / total : 1.0;

    return {
      'currentLevel': currentLevel,
      'nextLevel': nextLevel,
      'levelName': getAffectionLevelName(currentAffection),
      'progress': progress,
      'total': total,
      'percentage': percentage,
    };
  }

  // 随机数生成辅助方法
  int _randomInRange(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }
}
