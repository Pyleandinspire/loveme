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
│   │   │   ├── scene.dart
│   │   │   ├── game_save.dart
│   │   │   ├── emotion_state.dart
│   │   │   ├── memory_entry.dart
│   │   │   ├── mini_game_record.dart
│   │   │   ├── ai_config.dart
│   │   │   ├── focus_record.dart
│   │   │   └── dynamic_event_record.dart
│   │   ├── managers/
│   │   │   ├── character_manager.dart
│   │   │   ├── dialogue_manager.dart
│   │   │   ├── affection_manager.dart
│   │   │   ├── scene_manager.dart
│   │   │   ├── emotion_manager.dart
│   │   │   ├── memory_manager.dart
│   │   │   └── mini_game_manager.dart
│   │   ├── services/
│   │   │   ├── ai_service.dart
│   │   │   ├── storage_service.dart
│   │   │   └── speech_service.dart
│   │   └── utils/
│   │       ├── prompt_builder.dart
│   │       └── memory_compressor.dart
│   └── ui/
│       ├── screens/
│       │   ├── welcome_screen.dart
│       │   ├── character_select_screen.dart
│       │   ├── main_game_screen.dart
│       │   ├── scene_screen.dart
│       │   ├── settings_screen.dart
│       │   ├── tutorial_screen.dart
│       │   └── mini_games/
│       │       ├── mini_game_menu.dart
│       │       ├── idiom_game.dart
│       │       └── blackjack_game.dart
│       └── widgets/
│           ├── character_card.dart
│           ├── dialogue_bubble.dart
│           ├── streaming_dialogue_bubble.dart
│           └── affection_bar.dart
├── assets/
│   ├── characters.json
│   ├── dialogue_templates.json
│   ├── idioms.json
│   ├── tutorials/
│   ├── avatars/
│   └── portraits/
└── pubspec.yaml
```

---

## 详细实施计划

### 1. pubspec.yaml 配置

```yaml
name: loveme
description: AI恋爱模拟器
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
  path: ^1.8.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.6

flutter:
  uses-material-design: true
  assets:
    - assets/
    - assets/avatars/
    - assets/portraits/
```

### 2. 数据模型实现 (core/models/)

按照 spec.md 中的描述，先实现所有 Hive 数据模型。

每个模型需要：
- @HiveType 和 @HiveField 注解
- 合适的 typeId (0-6)
- 必要的字段

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

  Character({
    required this.id,
    required this.name,
    required this.avatar,
    required this.portrait,
    required this.personality,
    required this.description,
    required this.backstory,
    required this.traits,
  });
}
```

#### dialogue.dart (DialogueRecord)
```dart
import 'package:hive/hive.dart';

part 'dialogue.g.dart';

@HiveType(typeId: 1)
class DialogueRecord extends HiveObject {
  @HiveField(0)
  String speaker; // 'user' 或角色ID

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

其他模型按类似方式实现：
- memory_entry.dart (typeId: 4)
- ai_config.dart (typeId: 3)
- mini_game_record.dart (typeId: 2)
- focus_record.dart (typeId: 5)
- dynamic_event_record.dart (typeId: 6)
- emotion_state.dart
- scene.dart

### 3. 常量配置 (core/constants/)

#### hive_constants.dart
```dart
class HiveConstants {
  static const String boxGameSave = 'game_save';
  static const String boxSecureConfig = 'secure_config';
  static const String boxMiniGameRecords = 'mini_game_records';
  
