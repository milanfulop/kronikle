import 'dart:convert';

import 'package:kronikle/utilities/create_widget.dart';
import 'package:kronikle/utilities/notify_server_subclient_close.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:kronikle/data/task_data.dart';
import 'package:kronikle/widgets/todo/task_list/components/task_box.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:window_manager/window_manager.dart';

class TaskList extends StatefulWidget {
  final String category;
  final String? widgetId;

  const TaskList({
    required this.category,
    this.widgetId,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController _newTaskController = TextEditingController();
  bool _isCreatingTask = false;

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        List<Task> tasks = taskProvider.tasksInCategory(widget.category);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: taskProvider.isCategoryHidden(widget.category) == true
                ? Container(
                    color: Colors.black,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(
                          context, tasks, taskProvider, widget.category),
                      Expanded(
                        child: SmoothListView(
                          duration: const Duration(milliseconds: 100),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                Task task = tasks[index];
                                return TaskBox(
                                  task: task,
                                  widgetId: widget.widgetId,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            _isCreatingTask
                                ? _buildNewTaskTextField(context)
                                : _buildCreateButton(context),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<Task> tasks,
    TaskProvider taskProvider,
    String category,
  ) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 217, 217, 217),
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: DragToMoveArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                widget.category,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: widget.widgetId == null
                  ? IconButton(
                      onPressed: () async {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        final Offset position = button
                            .localToGlobal(Offset.zero, ancestor: overlay);

                        await showMenu(
                          color: Colors.white,
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx + 265,
                            position.dy,
                            position.dx + 265,
                            position.dy,
                          ),
                          items: [
                            PopupMenuItem(
                              child: const Text('Create Widget'),
                              onTap: () => onCreateWidget(taskProvider),
                            ),
                            PopupMenuItem(
                              child: const Text('Delete Category'),
                              onTap: () {
                                taskProvider.deleteCategory(category);
                              },
                            ),
                          ],
                        );
                      },
                      icon: const Icon(Icons.add),
                    )
                  : IconButton(
                      onPressed: () async {
                        await notifyServerTodo(
                          widget.category,
                          jsonEncode(tasks),
                        );
                        windowManager.close();
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _isCreatingTask = true;
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromARGB(100, 217, 217, 217),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
        child: Text(
          "Create",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildNewTaskTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        child: TapRegion(
          onTapOutside: (e) => _cancelCreatingTask(),
          child: TextField(
            controller: _newTaskController,
            onSubmitted: (value) {
              _createNewTask(context, value);
            },
            autofocus: true,
            style: GoogleFonts.montserrat(
              fontSize: 16,
            ),
            maxLines: null,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createNewTask(BuildContext context, String taskName) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (taskName.isNotEmpty) {
      Task newTask = Task(name: taskName, category: widget.category);
      taskProvider.addTask(widget.category, newTask);
    }
    _newTaskController.clear();
    setState(() {
      _isCreatingTask = false;
    });
  }

  void _cancelCreatingTask() {
    _newTaskController.clear();
    setState(() {
      _isCreatingTask = false;
    });
  }

  void onCreateWidget(TaskProvider taskProvider) async {
    await createWidget(
      const Size(250, 400).toString(),
      "tasks:${widget.category}",
    );
    taskProvider.toggleCategoryHidden(widget.category);
  }
}
