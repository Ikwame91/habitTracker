import 'package:flutter/material.dart';
import 'package:habit_tracker/componenets/drawer.dart';
import 'package:habit_tracker/componenets/habit_tile.dart';
import 'package:habit_tracker/componenets/myheat_map.dart';
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

  //edit habit box
  void editHabitBox(Habit habit) {
    //set the controllers text to the habit's current name
    _textEditingController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit habit'),
              content: TextField(
                controller: _textEditingController,
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      //get new habit name
                      String newHabitName = _textEditingController.text;

                      //update habit name
                      context
                          .read<HabitDatabase>()
                          .updateHabitName(habit.id, newHabitName);

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
                    child: const Text('Cancel'))
              ],
            ));
  }

  //delete habit
  void deleteHabit(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure you want to delete "${habit.name}"?'),
              actions: [
                MaterialButton(
                    onPressed: () {
                      //delete habit
                      context.read<HabitDatabase>().deleteHabit(habit.id);

                      //pop context
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete')),
                MaterialButton(
                    onPressed: () {
                      //pop context
                      Navigator.of(context).pop();
                      _textEditingController.clear();
                    },
                    child: const Text('Cancel'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.tertiary,
        ),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewHabit,
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: ListView(children: [
          //H E A T M A P
          _buildHeatMap(),
          //HabitList
          _buildHabitsList(),
        ]));
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataSet(currentHabits),
            );
          } else {
            return Container();
          }
        });
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentHabits.length,
        itemBuilder: ((context, index) {
          //get individual habit
          final habit = currentHabits[index];

          //check if habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          return MyHabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabit(habit),
          );
        }));
  }
}
