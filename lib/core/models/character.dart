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
