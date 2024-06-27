import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WidgetShell extends StatefulWidget {
  const WidgetShell({
    required this.widgetBuilder,
    required this.windowSize,
    super.key,
  });
  final Widget widgetBuilder;
  final Size windowSize;

  @override
  State<WidgetShell> createState() => _WidgetShellState();
}

class _WidgetShellState extends State<WidgetShell> {
  @override
  void initState() {
    initWidgetWindowManager(
      widget.windowSize,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.widgetBuilder,
    );
  }
}

Future<void> initWidgetWindowManager(windowSize) async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    backgroundColor: Colors.transparent,
    size: windowSize,
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
