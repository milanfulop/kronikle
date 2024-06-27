import 'dart:convert';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';

Future<void> createWidget(String widgetName) async {
  final window = await DesktopMultiWindow.createWindow(jsonEncode({
    'widget_name': widgetName,
  }));
  window
    ..setFrame(const Offset(0, 0) & const Size(1280, 720))
    ..show();
}
