import 'package:client/widgets/todo/task_list/task_list.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TaskList(category: 'General'),
        TaskList(category: 'Work'),
      ],
    );
  }
}
