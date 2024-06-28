import 'dart:convert';

import 'package:client/data/task_data.dart';
import 'package:client/utilities/notify_server_subclient_close.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskBox extends StatefulWidget {
  const TaskBox({
    required this.task,
    super.key,
  });
  final Task task;

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    _isChecked = widget.task.completed;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.task.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                    ),
                  ),
                ),
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    final taskProvider =
                        Provider.of<TaskProvider>(context, listen: false);
                    List<Task> tasks =
                        taskProvider.tasksInCategory(widget.task.category);
                    taskProvider.updateTask(
                      widget.task,
                      newName: widget.task.name,
                      newCompleted: value,
                    );
                    notifyServer(
                      jsonEncode(tasks),
                      widget.task.category,
                    );
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.black,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.black;
                    }
                    return Colors.white;
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
