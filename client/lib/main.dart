import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:client/data/task_data.dart';
import 'package:client/pages/shells/default_shell.dart';
import 'package:client/pages/shells/widget_shell.dart';
import 'package:client/widgets/todo/task_list/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tray_manager/tray_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.isNotEmpty && args[0] == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;

    Widget widgetBuilder = findWidget(argument['widget_name']);

    await initWidgetWindowManager();
    runApp(
      ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse},
          ),
          debugShowCheckedModeBanner: false,
          home: WidgetShell(
            widgetBuilder: widgetBuilder,
          ),
        ),
      ),
    );
  } else {
    await initFirebase();
    await initTrayManager();
    await initWindowManager();
    runApp(
      ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse},
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: DefaultShell(),
          ),
        ),
      ),
    );
  }
}

Widget findWidget(String widgetId) {
  final splitWidget = widgetId.split(':');
  final widgetKey = splitWidget.first;
  final widgetArgs = splitWidget[1];

  final widgetMap = <String, Widget Function()>{
    'note': () => Text("dxxd"),
    'tasks': () => TaskList(
          widgetId: widgetId,
          category: widgetArgs,
        ),
  };

  final widgetBuilder = widgetMap[widgetKey];
  return widgetBuilder!();
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initWidgetWindowManager() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    skipTaskbar: true,
    backgroundColor: Colors.transparent,
    size: Size(400, 500),
    center: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();

    await windowManager.setAlignment(
      Alignment.bottomRight,
      animate: true,
    );

    Offset offset = const Offset(-10, -10);
    await windowManager.setPosition(
      await windowManager.getPosition() + offset,
      animate: true,
    );

    await windowManager.setAsFrameless();
    windowManager.setResizable(false);
    windowManager.setAlwaysOnTop(true);
  });
}

Future<void> initWindowManager() async {
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(600, 600);
    win.alignment = Alignment.center;
    win.title = "xdd" + TimeOfDay.now().toString();
    win.show();
  });
}

Future<void> initTrayManager() async {
  await trayManager.setIcon(
    Platform.isWindows ? 'images/tray_icon.ico' : 'images/tray_icon.png',
  );
  Menu menu = Menu(
    items: [
      MenuItem(
        key: 'sign_out',
        label: 'Sign Out',
      ),
      MenuItem(
        key: 'exit_app',
        label: 'Exit App',
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'show_window',
        label: 'Show Window',
      ),
    ],
  );
  await trayManager.setContextMenu(menu);
}
