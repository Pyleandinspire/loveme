# LoveMe - 实现指南

本文档详细说明如何根据 [spec.md](file:///workspace/spec.md) 实现完整的 LoveMe Flutter 应用。

## 实施步骤

### 第 1 阶段：项目初始化
1. 创建新的 Flutter 项目
2. 配置依赖
3. 设置项目结构
4. 配置开发环境

### 第 2 阶段：基础架构和存储
1. 实现数据模型
2. 配置 Hive 和 SharedPreferences
3. 实现存储服务
4. 设置加密机制

### 第 3 阶段：核心管理器
1. 实现 CharacterManager
2. 实现 MemoryManager
3. 实现 AffectionManager
4. 实现 EmotionManager
5. 实现 DialogueManager
6. 实现 SceneManager
7. 实现 MiniGameManager

### 第 4 阶段：AI 服务集成
1. 实现 AI 服务接口
2. 配置 API 配置和加密
3. 实现流式响应处理
4. 实现提示词管理

### 第 5 阶段：UI 实现
1. 实现欢迎页
2. 实现角色选择页
3. 实现主游戏页（聊天界面）
4. 实现场景界面
5. 实现设置页
6. 实现小游戏界面
7. 实现伴学系统界面

### 第 6 阶段：功能完善和测试
1. 集成所有模块
2. 实现存档和加载
3. 实现成就系统
4. 测试和优化

---

## 项目结构

完整的项目文件结构：

```
loveme/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── hive_constants.dart
│   │   ├── models/
│   │   │   ├── character.dart
│   │   │   ├── dialogue.dart
│   │   │   ├── game_save.dart
│   │   │   ├── memory_entry.dart
│   │   │   ├── emotion_state.dart
│   │   │   ├── focus_record.dart
│   │   │   ├── dynamic_event_record.dart
│   │   │   ├── mini_game_record.dart
│   │   │   └── ai_config.dart
│   │   ├── managers/
│   │   │   ├── character_manager.dart
│   │   │   ├── dialogue_manager.dart
│   │   │   ├── affection_manager.dart
│   │   │   ├── emotion_manager.dart
│   │   │   ├── memory_manager.dart
│   │   │   ├── scene_manager.dart
│   │   │   └── mini_game_manager.dart
│   │   ├── services/
│   │   │   ├── ai_service.dart
│   │   │   ├── storage_service.dart
│   │   │   └── speech_service.dart
│   │   └── utils/
│   │       └── prompt_builder.dart
│   └── ui/
│       ├── screens/
│       │   ├── welcome_screen.dart
│       │   ├── character_select_screen.dart
│       │   ├── main_game_screen.dart
│       │   ├── scene_screen.dart
│       │   ├── settings_screen.dart
│       │   ├── ending_screen.dart
│       │   └── mini_games/
│       │       ├── mini_game_menu.dart
│       │       ├── blackjack_screen.dart
│       │       ├── idiom_solitaire_screen.dart
│       │       └── focus_timer_screen.dart
│       └── widgets/
│           ├── affection_bar.dart
│           ├── dialogue_bubble.dart
│           └── streaming_dialogue_bubble.dart
├── assets/
│   ├── characters.json
│   ├── idioms.json
│   ├── avatars/
│   └── portraits/
└── pubspec.yaml
```

---

## 详细实施计划

### 1. pubspec.yaml 配置

```yaml
name: loveme
description: AI驱动的恋爱模拟游戏
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  http: ^1.1.0
  speech_to_text: ^6.6.0
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

### 2. 数据模型 (core/models/)

#### character.dart
```dart
import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 7)
class Character {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String avatar;

  @HiveField(3)
  String portrait;

  @HiveField(4)
  String personality;

  @HiveField(5)
  String description;

  @HiveField(6)
  String backstory;

  @HiveField(7)
  Map<String, int> traits;

  @HiveField(8)
  String appearanceDescription;

  @HiveField(9)
  List<String> referenceImagePaths;

  @HiveField(10)
  bool isCustom;

  Character({
    required this.id,
    required this.name,
    required this.avatar,
    required this.portrait,
    required this.personality,
    required this.description,
    required this.backstory,
    required this.traits,
    required this.appearanceDescription,
    required this.referenceImagePaths,
    required this.isCustom,
  });

  static Character fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      portrait: json['portrait'] as String,
      personality: json['personality'] as String,
      description: json['description'] as String,
      backstory: json['backstory'] as String,
      traits: Map<String, int>.from(json['traits'] as Map),
      appearanceDescription: json['appearanceDescription'] as String? ?? '',
      referenceImagePaths: (json['referenceImagePaths'] as List?)?.map((e) => e as String).toList() ?? [],
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }
}
```

#### dialogue.dart
```dart
import 'package:hive/hive.dart';

part 'dialogue.g.dart';

@HiveType(typeId: 1)
class DialogueRecord extends HiveObject {
  @HiveField(0)
  String speaker;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  int affectionChange;

  DialogueRecord({
    required this.speaker,
    required this.content,
    required this.timestamp,
    this.affectionChange = 0,
  });
}
```

#### game_save.dart
```dart
import 'package:hive/hive.dart';
import 'dialogue.dart';
import 'memory_entry.dart';
import 'focus_record.dart';
import 'dynamic_event_record.dart';

