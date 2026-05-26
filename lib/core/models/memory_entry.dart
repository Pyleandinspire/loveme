import 'package:hive/hive.dart';

part 'memory_entry.g.dart';

@HiveType(typeId: 3)
class MemoryEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String summary;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String type; // 'short', 'medium', 'long'

  @HiveField(5)
  Map<String, dynamic>? metadata;

  MemoryEntry({
    required this.id,
    required this.content,
    required this.summary,
    required this.timestamp,
    required this.type,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'summary': summary,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'metadata': metadata,
    };
  }

  factory MemoryEntry.fromJson(Map<String, dynamic> json) {
    return MemoryEntry(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? 'short',
      metadata: json['metadata'],
    );
  }
}
