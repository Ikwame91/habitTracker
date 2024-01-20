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
    return Slidable(
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
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: ListTile(
                title: Text(
                  text,
                  style: const TextStyle(
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
    );
  }
}
