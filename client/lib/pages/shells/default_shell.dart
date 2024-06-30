import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:client/pages/notes/notes_page.dart';
import 'package:client/pages/shells/left_drawer_button/left_drawer_button.dart';
import 'package:client/pages/todo/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultShell extends StatefulWidget {
  const DefaultShell({super.key});

  @override
  State<DefaultShell> createState() => _DefaultShellState();
}

class _DefaultShellState extends State<DefaultShell> {
  String currentPage = "todo";

  final Map<String, Widget> pageMapping = {
    "todo": const TodoPage(),
    "notes": const NotesPage(),
    // "dailyGoals": DailyGoalsPage(),
    // "pomodoro": PomodoroPage(),
    // "reminders": RemindersPage(),
    // "settings": SettingsPage(),
  };

  void changePage(String page) {
    setState(() {
      currentPage = page;
    });
  }

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
                            icon: Icon(Icons.work_outline),
                            onPressed: () => changePage("todo"),
                          ),
                          LeftDrawerButton(
                            text: "Notes",
                            icon: Icon(Icons.newspaper_outlined),
                            onPressed: () => changePage("notes"),
                          ),
                          LeftDrawerButton(
                            text: "Daily goals",
                            icon: Icon(Icons.wb_sunny_outlined),
                            onPressed: () => changePage("dailyGoals"),
                          ),
                          LeftDrawerButton(
                            text: "Pomodoro",
                            icon: Icon(Icons.hourglass_bottom_outlined),
                            onPressed: () => changePage("pomodoro"),
                          ),
                          LeftDrawerButton(
                            text: "Reminders",
                            icon: Icon(Icons.alarm),
                            onPressed: () => changePage("reminders"),
                          ),
                          Spacer(),
                          LeftDrawerButton(
                            text: "Settings",
                            icon: Icon(Icons.settings_outlined),
                            onPressed: () => changePage("settings"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: pageMapping[currentPage] ?? Container(),
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
