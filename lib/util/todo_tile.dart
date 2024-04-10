// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;  

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
      padding: const EdgeInsets.only(left: 24.0, right: 24, top: 7, bottom: 7),
      child: Slidable(
        endActionPane: ActionPane(
          motion: BehindMotion(),
          children: [
            SlidableAction( // Delete 
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              //backgroundColor: Color.fromARGB(255, 117, 79, 30),
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(14),
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  taskName,
                  style: TextStyle(decoration: taskCompleted ? TextDecoration.lineThrough : TextDecoration.none)
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color : Colors.yellow[600],
            borderRadius: BorderRadius.circular(12)
          )
        ),
      ),
    );
  }
}