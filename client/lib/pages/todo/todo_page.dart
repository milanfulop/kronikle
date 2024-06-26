import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/data/task_data.dart';
import 'package:client/widgets/todo/task_list/task_list.dart';
import 'package:client/pages/todo/task_list_adder.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        List<String> categories = taskProvider.categories;
        return SizedBox(
          width: screenSize.width - 332,
          height: screenSize.height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...categories
                  .map((category) => IntrinsicHeight(
                        child: TaskList(category: category),
                      ))
                  .toList(),
              SizedBox(height: 56, child: TaskListAdder()),
            ],
          ),
        );
      },
    );
  }
}
