import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/data/task_data.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListAdder extends StatefulWidget {
  const TaskListAdder({Key? key}) : super(key: key);

  @override
  _TaskListAdderState createState() => _TaskListAdderState();
}

class _TaskListAdderState extends State<TaskListAdder> {
  TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 200,
      margin: EdgeInsets.all(8.0),
      child: _isAdding ? _buildAddingMode() : _buildAddButton(),
    );
  }

  Widget _buildAddButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isAdding = true;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
      child: Text(
        'Add Task Category',
        style: GoogleFonts.montserrat(color: Colors.black),
      ),
    );
  }

  Widget _buildAddingMode() {
    return TapRegion(
      onTapOutside: (event) {
        setState(() {
          _isAdding = false;
        });
      },
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter category name',
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onSubmitted: (value) {
          _createNewTaskList(value);
        },
      ),
    );
  }

  void _createNewTaskList(String categoryName) {
    if (categoryName.isNotEmpty) {
      Provider.of<TaskProvider>(context, listen: false)
          .addTaskList(categoryName);
    }
    setState(() {
      _isAdding = false;
      _controller.clear();
    });
  }
}
