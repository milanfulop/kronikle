import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:client/components/left_drawer_button/left_drawer_button.dart';
import 'package:client/pages/todo/todo_page.dart';
import 'package:client/widgets/todo/task_list/task_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultShell extends StatelessWidget {
  const DefaultShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WindowTitleBarBox(
                child: Row(
                  children: [
                    Expanded(
                      child: MoveWindow(),
                    ),
                    MinimizeWindowButton(),
                    MaximizeWindowButton(),
                    CloseWindowButton(),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 64.0,
                              horizontal: 8,
                            ),
                            child: Center(
                              child: Text(
                                "Kronikle",
                                style: GoogleFonts.montserrat(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          LeftDrawerButton(
                            text: "Tasks",
                            icon: Icon(
                              Icons.work_outline,
                            ),
                          ),
                          LeftDrawerButton(
                            text: "Notes",
                            icon: Icon(
                              Icons.newspaper_outlined,
                            ),
                          ),
                          LeftDrawerButton(
                            text: "Daily goals",
                            icon: Icon(
                              Icons.wb_sunny_outlined,
                            ),
                          ),
                          LeftDrawerButton(
                            text: "Pomodoro",
                            icon: Icon(
                              Icons.hourglass_bottom_outlined,
                            ),
                          ),
                          LeftDrawerButton(
                            text: "Reminders",
                            icon: Icon(
                              Icons.alarm,
                            ),
                          ),
                          Spacer(),
                          LeftDrawerButton(
                            text: "Settings",
                            icon: Icon(
                              Icons.settings_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TodoPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 299,
            child: Container(
              width: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
