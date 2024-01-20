import 'package:flutter/material.dart';
import 'package:habit_tracker/componenets/drawer.dart';
import 'package:habit_tracker/componenets/habit_tile.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initialize controller
  @override
  void initState() {
    //read existing habits on startup
    super.initState();
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
  }

  final TextEditingController _textEditingController = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create a new habit'),
            content: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter habit name',
              ),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    //get new habit
                    String newHabitName = _textEditingController.text;

                    //save to db
                    context.read<HabitDatabase>().addHabit(newHabitName);

                    //pop context
                    Navigator.of(context).pop();

                    //clear text
                    _textEditingController.clear();
                  },
                  child: const Text('Save')),
              MaterialButton(
                onPressed: () {
                  //pop box
                  Navigator.of(context).pop();

                  //clear controller
                  _textEditingController.clear();
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  //checkHabit on and Off
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitsList(),
    );
  }

  Widget _buildHabitsList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //check if there are any habits
    if (currentHabits.isEmpty) {
      return const Center(
        child: Text('No habits yet'),
      );
    }
    return ListView.builder(
        itemCount: currentHabits.length,
        itemBuilder: ((context, index) {
          //get individual habit
          final habit = currentHabits[index];

          //check if habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          return MyHabitTile(
              isCompleted: isCompletedToday,
              text: habit.name,
              onChanged: (value) => checkHabitOnOff(value, habit));
        }));
  }
}
