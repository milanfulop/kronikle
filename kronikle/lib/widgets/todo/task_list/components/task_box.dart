import 'package:kronikle/data/task_data.dart';
import 'package:kronikle/pages/todo/task_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskBox extends StatefulWidget {
  const TaskBox({
    required this.task,
    this.widgetId,
    Key? key,
  }) : super(key: key);

  final Task task;
  final String? widgetId;

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    void _updateTask(bool? value) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.updateTask(
        widget.task,
        newName: widget.task.name,
        newCompleted: value,
      );
      setState(() {
        _isChecked = value!;
      });
    }

    Widget _buildTaskContent() {
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.task.name,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
              Checkbox(
                value: _isChecked,
                onChanged: _updateTask,
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
      );
    }

    void _showTaskEditor() {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              width: 300,
              height: 300,
              padding: EdgeInsets.all(20),
              child: Scaffold(
                backgroundColor: Colors.white,
                body: TaskEditor(task: widget.task),
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.widgetId == null
          ? InkWell(onTap: _showTaskEditor, child: _buildTaskContent())
          : Center(child: _buildTaskContent()),
    );
  }
}
