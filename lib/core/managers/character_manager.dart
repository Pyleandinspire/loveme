import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/character.dart';

class CharacterManager {
  List<Character> _characters = [];

  List<Character> get characters => _characters;

  // 从JSON加载角色数据
  Future<void> loadCharacters() async {
    try {
      final jsonString = await rootBundle.loadString('assets/characters.json');
      final jsonData = jsonDecode(jsonString);
      final charactersJson = jsonData['characters'] as List<dynamic>;

      _characters = charactersJson
          .map((json) => Character.fromJson(json))
          .toList();
    } catch (e) {
      // 如果加载失败，使用默认角色
      _characters = _getDefaultCharacters();
    }
  }

  // 根据ID获取角色
  Character? getCharacterById(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // 获取预设角色
  List<Character> getPresetCharacters() {
    return _characters.where((c) => !c.isCustom).toList();
  }

  // 获取自定义角色
  List<Character> getCustomCharacters() {
    return _characters.where((c) => c.isCustom).toList();
  }

  // 添加自定义角色
  void addCustomCharacter(Character character) {
    character.isCustom = true;
    _characters.add(character);
  }

  // 默认角色数据
  List<Character> _getDefaultCharacters() {
    return [
      Character(
        id: 'char_001',
        name: '林小雨',
        avatar: 'assets/lin_xiaoyu.png',
        portrait: 'assets/lin_xiaoyu.png',
        personality: '温柔、体贴、有点害羞',
        description: '邻家女孩类型，喜欢阅读和烹饪',
        backstory: '从小在你家隔壁长大的青梅竹马，对你有着特别的感情。',
        traits: {
          'gentleness': 85,
          'liveliness': 40,
          'shyness': 60,
          'humor': 50,
          'tsundere': 20,
        },
        appearanceDescription: '长发及腰，黑色直发，眼睛是温柔的棕色，皮肤白皙，身材纤细，常穿浅色连衣裙',
        referenceImagePaths: [],
        isCustom: false,
        sharedMemories: [],
      ),
      Character(
        id: 'char_002',
        name: '苏雅琪',
        avatar: 'assets/su_yaqing.png',
        portrait: 'assets/su_yaqing.png',
        personality: '活泼、开朗、爱冒险',
        description: '校园里的人气之星，运动全能',
        backstory: '学校篮球队队长，总是充满活力，对生活充满热情。',
        traits: {
          'gentleness': 50,
          'liveliness': 85,
          'shyness': 20,
          'humor': 70,
          'tsundere': 30,
        },
        appearanceDescription: '短发利落，栗色卷发，眼睛明亮有神，身材健康有活力，常穿运动装',
        referenceImagePaths: [],
        isCustom: false,
        sharedMemories: [],
      ),
    ];
  }
}
