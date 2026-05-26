import 'package:hive/hive.dart';

part 'custom_character_record.g.dart';

@HiveType(typeId: 7)
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
  String? generatedAvatarPath;

  @HiveField(7)
  String? generatedPortraitPath;

  @HiveField(8)
  DateTime createdAt;

  CustomCharacterRecord({
    required this.customCharacterId,
    required this.baseCharacterId,
    required this.name,
    required this.personality,
    required this.appearanceDescription,
    required this.referenceImagePaths,
    this.generatedAvatarPath,
    this.generatedPortraitPath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'customCharacterId': customCharacterId,
      'baseCharacterId': baseCharacterId,
      'name': name,
      'personality': personality,
      'appearanceDescription': appearanceDescription,
      'referenceImagePaths': referenceImagePaths,
      'generatedAvatarPath': generatedAvatarPath,
      'generatedPortraitPath': generatedPortraitPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomCharacterRecord.fromJson(Map<String, dynamic> json) {
    return CustomCharacterRecord(
      customCharacterId: json['customCharacterId'] ?? '',
      baseCharacterId: json['baseCharacterId'] ?? '',
      name: json['name'] ?? '',
      personality: json['personality'] ?? '',
      appearanceDescription: json['appearanceDescription'] ?? '',
      referenceImagePaths: List<String>.from(json['referenceImagePaths'] ?? []),
      generatedAvatarPath: json['generatedAvatarPath'],
      generatedPortraitPath: json['generatedPortraitPath'],
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