  static const int typeIdGameSave = 0;
  static const int typeIdDialogueRecord = 1;
  static const int typeIdMiniGameRecord = 2;
  static const int typeIdAIConfig = 3;
  static const int typeIdMemoryEntry = 4;
  static const int typeIdFocusRecord = 5;
  static const int typeIdDynamicEventRecord = 6;
  static const int typeIdCharacter = 7;
}
```

#### app_constants.dart
```dart
class AppConstants {
  static const int maxAffection = 1000;
  static const int shortTermMemoryLimit = 15;
  static const int dailyAffectionLimit = 100;
  static const List<int> milestoneThresholds = [
    25, 50, 75, 100, 125, 150, 175, 200,
    // 继续到 1000，每 25 一个
  ];
}
```

### 4. 存储服务 (core/services/storage_service.dart)
```dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants/hive_constants.dart';
import '../models/game_save.dart';
import '../models/ai_config.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box<GameSave> _gameSaveBox;
  late Box<AIConfig> _secureConfigBox;
  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late Directory _appDocDir;

  Future<void> init() async {
    await Hive.initFlutter();
    _appDocDir = await getApplicationDocumentsDirectory();
    
    // 注册适配器
    // Hive.registerAdapter(GameSaveAdapter());
    // Hive.registerAdapter(DialogueRecordAdapter());
    // 等等...

    // 打开 box
    _gameSaveBox = await Hive.openBox<GameSave>(HiveConstants.boxGameSave);
    
    // 获取加密密钥并打开加密 box
    final encryptionKey = await _getOrCreateEncryptionKey();
    _secureConfigBox = await Hive.openBox<AIConfig>(
      HiveConstants.boxSecureConfig,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<int>> _getOrCreateEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: 'hive_encryption_key');
    if (keyString == null) {
      // 生成新密钥
      final key = Hive.generateSecureKey();
      keyString = key.join(',');
      await _secureStorage.write(key: 'hive_encryption_key', value: keyString);
      return key;
    }
    return keyString.split(',').map(int.parse).toList();
  }

  // GameSave 操作
  GameSave? getCurrentSave() {
    return _gameSaveBox.get('current');
  }

  Future<void> saveGame(GameSave save) async {
    await _gameSaveBox.put('current', save);
  }

  // SharedPreferences 操作
  bool isFirstLaunch() {
    return _prefs.getBool('first_launch') ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool('first_launch', value);
  }

  // 文件操作
  String getCgDirectoryPath() {
    return '${_appDocDir.path}/saves/cg';
  }

  Future<File> saveCgImage(String filename, List<int> bytes) async {
    final dir = Directory(getCgDirectoryPath());
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}/$filename');
    return file.writeAsBytes(bytes);
  }
}
```

### 5. 核心管理器实现

#### CharacterManager (core/managers/character_manager.dart)
```dart
import '../models/character.dart';
import '../services/storage_service.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CharacterManager {
  final StorageService _storage = StorageService();
  List<Character> _characters = [];

  List<Character> get characters => List.unmodifiable(_characters);

  Future<void> loadCharacters() async {
    final jsonString = await rootBundle.loadString('assets/characters.json');
    final jsonData = json.decode(jsonString);
    _characters = (jsonData['characters'] as List)
        .map((data) => Character.fromJson(data))
        .toList();
  }

  Character? getCharacterById(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

#### AffectionManager (core/managers/affection_manager.dart)
```dart
import '../models/game_save.dart';
import '../constants/app_constants.dart';

class AffectionManager {
  int getCurrentAffection(GameSave save) => save.affection;

  bool canAddAffection(GameSave save, int amount) {
    // 检查每日上限等
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

  bool hasReachedMilestone(GameSave save, int milestone) {
    return save.affection >= milestone;
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
}
```

#### MemoryManager (core/managers/memory_manager.dart)
```dart
import '../models/game_save.dart';
import '../models/dialogue.dart';
import '../models/memory_entry.dart';
import '../constants/app_constants.dart';

class MemoryManager {
  void addToShortTermMemory(GameSave save, DialogueRecord record) {
    save.shortTermMemory.add(record);
    
    if (save.shortTermMemory.length > AppConstants.shortTermMemoryLimit) {
      // 将最早的对话压缩并移到中期记忆
      final oldest = save.shortTermMemory.removeAt(0);
      final compressed = _compressDialogue(oldest);
      save.mediumTermMemory.add(compressed);
    }
  }

  String _compressDialogue(DialogueRecord record) {
    // 简单压缩实现
    return '${record.speaker}: ${record.content.substring(0, record.content.length > 50 ? 50 : record.content.length)}...';
  }

  void addLongTermMemory(GameSave save, String key, String value, String source) {
    final existing = save.longTermMemory.where((m) => m.key == key).toList();
    for (var e in existing) {
      save.longTermMemory.remove(e);
    }
    
    save.longTermMemory.add(MemoryEntry(
      key: key,
      value: value,
      source: source,
      timestamp: DateTime.now(),
    ));
  }

  List<String> getRelevantMemories(GameSave save, String query) {
    final memories = <String>[];
    
    // 添加长期记忆
    for (var m in save.longTermMemory) {
      memories.add('- ${m.key}: ${m.value}');
    }
    
    // 添加中期记忆摘要
    for (var m in save.mediumTermMemory.take(10)) {
      memories.add('- $m');
    }
    
    return memories;
  }
}
```

### 6. AI 服务 (core/services/ai_service.dart)
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_save.dart';
import '../models/character.dart';
import '../managers/memory_manager.dart';
import '../utils/prompt_builder.dart';

class AIService {
  final String apiKey;
  final String baseUrl;
  final String model;
  final MemoryManager _memoryManager = MemoryManager();

  AIService({
    required this.apiKey,
    this.baseUrl = 'https://api.openai.com/v1',
    this.model = 'gpt-4o',
  });

  Stream<String> generateResponseStream(
    GameSave save,
    Character character,
    String userInput,
  ) async* {
    final prompt = PromptBuilder.buildDialoguePrompt(
      save: save,
      character: character,
      userInput: userInput,
    );

    final request = http.Request('POST', Uri.parse('$baseUrl/chat/completions'))
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      })
      ..body = json.encode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': prompt.systemPrompt},
          {'role': 'user', 'content': userInput},
        ],
        'stream': true,
        'temperature': 0.7,
        'max_tokens': 150,
      });

    final response = await request.send();
    
    await for (var chunk in response.stream.transform(utf8.decoder)) {
      // 解析 SSE 响应并输出文本
      // 这里是简化实现，实际需要处理 'data: ' 前缀等
      final lines = chunk.split('\n');
      for (var line in lines) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') continue;
          try {
            final json = jsonDecode(data);
            final delta = json['choices']?[0]?['delta']?['content'];
            if (delta != null) {
              yield delta;
            }
          } catch (e) {
            // 忽略解析错误
          }
        }
      }
    }
  }

  Future<Map<String, dynamic>> generateScene(
    GameSave save,
    Character character,
    int milestone,
  ) async {
    final prompt = PromptBuilder.buildScenePrompt(
      save: save,
      character: character,
      milestone: milestone,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': prompt},
        ],
        'temperature': 0.8,
      }),
    );

    // 解析响应并返回场景数据
    return json.decode(response.body);
  }
}
```

### 7. 提示词构建器 (core/utils/prompt_builder.dart)
```dart
import '../models/game_save.dart';
import '../models/character.dart';
import '../managers/memory_manager.dart';

