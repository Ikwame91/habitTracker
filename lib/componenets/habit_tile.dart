import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    this.onChanged,
    this.editHabit,
    this.deleteHabit,
  });

  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              // foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              icon: Icons.settings,
            ),
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red,
              // foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              //toggle completion status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: ListTile(
                  title: Text(
                    text,
                    style: TextStyle(
                      color: isCompleted
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: onChanged,
                    activeColor: Colors.white,
                    checkColor: Colors.green,
                  ))),
        ),
      ),
    );
  }
}
