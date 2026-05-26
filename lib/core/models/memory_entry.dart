import 'package:hive/hive.dart';

part 'memory_entry.g.dart';

@HiveType(typeId: 4)
class MemoryEntry extends HiveObject {
  @HiveField(0)
  String key;

  @HiveField(1)
  String value;

  @HiveField(2)
  String source;

  @HiveField(3)
  DateTime timestamp;

  MemoryEntry({
    required this.key,
    required this.value,
    required this.source,
    required this.timestamp,
  });
}