class PromptBuilder {
  static final MemoryManager _memoryManager = MemoryManager();

  static String buildDialoguePrompt({
    required GameSave save,
    required Character character,
    required String userInput,
  }) {
    final memories = _memoryManager.getRelevantMemories(save, userInput);
    final affectionLevel = _getAffectionLevelName(save.affection);
    
    return '''
【角色设定】
角色：${character.name}
性格：${character.personality}
当前关系：$affectionLevel
好感度：${save.affection}

【共同记忆】
${memories.join('\n')}

【对话历史】
${_formatRecentDialogues(save)}

【回复要求】
- 保持角色性格一致性
- 回复自然口语化
- 适当使用表情符号
- 回复长度适中（10-100字）
''';
  }

  static String _formatRecentDialogues(GameSave save) {
    return save.shortTermMemory
        .take(5)
        .map((d) => '${d.speaker}: ${d.content}')
        .join('\n');
  }

  static String _getAffectionLevelName(int affection) {
    if (affection < 25) return '陌生人';
    if (affection < 50) return '初识';
    if (affection < 75) return '熟悉';
    if (affection < 100) return '朋友';
    return '亲密';
  }

  static String buildScenePrompt({
    required GameSave save,
    required Character character,
    required int milestone,
  }) {
    return '''
【角色设定】
角色：${character.name}
性格：${character.personality}
当前好感度里程碑：$milestone

【任务】
生成一个符合当前好感度的浪漫场景。
请输出 JSON 格式，包含：
{
  "title": "场景标题",
  "description": "场景描述（用于生成图片）",
  "atmosphere": "氛围",
  "imagePrompt": "AI绘画提示词",
  "dialogues": [{"speaker": "角色名", "text": "对话内容"}],
  "choices": [{"text": "选项文本", "affectionChange": 15}]
}
''';
  }
}
```

### 8. UI 实现

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
    Provider.value(
      value: storage,
      child: const LoveMeApp(),
    ),
  );
}
```

#### app.dart
```dart
import 'package:flutter/material.dart';
import 'ui/screens/welcome_screen.dart';

class LoveMeApp extends StatelessWidget {
  const LoveMeApp({super.key});

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

#### Welcome Screen (ui/screens/welcome_screen.dart)
```dart
import 'package:flutter/material.dart';
import 'character_select_screen.dart';
import 'main_game_screen.dart';
import '../../core/services/storage_service.dart';
import 'package:provider/provider.dart';

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
                child: const Text('开始恋爱'),
              ),
              if (hasExistingSave) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainGameScreen()),
                    );
                  },
                  child: const Text('继续游戏'),
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

### 9. 角色数据 (assets/characters.json)
```json
{
  "characters": [
    {
      "id": "char_001",
      "name": "林小雨",
      "avatar": "assets/avatars/xiaoyu.png",
      "portrait": "assets/portraits/xiaoyu.png",
      "personality": "温柔、体贴、有点害羞",
      "description": "邻家女孩类型，喜欢阅读和烹饪",
      "backstory": "从小在你家隔壁长大的青梅竹马...",
      "traits": {"gentleness": 85, "liveliness": 40, "shyness": 60, "humor": 50, "tsundere": 20}
    },
    {
      "id": "char_002",
      "name": "苏雅琪",
      "avatar": "assets/avatars/yaqi.png",
      "portrait": "assets/portraits/yaqi.png",
      "personality": "活泼、开朗、爱冒险",
      "description": "校园里的人气之星，运动全能",
      "backstory": "学校篮球队队长，总是充满活力...",
      "traits": {"gentleness": 50, "liveliness": 85, "shyness": 20, "humor": 70, "tsundere": 30}
    }
  ]
}
```

---

## 生成 Hive 适配器

实现所有模型后，运行以下命令生成 Hive 适配器：

```bash
flutter packages pub run build_runner build
```

---

## 后续步骤

1. 完成其他 UI 屏幕实现
2. 实现小游戏（21点、成语接龙）
3. 实现伴学系统
4. 集成图片生成功能
5. 测试所有功能
6. 优化性能和用户体验

请按照这个顺序一步一步实现，每个模块完成后进行测试，确保没有问题后再进行下一步。
