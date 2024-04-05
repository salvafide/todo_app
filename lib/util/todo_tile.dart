// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;  
  Function(BuildContext)? editFunction;

  TodoTile({
    super.key, 
    required this.taskName, 
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, top: 24),
      child: Slidable(
        endActionPane: ActionPane(
          motion: BehindMotion(),
          children: [
            SlidableAction( // Edit
              onPressed: editFunction,
              icon: Icons.edit,
              backgroundColor: Colors.green,
               borderRadius: BorderRadius.circular(6),
            ),
            SlidableAction( // Delete 
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          child : Row(
            children: [
              //Checkbox
              Checkbox(
                value: taskCompleted, 
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              // Task Name
              Flexible(
                child: Text(
                  taskName,
                  style: TextStyle(decoration: taskCompleted ? TextDecoration.lineThrough : TextDecoration.none)
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color : Colors.yellow[500],
            borderRadius: BorderRadius.circular(12)
          )
        ),
      ),
    );
  }
}