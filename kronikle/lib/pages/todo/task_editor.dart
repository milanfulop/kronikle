import 'package:kronikle/data/task_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskEditor extends StatefulWidget {
  const TaskEditor({required this.task, Key? key}) : super(key: key);
  final Task task;

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'in "${widget.task.category}".',
            style: GoogleFonts.montserrat(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController()..text = widget.task.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              Provider.of<TaskProvider>(context, listen: false).updateTask(
                widget.task,
                newName: value,
              );
            },
            style: GoogleFonts.montserrat(),
          ),
          const SizedBox(height: 16),
          Text(
            "Actions",
            style: GoogleFonts.montserrat(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).removeTask(
                widget.task.category,
                widget.task,
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.black, width: 2),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Delete",
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
