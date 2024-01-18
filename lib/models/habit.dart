import 'package:isar/isar.dart';

// dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  //habit id
  Id id = Isar.autoIncrement;

  //habit name
  late String name;

  //completed days
  late List<DateTime> completedDays = [
    //DateTimr(2021, 10, 10),
    //DateTimr(2021, 10, 10),
  ];
}
