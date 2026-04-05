import 'package:isar/isar.dart';

part 'habit_log.g.dart';

@collection
class HabitLog {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late DateTime date;

  late String habitType;

  bool isCompleted = false;
}
