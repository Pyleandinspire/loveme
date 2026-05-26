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
