import 'package:flutter/foundation.dart';
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

class StorageService extends ChangeNotifier {
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

    _gameSaveBox = await Hive.openBox<GameSave>(HiveConstants.gameSaveBox);
    _aiConfigBox = await Hive.openBox<AIConfig>(HiveConstants.aiConfigBox);
    _miniGameRecordBox = await Hive.openBox<MiniGameRecord>(HiveConstants.miniGameRecordBox);
    _charactersBox = await Hive.openBox<Character>(HiveConstants.charactersBox);
    _customCharacterBox = await Hive.openBox<CustomCharacterRecord>('custom_characters');

    notifyListeners();
  }

  List<CustomCharacterRecord> getCustomCharacters() {
    return _customCharacterBox?.values.toList() ?? [];
  }

  Future<void> saveCustomCharacter(CustomCharacterRecord character) async {
    await _customCharacterBox?.add(character);
    notifyListeners();
  }

  GameSave? getCurrentSave() {
    if (_gameSaveBox == null || _gameSaveBox!.isEmpty) return null;
    return _gameSaveBox!.values.last;
  }

  Future<void> saveGame(GameSave save) async {
    await _gameSaveBox?.add(save);
    notifyListeners();
  }

  Future<void> updateGameSave(GameSave save) async {
    if (save.isInBox) {
      await save.save();
    } else {
      await _gameSaveBox?.add(save);
    }
    notifyListeners();
  }

  AIConfig? getAIConfig() {
    if (_aiConfigBox == null || _aiConfigBox!.isEmpty) return null;
    return _aiConfigBox!.values.first;
  }

  Future<void> saveAIConfig(AIConfig config) async {
    await _aiConfigBox?.clear();
    await _aiConfigBox?.add(config);
    notifyListeners();
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
