import 'dart:io';

import 'package:client/data/task_data.dart';
import 'package:client/pages/shells/default_shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tray_manager/tray_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initWindowManager();
  initTrayManager();

  runApp(
    //later change this to multiprovider
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: DefaultShell(),
        ),
      ),
    ),
  );
}

Future<void> initWindowManager() async {
  appWindow.show();
  doWhenWindowReady(() {
    final win = appWindow;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
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
