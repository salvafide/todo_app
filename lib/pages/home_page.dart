// ignore_for_file: sort_child_properties_last

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('myBox');
  TaskDataBase db = TaskDataBase();

  @override
  void initState() {
    // if this is first time opening app ever, create default data
    if (_myBox.get("TASKS") == null) {
      db.createInitialData();
    }else{
      // Already exists data
      db.loadData();
    }
    super.initState();
  }
  /*List toDoList = [
      ["Make App", false],
      ["Get Exercise", false],
    ];
  */
  final _textController = TextEditingController();
  
  // Checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = value;
    });
    db.updateDataBase();
  }

  // Save task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_textController.text, false]);
      _textController.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // Create a task
  void createNewTask() {
    showDialog(
      context: context, 
      builder: (context) {
        return DialogBox(
          textController: _textController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  } 

  // Delete Task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }
  
  // This function is called when reordering tiles
  void updateOrdering(int oldIndex, int newIndex){
    setState(() {
      // fix index when moving tile down list
      if (oldIndex  < newIndex) newIndex--;
      // get the tile that is moving
      final tile = db.toDoList.removeAt(oldIndex);
      // place tile in new index
      db.toDoList.insert(newIndex, tile);
    });
    HapticFeedback.vibrate();
    db.updateDataBase();
  }

  // This widget is created when reordering list
  Widget proxyDecorator(
      Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          // Create a Card based on the color and the content of the dragged one
          // and set its elevation to the animated value.
          child: Material(
              child: Container(
                  decoration: BoxDecoration(
                  color : Colors.yellow[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 120,
                  child : Row(
                  children: [
                    //Checkbox
                    Checkbox(
                      value: db.toDoList[index][1], 
                      onChanged: (value) => checkBoxChanged(value, index),
                      activeColor: Colors.black,
                    ),
                    // Task Name
                    Flexible(
                      child: Text(
                        db.toDoList[index][0],
                        style: TextStyle(decoration: db.toDoList[index][1] ? TextDecoration.lineThrough : TextDecoration.none)
                      ),
                    ),
                  ],
                ),
              )
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 245, 242, 234),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.yellow[600],
          title: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text("TASKS"),
          ),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow[600],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        proxyDecorator: proxyDecorator,
        clipBehavior: Clip.hardEdge,
        children: [
          for (int index = 0; index < db.toDoList.length; index++)
            TodoTile(
              key: ValueKey(index),
              taskName: db.toDoList[index][0], 
              taskCompleted: db.toDoList[index][1], 
              onChanged: (value) => checkBoxChanged(value, index), 
              deleteFunction: (context) => deleteTask(index),
            )
        ],
        onReorderStart: (int index) { HapticFeedback.heavyImpact();},
        onReorder: ((oldIndex, newIndex) => updateOrdering(oldIndex, newIndex)),
      ),
    );
  }
}