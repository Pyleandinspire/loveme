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

  Map<String, int> getDynamicTraits(Character character, Map<String, int> emotionState) {
    final traits = Map<String, int>.from(character.traits);
    traits['gentleness'] = ((traits['gentleness'] ?? 50) - (emotionState['angry'] ?? 0)).clamp(0, 100);
    traits['liveliness'] =
        ((traits['liveliness'] ?? 50) + (emotionState['happy'] ?? 0) * 0.5).clamp(0, 100).toInt();
    traits['shyness'] = ((traits['shyness'] ?? 50) + (emotionState['shy'] ?? 0)).clamp(0, 100);
    return traits;
  }
}
