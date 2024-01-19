import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;
  /*
setup
  */

  //initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  //save first date of app on startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //Get first date of app startup (for heatmap)
  Future<DateTime> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    // return settings?.firstLaunchDate?? DateTime.now();
    return settings!.firstLaunchDate!;
  }

  /*

CRUDXOPERATIONS

  */

  //List OF Habits
  final List<Habit> currentHabits = [];

  //Create - add a New Habit
  Future<void> addHabit(String habitName) async {
    //create a new habit
    final newHabit = Habit()..name = habitName;

    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-Read from DB
    readHabits();
  }

  //READ -Read saved habits from db
  Future<void> readHabits() async {
    List<Habit> fetchHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);

    //update ui
    notifyListeners();
  }

  //update -checking habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
//find the specific habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit is completed --> add the current date to the completed list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();

          //add the currentDate if its not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        } //if habit is not completed -> remove the current date from the list
        else {
          final today = DateTime.now();
          habit.completedDays.removeWhere(
            (date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day,
          );
        }
        //save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }

    //re-read from Db
    readHabits();
  }

  //Update -edit habit name
  Future<void> updateHabitName(int id, String newName) async {
//find specific habits
    final habit = await isar.habits.get(id);

    //update habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name == newName;
        //save updated habit back to the db
        await isar.habits.put(habit);
      });
    }
  }

  //Delete -delete Habit
}
