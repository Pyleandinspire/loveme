import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/game_save.dart';
import '../models/ai_config.dart';
import '../models/mini_game_record.dart';
import '../models/dynamic_event_record.dart';
import '../models/emotion_state.dart';
import '../models/character.dart';

class StorageService extends ChangeNotifier {
  static const String _gameSaveBoxName = 'game_saves';
  static const String _aiConfigBoxName = 'ai_config';
  static const String _miniGameBoxName = 'mini_games';
  static const String _eventsBoxName = 'events';
  static const String _emotionsBoxName = 'emotions';
  static const String _charactersBoxName = 'characters';

  late Box<GameSave> _gameSaveBox;
  late Box<AIConfig> _aiConfigBox;
  late Box<MiniGameRecord> _miniGameBox;
  late Box<DynamicEventRecord> _eventsBox;
  late Box<EmotionState> _emotionsBox;
  late Box<Character> _charactersBox;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(GameSaveAdapter());
    Hive.registerAdapter(AIConfigAdapter());
    Hive.registerAdapter(MiniGameRecordAdapter());
    Hive.registerAdapter(DynamicEventRecordAdapter());
    Hive.registerAdapter(DialogueOptionAdapter());
    Hive.registerAdapter(EmotionStateAdapter());
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(SharedMemoryAdapter());

    // Open boxes
    _gameSaveBox = await Hive.openBox<GameSave>(_gameSaveBoxName);
    _aiConfigBox = await Hive.openBox<AIConfig>(_aiConfigBoxName);
    _miniGameBox = await Hive.openBox<MiniGameRecord>(_miniGameBoxName);
    _eventsBox = await Hive.openBox<DynamicEventRecord>(_eventsBoxName);
    _emotionsBox = await Hive.openBox<EmotionState>(_emotionsBoxName);
    _charactersBox = await Hive.openBox<Character>(_charactersBoxName);

    _isInitialized = true;
    notifyListeners();
  }

  // Game Save Methods
  GameSave? getCurrentSave() {
    if (_gameSaveBox.isEmpty) return null;
    return _gameSaveBox.get('current');
  }

  Future<void> saveGame(GameSave save) async {
    await _gameSaveBox.put('current', save);
    notifyListeners();
  }

  Future<void> createNewGame(String characterId) async {
    final save = GameSave(
      id: 'save_${DateTime.now().millisecondsSinceEpoch}',
      currentCharacterId: characterId,
      affection: 0,
      createdAt: DateTime.now(),
      lastPlayedAt: DateTime.now(),
    );
    await _gameSaveBox.put('current', save);
    notifyListeners();
  }

  Future<void> updateGameSave(GameSave save) async {
    save.lastPlayedAt = DateTime.now();
    await _gameSaveBox.put('current', save);
    notifyListeners();
  }

  Future<void> deleteGame() async {
    await _gameSaveBox.delete('current');
    notifyListeners();
  }

  List<GameSave> getAllSaves() {
    return _gameSaveBox.values.toList();
  }

  // AI Config Methods
  AIConfig getAIConfig() {
    return _aiConfigBox.get('config') ?? AIConfig();
  }

  Future<void> saveAIConfig(AIConfig config) async {
    await _aiConfigBox.put('config', config);
    notifyListeners();
  }

  // Mini Game Methods
  Future<void> saveMiniGameRecord(MiniGameRecord record) async {
    await _miniGameBox.put(record.id, record);
    notifyListeners();
  }

  List<MiniGameRecord> getMiniGameRecords() {
    return _miniGameBox.values.toList();
  }

  // Event Methods
  Future<void> saveEvent(DynamicEventRecord event) async {
    await _eventsBox.put(event.id, event);
    notifyListeners();
  }

  List<DynamicEventRecord> getAllEvents() {
    return _eventsBox.values.toList();
  }

  List<DynamicEventRecord> getEventsForCharacter(String characterId) {
    return _eventsBox.values
        .where((e) => e.characterId == characterId)
        .toList();
  }

  // Emotion Methods
  EmotionState? getEmotionState(String characterId) {
    return _emotionsBox.get(characterId);
  }

  Future<void> saveEmotionState(EmotionState state) async {
    await _emotionsBox.put(state.characterId, state);
    notifyListeners();
  }

  // Character Methods
  Future<void> saveCharacter(Character character) async {
    await _charactersBox.put(character.id, character);
    notifyListeners();
  }

  Character? getCharacter(String id) {
    return _charactersBox.get(id);
  }

  List<Character> getAllCharacters() {
    return _charactersBox.values.toList();
  }

  // Clear All Data
  Future<void> clearAllData() async {
    await _gameSaveBox.clear();
    await _miniGameBox.clear();
    await _eventsBox.clear();
    await _emotionsBox.clear();
    notifyListeners();
  }
}
