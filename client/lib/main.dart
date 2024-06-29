import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:client/data/task_data.dart';
import 'package:client/pages/shells/default_shell.dart';
import 'package:client/pages/shells/widget_shell.dart';
import 'package:client/utilities/parse_size.dart';
import 'package:client/widgets/todo/task_list/task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';

import 'package:tray_manager/tray_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as router;

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();
  if (args.isNotEmpty && args[0] == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;

    final widgetData = getDataForWidget(
      argument['widget_name'],
    );

    final widgetBuilder = widgetData['widget'] as Widget;
    final windowSize = parseSize(argument['size']);

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
            windowSize: windowSize,
          ),
        ),
      ),
    );
  } else {
    final taskProvider = TaskProvider();
    await initLocalServer(taskProvider);
    await initFirebase();
    await initTrayManager();
    await initWindowManager();
    runApp(
      ChangeNotifierProvider(
        create: (context) => taskProvider,
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

Map<String, dynamic> getDataForWidget(String widgetId) {
  final splitWidget = widgetId.split(':');
  final widgetKey = splitWidget.first;
  final widgetArg1 = splitWidget[1];

  final widgetMap = <String, Widget Function()>{
    'note': () => Text("dxxd"),
    'tasks': () => TaskList(
          widgetId: widgetId,
          category: widgetArg1,
        ),
  };

  final widgetBuilder = widgetMap[widgetKey];
  return {
    'widget': widgetBuilder!(),
  };
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initWindowManager() async {
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(600, 600);
    win.alignment = Alignment.center;
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

Future<void> initLocalServer(TaskProvider taskProvider) async {
  final app = router.Router();

  app.post('/windowClosed/todo', (Request request) async {
    final requestBody = await request.readAsString();
    if (requestBody.isNotEmpty) {
      try {
        final data = jsonDecode(requestBody);
        final category = data['category'];
        final categoryState = data['categoryState'];

        if (category != null && categoryState != null) {
          taskProvider.toggleCategoryHidden(category);
          await taskProvider.loadCategoryState(categoryState, category);
        } else {
          return Response.badRequest(body: 'Invalid data structure');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        return Response.internalServerError(body: 'Error decoding JSON');
      }
    } else {
      return Response.badRequest(body: 'Request body is empty');
    }

    return Response.ok('Received data successfully');
  });

  final server = await io.serve(app, 'localhost', 8080);
  print('Server running on localhost:${server.port}');
}
