import 'package:flutter/material.dart';

class WidgetShell extends StatefulWidget {
  const WidgetShell({required this.widgetBuilder, super.key});
  final Widget widgetBuilder;

  @override
  State<WidgetShell> createState() => _WidgetShellState();
}

class _WidgetShellState extends State<WidgetShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.widgetBuilder,
    );
  }
}