part 'game_save.g.dart';

@HiveType(typeId: 0)
class GameSave extends HiveObject {
  @HiveField(0)
  String currentCharacterId;

  @HiveField(1)
  int affection;

  @HiveField(2)
  List<DialogueRecord> dialogueHistory;

  @HiveField(3)
  DateTime lastPlayTime;

  @HiveField(4)
  Map<String, dynamic> emotionState;

  @HiveField(5)
  List<DialogueRecord> shortTermMemory;

  @HiveField(6)
  List<String> mediumTermMemory;

  @HiveField(7)
  List<MemoryEntry> longTermMemory;

  @HiveField(8)
  List<DynamicEventRecord> generatedEvents;

  @HiveField(9)
  int playthroughNumber;

  @HiveField(10)
  List<FocusRecord> focusHistory;

  @HiveField(11)
  int totalFocusMinutes;

  @HiveField(12)
  int dailyAffectionGainedFromGames;

  @HiveField(13)
  int dailyAffectionGainedFromFocus;

  @HiveField(14)
  DateTime? lastInteractionTimestamp;

  @HiveField(15)
  String? lastGameContextTag;

  GameSave({
    required this.currentCharacterId,
    this.affection = 0,
    this.dialogueHistory = const [],
    required this.lastPlayTime,
    this.emotionState = const {},
    this.shortTermMemory = const [],
    this.mediumTermMemory = const [],
    this.longTermMemory = const [],
    this.generatedEvents = const [],
    this.playthroughNumber = 1,
    this.focusHistory = const [],
    this.totalFocusMinutes = 0,
    this.dailyAffectionGainedFromGames = 0,
    this.dailyAffectionGainedFromFocus = 0,
    this.lastInteractionTimestamp,
    this.lastGameContextTag,
  });
}
```

#### memory_entry.dart
```dart
import 'package:hive/hive.dart';

part 'memory_entry.g.dart';

@HiveType(typeId: 4)
class MemoryEntry extends HiveObject {
  @HiveField(0)
  String key;

  @HiveField(1)
  String value;

  @HiveField(2)
  String source;

  @HiveField(3)
  DateTime timestamp;

  MemoryEntry({
    required this.key,
    required this.value,
    required this.source,
    required this.timestamp,
  });
}
```

#### emotion_state.dart
```dart
import 'package:hive/hive.dart';

part 'emotion_state.g.dart';

@HiveType(typeId: 8)
class EmotionState extends HiveObject {
  @HiveField(0)
  int happy;

  @HiveField(1)
  int shy;

  @HiveField(2)
  int angry;

  @HiveField(3)
  int sad;

  @HiveField(4)
  int coquettish;

  @HiveField(5)
  DateTime lastUpdated;

  EmotionState({
    this.happy = 0,
    this.shy = 0,
    this.angry = 0,
    this.sad = 0,
    this.coquettish = 0,
    required this.lastUpdated,
  });

  Map<String, int> toMap() {
    return {
      'happy': happy,
      'shy': shy,
      'angry': angry,
      'sad': sad,
      'coquettish': coquettish,
    };
  }
}
```

#### focus_record.dart
```dart
import 'package:hive/hive.dart';

part 'focus_record.g.dart';

@HiveType(typeId: 5)
class FocusRecord extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  int durationMinutes;

  @HiveField(2)
  String taskLabel;

  @HiveField(3)
  bool isSuccess;

  @HiveField(4)
  String characterId;

  FocusRecord({
    required this.startTime,
    required this.durationMinutes,
    required this.taskLabel,
    required this.isSuccess,
    required this.characterId,
  });
}
```

#### dynamic_event_record.dart
```dart
import 'package:hive/hive.dart';

part 'dynamic_event_record.g.dart';

@HiveType(typeId: 6)
class DynamicEventRecord extends HiveObject {
  @HiveField(0)
  String eventId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String narrativeText;

  @HiveField(3)
  String? localCgImagePath;

  @HiveField(4)
  int triggerAffection;

  @HiveField(5)
  List<String> choices;

  @HiveField(6)
  List<int> affectionChanges;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  int playthroughNumber;

  DynamicEventRecord({
    required this.eventId,
    required this.title,
    required this.narrativeText,
    this.localCgImagePath,
    required this.triggerAffection,
    required this.choices,
    required this.affectionChanges,
    required this.createdAt,
    required this.playthroughNumber,
  });
}
```

#### mini_game_record.dart
```dart
import 'package:hive/hive.dart';

part 'mini_game_record.g.dart';

@HiveType(typeId: 2)
class MiniGameRecord extends HiveObject {
  @HiveField(0)
  String gameType;

  @HiveField(1)
  int wins;

  @HiveField(2)
  int losses;

  @HiveField(3)
  int highScore;

  @HiveField(4)
  DateTime lastPlayTime;

  MiniGameRecord({
    required this.gameType,
    this.wins = 0,
    this.losses = 0,
    this.highScore = 0,
    required this.lastPlayTime,
  });
}
```

#### ai_config.dart
```dart
import 'package:hive/hive.dart';

part 'ai_config.g.dart';

@HiveType(typeId: 3)
class AIConfig extends HiveObject {
  @HiveField(0)
  String provider;

  @HiveField(1)
  String apiKey;

