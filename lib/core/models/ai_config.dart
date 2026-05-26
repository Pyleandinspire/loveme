import 'package:hive/hive.dart';

part 'ai_config.g.dart';

@HiveType(typeId: 4)
class AIConfig extends HiveObject {
  @HiveField(0)
  String provider; // 'openai', 'claude', 'custom'

  @HiveField(1)
  String apiKey;

  @HiveField(2)
  String model;

  @HiveField(3)
  String? baseUrl;

  @HiveField(4)
  int typingSpeed; // 0: slow, 1: medium, 2: fast

  @HiveField(5)
  String theme; // 'light', 'dark', 'system'

  @HiveField(6)
  bool soundEnabled;

  @HiveField(7)
  bool voiceInputEnabled;

  AIConfig({
    this.provider = 'openai',
    this.apiKey = '',
    this.model = 'gpt-4o-mini',
    this.baseUrl,
    this.typingSpeed = 1,
    this.theme = 'system',
    this.soundEnabled = true,
    this.voiceInputEnabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'apiKey': apiKey,
      'model': model,
      'baseUrl': baseUrl,
      'typingSpeed': typingSpeed,
      'theme': theme,
      'soundEnabled': soundEnabled,
      'voiceInputEnabled': voiceInputEnabled,
    };
  }

  factory AIConfig.fromJson(Map<String, dynamic> json) {
    return AIConfig(
      provider: json['provider'] ?? 'openai',
      apiKey: json['apiKey'] ?? '',
      model: json['model'] ?? 'gpt-4o-mini',
      baseUrl: json['baseUrl'],
      typingSpeed: json['typingSpeed'] ?? 1,
      theme: json['theme'] ?? 'system',
      soundEnabled: json['soundEnabled'] ?? true,
      voiceInputEnabled: json['voiceInputEnabled'] ?? false,
    );
  }

  AIConfig copyWith({
    String? provider,
    String? apiKey,
    String? model,
    String? baseUrl,
    int? typingSpeed,
    String? theme,
    bool? soundEnabled,
    bool? voiceInputEnabled,
  }) {
    return AIConfig(
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      baseUrl: baseUrl ?? this.baseUrl,
      typingSpeed: typingSpeed ?? this.typingSpeed,
      theme: theme ?? this.theme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceInputEnabled: voiceInputEnabled ?? this.voiceInputEnabled,
    );
  }
}
