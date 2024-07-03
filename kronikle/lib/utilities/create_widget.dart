import 'dart:convert';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';

Future<void> createWidget(String size, String widgetName) async {
  final window = await DesktopMultiWindow.createWindow(
    jsonEncode(
      {
        'size': size,
        'widget_name': widgetName,
      },
    ),
  );
  window
    ..setFrame(const Offset(500, 500) & const Size(100, 100))
    ..show();
}
