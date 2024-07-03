import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kronikle/data/task_data.dart';
import 'package:kronikle/widgets/todo/task_list/task_list.dart';
import 'package:kronikle/pages/todo/task_list_adder.dart';

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
          width: screenSize.width - 300,
          height: screenSize.height - 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 8,
              ),
              ...categories
                  .map(
                    (category) => TaskList(category: category),
                  )
                  .toList(),
              TaskListAdder(),
            ],
          ),
        );
      },
    );
  }
}
