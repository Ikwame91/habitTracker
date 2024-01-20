//given a list of completion days
//check if the habit iss completed today

import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

//prepare heat map DataSet
Map<DateTime, int> prepHeatMapDataSet(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      //normalize date to avoid  time mismatch
      final normalizedData = DateTime(date.year, date.month, date.day);
      //if the date already exists in the dataset , increment its count
      if (dataset.containsKey(normalizedData)) {
        dataset[normalizedData] = dataset[normalizedData]! + 1;
      } else {
        //initialize it with a count of 1
        dataset[normalizedData] = 1;
      }
    }
  }
  return dataset;
}
