import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:kronikle/components/update_button/update_button.dart';
import 'package:kronikle/pages/notes/notes_page.dart';
import 'package:kronikle/pages/shells/left_drawer_button/left_drawer_button.dart';
import 'package:kronikle/pages/todo/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void launchEmail() async {
    final Uri url = Uri.parse(
        'https://mail.google.com/mail/u/0/?to=appkronikle@gmail.com&su=Feature%20request&fs=1&tf=cm');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
                    const UpdateButton(),
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
                            icon: Icon(Icons.description_outlined),
                            onPressed: () => changePage("notes"),
                          ),
                          /*LeftDrawerButton(
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
                          ),*/
                          Spacer(),
                          Stack(
                            children: [
                              LeftDrawerButton(
                                text: "Request a feature",
                                icon: Icon(Icons.add),
                                onPressed: launchEmail,
                              ),
                              Text("v0.2"),
                            ],
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
