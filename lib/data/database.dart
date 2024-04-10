import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/util/todo_tile.dart';

class TaskDataBase {
   // List of tasks
  List toDoList = [];

  //reference our box
  final _myBox = Hive.box('myBox');

  // Run if first time opening app
  void createInitialData(){
    List toDoList = [
      ["Make App", false],
      ["Get Exercise", false],
    ];
  }

  // load data from data base
  void loadData(){
    toDoList = _myBox.get("TASKS");
  }

  // update the database
  void updateDataBase(){
    _myBox.put("TASKS", toDoList);
  }

  void updateElement(int index, String s){
    toDoList[index][0] = s; 
  }
}