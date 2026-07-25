import 'package:hive/hive.dart';

part 'memory.g.dart';

@HiveType(typeId: 0)
class Memory extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  DateTime createdAt;

  Memory({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.createdAt,
  });
}