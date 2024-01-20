import 'package:flutter/material.dart';
import 'package:habit_tracker/componenets/drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              TextButton(
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
              TextButton(
                onPressed: () {
                  //pop box
                  Navigator.of(context).pop();

                  //clear controller
                  _textEditingController.clear();
                },
                child: const Text('Create'),
              )
            ],
          );
        });
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
    );
  }
}
