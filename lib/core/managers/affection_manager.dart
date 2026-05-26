import '../models/game_save.dart';
import '../constants/app_constants.dart';

class AffectionManager {
  int getCurrentAffection(GameSave save) => save.affection;

  bool canAddAffection(GameSave save, int amount) {
    final today = DateTime.now().toLocal().toString().substring(0, 10);
    final lastDate = save.lastInteractionTimestamp?.toLocal().toString().substring(0, 10);

    if (lastDate != today) {
      save.dailyAffectionGainedFromGames = 0;
      save.dailyAffectionGainedFromFocus = 0;
    }

    return save.affection + amount <= AppConstants.maxAffection;
  }

  void addAffection(
    GameSave save,
    int amount, {
    bool isFromGames = false,
    bool isFromFocus = false,
  }) {
    if (!canAddAffection(save, amount)) {
      amount = AppConstants.maxAffection - save.affection;
    }

    save.affection += amount;
    if (isFromGames) save.dailyAffectionGainedFromGames += amount;
    if (isFromFocus) save.dailyAffectionGainedFromFocus += amount;
    save.lastInteractionTimestamp = DateTime.now();
  }

  String getAffectionLevelName(int affection) {
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

  bool hasReachedNewMilestone(GameSave save, int previousAffection) {
    for (final milestone in AppConstants.milestoneThresholds) {
      if (milestone > previousAffection && milestone <= save.affection) {
        return true;
      }
    }
    return false;
  }

  bool hasReachedEnding(int affection) => affection >= 1000;
}