  @HiveField(2)
  String model;

  @HiveField(3)
  String? baseUrl;

  @HiveField(4)
  DateTime updatedAt;

  AIConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.baseUrl,
    required this.updatedAt,
  });
}
```

#### focus_record.dart
```dart
import 'package:hive/hive.dart';

part 'focus_record.g.dart';

@HiveType(typeId: 5)
class FocusRecord extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  int durationMinutes;

  @HiveField(2)
  String taskLabel;

  @HiveField(3)
  bool isSuccess;

  @HiveField(4)
  String characterId;

  FocusRecord({
    required this.startTime,
    required this.durationMinutes,
    required this.taskLabel,
    required this.isSuccess,
    required this.characterId,
  });
}
```

#### dynamic_event_record.dart
```dart
import 'package:hive/hive.dart';

part 'dynamic_event_record.g.dart';

@HiveType(typeId: 6)
class DynamicEventRecord extends HiveObject {
  @HiveField(0)
  String eventId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String narrativeText;

  @HiveField(3)
  String? localCgImagePath;

  @HiveField(4)
  int triggerAffection;

  @HiveField(5)
  List<String> choices;

  @HiveField(6)
  List<int> affectionChanges;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  int playthroughNumber;

  DynamicEventRecord({
    required this.eventId,
    required this.title,
    required this.narrativeText,
    this.localCgImagePath,
    required this.triggerAffection,
    required this.choices,
    required this.affectionChanges,
    required this.createdAt,
    required this.playthroughNumber,
  });
}
```

#### mini_game_record.dart
```dart
import 'package:hive/hive.dart';

part 'mini_game_record.g.dart';

@HiveType(typeId: 2)
class MiniGameRecord extends HiveObject {
  @HiveField(0)
  String gameType;

  @HiveField(1)
  int wins;

  @HiveField(2)
  int losses;

  @HiveField(3)
  int highScore;

  @HiveField(4)
  DateTime lastPlayTime;

  MiniGameRecord({
    required this.gameType,
    this.wins = 0,
    this.losses = 0,
    this.highScore = 0,
    required this.lastPlayTime,
  });
}
```

#### ai_config.dart
```dart
import 'package:hive/hive.dart';

part 'ai_config.g.dart';

@HiveType(typeId: 3)
class AIConfig extends HiveObject {
  @HiveField(0)
  String provider;

  @HiveField(1)
  String apiKey;

  @HiveField(2)
  String model;

  @HiveField(3)
  String? baseUrl;

  @HiveField(4)
  DateTime updatedAt;

  AIConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.baseUrl,
    required this.updatedAt,
  });
}
```

#### custom_character_record.dart
```dart
import 'package:hive/hive.dart';

part 'custom_character_record.g.dart';

@HiveType(typeId: 9)
class CustomCharacterRecord extends HiveObject {
  @HiveField(0)
  String customCharacterId;

  @HiveField(1)
  String baseCharacterId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String personality;

  @HiveField(4)
  String appearanceDescription;

  @HiveField(5)
  List<String> referenceImagePaths;

  @HiveField(6)
  String generatedAvatarPath;

  @HiveField(7)
  String generatedPortraitPath;

  @HiveField(8)
  DateTime createdAt;

  CustomCharacterRecord({
    required this.customCharacterId,
    required this.baseCharacterId,
    required this.name,
    required this.personality,
    required this.appearanceDescription,
    required this.referenceImagePaths,
    required this.generatedAvatarPath,
    required this.generatedPortraitPath,
    required this.createdAt,
  });
}
```

### 3. 常量定义

#### app_constants.dart
```dart
class AppConstants {
  static const int maxAffection = 1000;
  static const int dailyAffectionLimit = 100;
  
  static const List<int> milestoneThresholds = [
    25, 50, 75, 100, 125, 150, 175, 200,
    250, 300, 350, 400, 450, 500,
    550, 600, 650, 700, 750,
    800, 850, 900, 950, 1000
  ];

  static const int shortTermMemoryLimit = 15;
  static const int mediumTermMemoryLimit = 50;

  static const List<int> focusDurations = [25, 30, 45];
  
