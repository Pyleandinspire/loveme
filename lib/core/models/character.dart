import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
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

  @HiveField(11)
  List<SharedMemory> sharedMemories;

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
    required this.sharedMemories,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      portrait: json['portrait'] ?? '',
      personality: json['personality'] ?? '',
      description: json['description'] ?? '',
      backstory: json['backstory'] ?? '',
      traits: Map<String, int>.from(json['traits'] ?? {}),
      appearanceDescription: json['appearanceDescription'] ?? '',
      referenceImagePaths: List<String>.from(json['referenceImagePaths'] ?? []),
      isCustom: json['isCustom'] ?? false,
      sharedMemories: (json['sharedMemories'] as List<dynamic>?)
              ?.map((m) => SharedMemory.fromJson(m))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'portrait': portrait,
      'personality': personality,
      'description': description,
      'backstory': backstory,
      'traits': traits,
      'appearanceDescription': appearanceDescription,
      'referenceImagePaths': referenceImagePaths,
      'isCustom': isCustom,
      'sharedMemories': sharedMemories.map((m) => m.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 10)
class SharedMemory extends HiveObject {
  @HiveField(0)
  String key;

  @HiveField(1)
  String value;

  @HiveField(2)
  DateTime timestamp;

  SharedMemory({
    required this.key,
    required this.value,
    required this.timestamp,
  });

  factory SharedMemory.fromJson(Map<String, dynamic> json) {
    return SharedMemory(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
