import 'package:flutter/material.dart';
import 'package:todo_app/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final textController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.textController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Color.fromARGB(255, 227, 220, 210),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      content : Container(
        height: 150,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black87, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.black87, width: 2.0),
                ),
                hintText: "Add Task",
                suffixIcon: IconButton(
                  onPressed: () {
                    textController.clear();
                  },
                icon: const Icon(Icons.clear),
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(name: "Save", onPressed: onSave),
                const SizedBox(width: 8,),
                MyButton(name: "Cancel", onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}