  static const String idleWhiteNoise = 'idle';
  static const String rainWhiteNoise = 'rain';
  static const String cafeWhiteNoise = 'cafe';
}
```

#### hive_constants.dart
```dart
class HiveConstants {
  static const String gameSaveBox = 'game_save';
  static const String aiConfigBox = 'secure_config';
  static const String miniGameRecordBox = 'mini_game_records';
  static const String charactersBox = 'characters';
}
```

### 4. 核心管理器

#### affection_manager.dart
```dart
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

  void addAffection(GameSave save, int amount, {bool isFromGames = false, bool isFromFocus = false}) {
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
```

#### emotion_manager.dart
```dart
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
```

#### memory_manager.dart
```dart
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
    final summary = '${dialogue.speaker}: ${dialogue.content.substring(0, dialogue.content.length > 50 ? 50 : dialogue.content.length)}...';
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
```

#### character_manager.dart
```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/character.dart';

class CharacterManager {
  List<Character> _characters = [];

  Future<List<Character>> loadCharacters() async {
    if (_characters.isNotEmpty) return _characters;
    
    final jsonString = await rootBundle.loadString('assets/characters.json');
    final jsonData = json.decode(jsonString);
    final charactersJson = jsonData['characters'] as List;
    
    _characters = charactersJson
        .map((json) => Character.fromJson(json as Map<String, dynamic>))
        .toList();
    
    return _characters;
  }

  Character? getCharacterById(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, int> getDynamicTraits(Character character, Map<String, dynamic> emotionState) {
    final traits = Map<String, int>.from(character.traits);
    traits['gentleness'] = ((traits['gentleness'] ?? 50) - (emotionState['angry'] ?? 0)).clamp(0, 100);
    traits['liveliness'] = ((traits['liveliness'] ?? 50) + (emotionState['happy'] ?? 0) * 0.5).clamp(0, 100).toInt();
    traits['shyness'] = ((traits['shyness'] ?? 50) + (emotionState['shy'] ?? 0)).clamp(0, 100);
    return traits;
  }
}
```

### 5. 服务层

#### storage_service.dart
```dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_save.dart';
import '../models/ai_config.dart';
import '../models/mini_game_record.dart';
import '../models/dialogue.dart';
import '../models/memory_entry.dart';
import '../models/emotion_state.dart';
import '../models/focus_record.dart';
import '../models/dynamic_event_record.dart';
import '../models/character.dart';
import '../models/custom_character_record.dart';
import '../constants/hive_constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Box<GameSave>? _gameSaveBox;
  Box<AIConfig>? _aiConfigBox;
  Box<MiniGameRecord>? _miniGameRecordBox;
  Box<Character>? _charactersBox;
  Box<CustomCharacterRecord>? _customCharacterBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(GameSaveAdapter());
    Hive.registerAdapter(DialogueRecordAdapter());
    Hive.registerAdapter(MemoryEntryAdapter());
    Hive.registerAdapter(EmotionStateAdapter());
    Hive.registerAdapter(FocusRecordAdapter());
    Hive.registerAdapter(DynamicEventRecordAdapter());
    Hive.registerAdapter(MiniGameRecordAdapter());
    Hive.registerAdapter(AIConfigAdapter());
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(CustomCharacterRecordAdapter());

    final encryptionKey = await _getOrCreateEncryptionKey();
    final encryptionCipher = HiveAesCipher(encryptionKey);

    _gameSaveBox = await Hive.openBox<GameSave>(HiveConstants.gameSaveBox);
    _aiConfigBox = await Hive.openBox<AIConfig>(
      HiveConstants.aiConfigBox,
      encryptionCipher: encryptionCipher,
    );
    _miniGameRecordBox = await Hive.openBox<MiniGameRecord>(HiveConstants.miniGameRecordBox);
    _charactersBox = await Hive.openBox<Character>(HiveConstants.charactersBox);
    _customCharacterBox = await Hive.openBox<CustomCharacterRecord>('custom_characters');
  }

  List<CustomCharacterRecord> getCustomCharacters() {
    return _customCharacterBox!.values.toList();
  }

  Future<void> saveCustomCharacter(CustomCharacterRecord character) async {
    await _customCharacterBox!.add(character);
  }

  Future<List<int>> _getOrCreateEncryptionKey() async {
    final keyString = await _secureStorage.read(key: 'hive_encryption_key');
    if (keyString != null) {
      return keyString.split(',').map(int.parse).toList();
    }
    
    final key = Hive.generateSecureKey();
    await _secureStorage.write(
      key: 'hive_encryption_key',
      value: key.join(','),
    );
    return key;
  }

  GameSave? getCurrentSave() {
    if (_gameSaveBox!.isEmpty) return null;
    return _gameSaveBox!.values.last;
  }

  Future<void> saveGame(GameSave save) async {
    await _gameSaveBox!.add(save);
  }

  Future<void> updateGameSave(GameSave save) async {
    if (save.isInBox) {
      await save.save();
    } else {
      await _gameSaveBox!.add(save);
    }
  }

  AIConfig? getAIConfig() {
    if (_aiConfigBox!.isEmpty) return null;
    return _aiConfigBox!.values.first;
  }

  Future<void> saveAIConfig(AIConfig config) async {
    await _aiConfigBox!.clear();
    await _aiConfigBox!.add(config);
  }

  Future<void> savePref(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is String) await prefs.setString(key, value);
    if (value is int) await prefs.setInt(key, value);
    if (value is double) await prefs.setDouble(key, value);
  }

  Future<T?> getPref<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }
}
```

#### ai_service.dart
```dart
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
          {'role': 'system', 'content': prompt.systemPrompt},
          ...prompt.contextMessages,
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

  Future<String?> analyzeImageForAppearance(String base64Image) async {
    if (!isConfigured) return null;

    try {
      final response = await http.post(
        Uri.parse(config!.baseUrl ?? 'https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config!.apiKey}',
        },
        body: json.encode({
          'model': config!.model,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''请分析以下参考图片中的人物外貌特征，并生成一份详细的描述，用于AI绘画生成动漫风格的角色形象。

要求：
1. 详细描述人物的发型、发色、眼睛颜色、脸型、肤色、身材特征
2. 描述人物的穿着风格和常见配饰
3. 描述整体气质和给人的感觉
4. 适合用于日式动漫风格的绘画描述
5. 语言要生动且具体，便于AI绘画理解
6. 字数在150-300字之间

请直接输出外貌描述文本，无需额外格式。'''
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image'
                  }
                }
              ]
            }
          ],
          'temperature': 0.7,
        }),
      );

      final jsonData = json.decode(response.body);
      return jsonData['choices'][0]['message']['content'];
    } catch (e) {
      return null;
    }
  }

  Future<String?> generateCharacterPortrait(
    String characterName,
    String personality,
    String appearanceDescription,
  ) async {
    if (!isConfigured) return null;

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config!.apiKey}',
        },
        body: json.encode({
          'model': 'dall-e-3',
          'prompt': '''日式动漫风格的角色立绘，角色：$characterName，性格：$personality，外貌：$appearanceDescription。

要求：
- 风格：精致的日式动漫风格，线条流畅，色彩柔和
- 角色姿势：自然的站立姿势，面向观众
- 背景：简单的渐变背景，不要喧宾夺主
- 分辨率：1024x1024
- 适合作为游戏角色立绘使用''',
          'n': 1,
          'size': '1024x1024',
        }),
      );

      final jsonData = json.decode(response.body);
      return jsonData['data'][0]['url'];
    } catch (e) {
      return null;
    }
  }
}
```

#### prompt_builder.dart
```dart
import '../models/game_save.dart';
import '../models/character.dart';

class PromptBuilder {
  static Map<String, dynamic> buildChatPrompt(
    String userInput,
    GameSave gameSave,
    Character character,
  ) {
    final emotionState = gameSave.emotionState;
    final affectionLevel = _getAffectionLevel(gameSave.affection);
    
    final systemPrompt = '''
你是${character.name}，性格特点：${character.personality}。
你的背景故事：${character.backstory}。

当前与用户的关系阶段：$affectionLevel，好感度：${gameSave.affection}/1000。
当前情绪状态：开心${emotionState['happy'] ?? 0}%，害羞${emotionState['shy'] ?? 0}%，生气${emotionState['angry'] ?? 0}%，难过${emotionState['sad'] ?? 0}%，撒娇${emotionState['coquettish'] ?? 0}%。

请根据以下内容回复：
1. 语气要符合当前性格和情绪状态
2. 回复要符合当前的关系阶段
3. 适当使用表情符号
4. 回复长度适中（10-100字）
5. 不要重复之前说过的话

共同记忆：
${_formatLongTermMemory(gameSave)}

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
为${character.name}生成一个${affectionLevel}阶段的浪漫场景。

角色设定：
- 姓名：${character.name}
- 性格：${character.personality}
- 背景：${character.backstory}

共同记忆：
${_formatLongTermMemory(gameSave)}

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
    if (save.longTermMemory.isEmpty) return '暂无共同记忆';
    return save.longTermMemory.map((m) => '- ${m.key}: ${m.value}').join('\n');
  }

  static String _formatShortTermMemory(GameSave save) {
    if (save.shortTermMemory.isEmpty) return '暂无近期对话';
    return save.shortTermMemory
        .map((d) => '${d.speaker == "user" ? "用户" : d.speaker}: ${d.content}')
        .join('\n');
  }

  static String _formatGameContext(GameSave save) {
    if (save.lastGameContextTag == null) return '';
    
    final contextDescriptions = {
      'Focus_Success': '玩家刚刚成功完成了专注学习/工作，表现得很棒！请夸奖对方。',
      'Focus_Failed': '玩家刚才在专注时分心了，有些失落。请安慰和鼓励对方。',
      'Blackjack_Win': '玩家刚刚在21点游戏中赢了你！',
      'Blackjack_Lose': '玩家刚刚在21点游戏中输给你了。',
      'Idiom_Win': '玩家在成语接龙中赢了！',
      'Idiom_Lose': '玩家在成语接龙中输了。',
    };
    
    return '[系统提示] ${contextDescriptions[save.lastGameContextTag] ?? ""}';
  }
}
```

### 6. UI 实现

#### main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storage = StorageService();
  await storage.init();
  
  runApp(
    ChangeNotifierProvider.value(
      value: storage,
      child: const MyApp(),
    ),
  );
}
```

#### app.dart
```dart
import 'package:flutter/material.dart';
import 'ui/screens/welcome_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoveMe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
```

#### welcome_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character_select_screen.dart';
import 'main_game_screen.dart';
import '../../core/services/storage_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final hasExistingSave = storage.getCurrentSave() != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LoveMe',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI驱动的恋爱模拟游戏',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CharacterSelectScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('开始恋爱'),
              ),
              if (hasExistingSave) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainGameScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20),
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('继续游戏', style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

#### character_select_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_game_screen.dart';
import 'character_custom_screen.dart';
import '../../core/managers/character_manager.dart';
import '../../core/models/game_save.dart';
import '../../core/services/storage_service.dart';

class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  final CharacterManager _characterManager = CharacterManager();

  @override
  void initState() {
    super.initState();
    _characterManager.loadCharacters();
  }

  Future<void> _startGame(String characterId) async {
    final storage = Provider.of<StorageService>(context, listen: false);
    
    final gameSave = GameSave(
      currentCharacterId: characterId,
      affection: 0,
      dialogueHistory: [],
      lastPlayTime: DateTime.now(),
      emotionState: {},
      shortTermMemory: [],
      mediumTermMemory: [],
      longTermMemory: [],
      generatedEvents: [],
      playthroughNumber: 1,
      focusHistory: [],
      totalFocusMinutes: 0,
      dailyAffectionGainedFromGames: 0,
      dailyAffectionGainedFromFocus: 0,
    );

    await storage.saveGame(gameSave);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainGameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final characters = _characterManager.loadCharacters();
    final customCharacters = Provider.of<StorageService>(context).getCustomCharacters();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择你的心动对象'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: characters.length + customCharacters.length,
                itemBuilder: (context, index) {
                  if (index < characters.length) {
                    final character = characters[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: Image.asset(
                          character.avatar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(character.name),
                        subtitle: Text(character.description),
                        onTap: () => _startGame(character.id),
                      ),
                    );
                  } else {
                    final customChar = customCharacters[index - characters.length];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.pink[50],
                      child: ListTile(
                        leading: customChar.generatedAvatarPath.isNotEmpty
                            ? Image.file(
                                File(customChar.generatedAvatarPath),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person),
                        title: Text(customChar.name),
                        subtitle: const Text('自定义角色'),
                        onTap: () => _startGame(customChar.customCharacterId),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CharacterCustomScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('创建自定义角色'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### main_game_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/managers/affection_manager.dart';
import '../../core/managers/memory_manager.dart';
import '../../core/managers/emotion_manager.dart';
import '../../core/managers/character_manager.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/ai_service.dart';
import '../../core/models/game_save.dart';
import '../../core/models/dialogue.dart';
import '../widgets/affection_bar.dart';
import '../widgets/streaming_dialogue_bubble.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AffectionManager _affectionManager = AffectionManager();
  final MemoryManager _memoryManager = MemoryManager();
  final EmotionManager _emotionManager = EmotionManager();
  final CharacterManager _characterManager = CharacterManager();

  bool _isTyping = false;
  String _streamingText = '';

  @override
  void initState() {
    super.initState();
    _characterManager.loadCharacters();
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty || _isTyping) return;

    final storage = Provider.of<StorageService>(context, listen: false);
    final gameSave = storage.getCurrentSave();
    if (gameSave == null) return;

    final character = _characterManager.getCharacterById(gameSave.currentCharacterId);
    if (character == null) return;

    final userMessage = _textController.text.trim();
    _textController.clear();

    final previousAffection = gameSave.affection;

    final userDialogue = DialogueRecord(
      speaker: 'user',
      content: userMessage,
      timestamp: DateTime.now(),
    );
    gameSave.dialogueHistory.add(userDialogue);
    _memoryManager.addShortTermMemory(gameSave, userDialogue);

    setState(() {
      _isTyping = true;
      _streamingText = '';
    });

    _scrollToBottom();

    final aiConfig = storage.getAIConfig();
    final aiService = AIService(aiConfig);

    final buffer = StringBuffer();
    await for (final chunk in aiService.streamResponse(userMessage, gameSave, character)) {
      buffer.write(chunk);
      setState(() {
        _streamingText = buffer.toString();
      });
      _scrollToBottom();
    }

    final aiDialogue = DialogueRecord(
      speaker: character.name,
      content: buffer.toString(),
      timestamp: DateTime.now(),
      affectionChange: 3,
    );
    gameSave.dialogueHistory.add(aiDialogue);
    _memoryManager.addShortTermMemory(gameSave, aiDialogue);
    _affectionManager.addAffection(gameSave, 3);
    _emotionManager.updateEmotion(gameSave, 'happy', 10);

    setState(() {
      _isTyping = false;
      _streamingText = '';
    });

    gameSave.lastGameContextTag = null;
    gameSave.lastInteractionTimestamp = DateTime.now();
    await storage.updateGameSave(gameSave);

    if (_affectionManager.hasReachedNewMilestone(gameSave, previousAffection)) {
      _triggerScene(gameSave, character);
    }

    if (_affectionManager.hasReachedEnding(gameSave.affection)) {
      _triggerEnding();
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _triggerScene(GameSave gameSave, dynamic character) async {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final storage = Provider.of<StorageService>(context, listen: false);
    final aiConfig = storage.getAIConfig();
    final aiService = AIService(aiConfig);

    final scene = await aiService.generateScene(gameSave.affection, gameSave, character);

    if (mounted) {
      Navigator.pop(context);
      if (scene != null) {
        Navigator.pushNamed(context, '/scene', arguments: scene);
      }
    }
  }

  void _triggerEnding() {
    Navigator.pushNamed(context, '/ending');
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final gameSave = storage.getCurrentSave();
    
    if (gameSave == null) {
      return const Scaffold(
        body: Center(child: Text('没有存档，请重新开始')),
      );
    }

    final character = _characterManager.getCharacterById(gameSave.currentCharacterId);

    return Scaffold(
      appBar: AppBar(
        title: Text(character?.name ?? 'LoveMe'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AffectionBar(
            currentAffection: gameSave.affection,
            levelName: _affectionManager.getAffectionLevelName(gameSave.affection),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: gameSave.dialogueHistory.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == gameSave.dialogueHistory.length && _isTyping) {
                  return StreamingDialogueBubble(text: _streamingText, isUser: false);
                }

                final dialogue = gameSave.dialogueHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment: dialogue.speaker == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: dialogue.speaker == 'user' ? Colors.pink[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(dialogue.content),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '说点什么...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

#### widgets/affection_bar.dart
```dart
import 'package:flutter/material.dart';

class AffectionBar extends StatelessWidget {
  final int currentAffection;
  final String levelName;

  const AffectionBar({
    super.key,
    required this.currentAffection,
    required this.levelName,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentAffection / 1000;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '好感度: $currentAffection/1000',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                levelName,
                style: TextStyle(color: Colors.pink[600], fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[400]!),
          ),
        ],
      ),
    );
  }
}
```

#### widgets/streaming_dialogue_bubble.dart
```dart
import 'package:flutter/material.dart';

class StreamingDialogueBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const StreamingDialogueBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.pink[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(text.isEmpty ? '正在输入...' : text),
        ),
      ),
    );
  }
}
```

#### character_custom_screen.dart
```dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/models/character.dart';
import '../../core/models/custom_character_record.dart';
import '../../core/managers/character_manager.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/ai_service.dart';

class CharacterCustomScreen extends StatefulWidget {
  const CharacterCustomScreen({super.key});

  @override
  State<CharacterCustomScreen> createState() => _CharacterCustomScreenState();
}

class _CharacterCustomScreenState extends State<CharacterCustomScreen> {
  final CharacterManager _characterManager = CharacterManager();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();
  final TextEditingController _appearanceController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<XFile> _selectedImages = [];
  Character? _selectedBaseCharacter;
  String? _generatedPortraitUrl;
  bool _isAnalyzing = false;
  bool _isGenerating = false;

  Future<void> _loadCharacters() async {
    await _characterManager.loadCharacters();
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _analyzeImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    final storage = Provider.of<StorageService>(context, listen: false);
    final aiConfig = storage.getAIConfig();
    final aiService = AIService(aiConfig);

    String? appearanceDescription;

    for (final image in _selectedImages) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      appearanceDescription = await aiService.analyzeImageForAppearance(base64Image);
      if (appearanceDescription != null) break;
    }

    if (appearanceDescription != null) {
      setState(() {
        _appearanceController.text = appearanceDescription!;
      });
    }

    setState(() {
      _isAnalyzing = false;
    });
  }

  Future<void> _generatePortrait() async {
    if (_nameController.text.isEmpty || _appearanceController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    final storage = Provider.of<StorageService>(context, listen: false);
    final aiConfig = storage.getAIConfig();
    final aiService = AIService(aiConfig);

    final portraitUrl = await aiService.generateCharacterPortrait(
      _nameController.text,
      _personalityController.text,
      _appearanceController.text,
    );

    setState(() {
      _generatedPortraitUrl = portraitUrl;
      _isGenerating = false;
    });
  }

  Future<void> _saveCustomCharacter() async {
    if (_nameController.text.isEmpty || _selectedBaseCharacter == null) return;

    final storage = Provider.of<StorageService>(context, listen: false);
    final appDir = await getApplicationDocumentsDirectory();

    List<String> referencePaths = [];
    for (int i = 0; i < _selectedImages.length; i++) {
      final imagePath = '${appDir.path}/saves/references/custom_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final file = File(imagePath);
      await file.create(recursive: true);
      await file.writeAsBytes(await _selectedImages[i].readAsBytes());
      referencePaths.add('/saves/references/custom_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
    }

    String? avatarPath;
    String? portraitPath;
    if (_generatedPortraitUrl != null) {
      final response = await HttpClient().getUrl(Uri.parse(_generatedPortraitUrl!));
      final responseBytes = await response.close().first;
      avatarPath = '${appDir.path}/saves/custom_characters/custom_${DateTime.now().millisecondsSinceEpoch}_avatar.jpg';
      portraitPath = '${appDir.path}/saves/custom_characters/custom_${DateTime.now().millisecondsSinceEpoch}_portrait.jpg';
      await File(avatarPath).writeAsBytes(responseBytes);
      await File(portraitPath).writeAsBytes(responseBytes);
    }

    final customCharacter = CustomCharacterRecord(
      customCharacterId: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      baseCharacterId: _selectedBaseCharacter!.id,
      name: _nameController.text,
      personality: _personalityController.text,
      appearanceDescription: _appearanceController.text,
      referenceImagePaths: referencePaths,
      generatedAvatarPath: avatarPath ?? '',
      generatedPortraitPath: portraitPath ?? '',
      createdAt: DateTime.now(),
    );

    await storage.saveCustomCharacter(customCharacter);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _personalityController.dispose();
    _appearanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建你的专属角色'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('选择基础角色', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _characterManager.loadCharacters().length,
                itemBuilder: (context, index) {
                  final characters = _characterManager.loadCharacters();
                  final character = characters[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedBaseCharacter = character;
                        _nameController.text = character.name;
                        _personalityController.text = character.personality;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedBaseCharacter?.id == character.id
                              ? Colors.pink
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              character.avatar,
                              height: 100,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(character.name),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '角色名字',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _personalityController,
              decoration: const InputDecoration(
                labelText: '性格描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            const Text('上传参考图片', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.photo_library),
              label: const Text('选择图片'),
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImages[index].path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => _removeImage(index),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeImages,
              icon: _isAnalyzing
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.auto_awesome),
              label: Text(_isAnalyzing ? '分析中...' : 'AI分析图片生成外貌描述'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _appearanceController,
              decoration: const InputDecoration(
                labelText: '外貌描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generatePortrait,
              icon: _isGenerating
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.image),
              label: Text(_isGenerating ? '生成中...' : '预览角色形象'),
            ),
            const SizedBox(height: 16),
            if (_generatedPortraitUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _generatedPortraitUrl!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveCustomCharacter,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('确认创建'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7. 资源文件

#### pubspec.yaml 完整版本
```yaml
name: loveme
description: AI驱动的恋爱模拟游戏
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  http: ^1.1.0
  speech_to_text: ^6.6.0
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.1
  image_picker: ^1.0.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.6

flutter:
  uses-material-design: true
  assets:
    - assets/characters.json
    - assets/idioms.json
    - assets/avatars/
    - assets/portraits/
```

#### assets/characters.json 示例
```json
{
  "characters": [
    {
      "id": "char_001",
      "name": "林小雨",
      "avatar": "assets/avatars/xiaoyu.png",
      "portrait": "assets/portraits/xiaoyu.png",
      "personality": "温柔、体贴、有些害羞，喜欢读书和绘画",
      "description": "从小在你家隔壁长大的青梅竹马，现在是美术学院的学生",
      "backstory": "你们从小一起长大，她一直默默喜欢着你。现在她已经成长为一个温柔美丽的女孩，但在你面前依然会害羞。",
      "traits": {
        "gentleness": 85,
        "liveliness": 40,
        "shyness": 60,
        "humor": 50,
        "tsundere": 20
      }
    },
    {
      "id": "char_002",
      "name": "苏雅琪",
      "avatar": "assets/avatars/yaqi.png",
      "portrait": "assets/portraits/yaqi.png",
      "personality": "活泼、开朗、爱冒险，运动神经发达",
      "description": "校园里的人气之星，篮球队队长",
      "backstory": "大学时与你相识，她总是充满活力，喜欢各种挑战。虽然看起来大大咧咧，但内心也有细腻的一面。",
      "traits": {
        "gentleness": 50,
        "liveliness": 85,
        "shyness": 20,
        "humor": 70,
        "tsundere": 30
      }
    }
  ]
}
```

#### settings_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/storage_service.dart';
import '../../core/models/ai_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();
  String _selectedProvider = 'OpenAI';
  String _selectedModel = 'gpt-4o';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    final aiConfig = storage.getAIConfig();
    
    if (aiConfig != null) {
      setState(() {
        _apiKeyController.text = aiConfig.apiKey;
        _baseUrlController.text = aiConfig.baseUrl ?? '';
        _selectedProvider = aiConfig.provider;
        _selectedModel = aiConfig.model;
      });
    }
  }

  Future<void> _saveSettings() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    
    final aiConfig = AIConfig(
      provider: _selectedProvider,
      apiKey: _apiKeyController.text,
      model: _selectedModel,
      baseUrl: _baseUrlController.text.isNotEmpty ? _baseUrlController.text : null,
      updatedAt: DateTime.now(),
    );

    await storage.saveAIConfig(aiConfig);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存')),
      );
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('AI 服务配置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedProvider,
              items: const [
                DropdownMenuItem(value: 'OpenAI', child: Text('OpenAI')),
                DropdownMenuItem(value: 'Claude', child: Text('Claude')),
                DropdownMenuItem(value: 'Custom', child: Text('自定义')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedProvider = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'AI 服务提供商',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
                hintText: '请输入你的 API Key',
              ),
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
              items: const [
                DropdownMenuItem(value: 'gpt-4o', child: Text('gpt-4o')),
                DropdownMenuItem(value: 'gpt-4-turbo', child: Text('gpt-4-turbo')),
                DropdownMenuItem(value: 'gpt-3.5-turbo', child: Text('gpt-3.5-turbo')),
                DropdownMenuItem(value: 'claude-3-opus', child: Text('Claude 3 Opus')),
                DropdownMenuItem(value: 'claude-3-sonnet', child: Text('Claude 3 Sonnet')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedModel = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: '模型',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('保存设置'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 8. 开发步骤

1. **创建 Flutter 项目**
   ```bash
   flutter create loveme
   cd loveme
   ```

2. **更新 pubspec.yaml 并安装依赖**
   - 复制上面的 pubspec.yaml 内容
   - 运行：`flutter pub get`

3. **生成 Hive 适配器**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **按顺序实现代码**
   - 先创建数据模型
   - 实现常量和核心管理器
   - 实现服务层
   - 实现 UI 组件和屏幕
   - 创建资源文件

5. **运行应用**
   ```bash
   flutter run
   ```

### 9. 注意事项

1. **加密存储**：Hive 使用 AES-256 加密存储 API Key，加密密钥通过 flutter_secure_storage 保存在系统安全存储中

2. **每日好感度限制**：每日从对话和小游戏获得的好感度有上限，避免快速通关

3. **情绪衰减**：角色情绪会随时间自然衰减

4. **内存管理**：短期记忆限制为 15 条对话，超出后会压缩并移动到中期记忆

5. **永恒结局**：当好感度达到 1000 时，触发最终结局

6. **多周目**：每个新游戏会创建独立的存档，但角色数据和 CG 收藏跨周目保存

