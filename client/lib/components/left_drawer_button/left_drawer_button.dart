import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeftDrawerButton extends StatefulWidget {
  const LeftDrawerButton({required this.text, required this.icon, super.key});
  final String text;
  final Icon icon;
  @override
  State<LeftDrawerButton> createState() => _LeftDrawerButtonState();
}

class _LeftDrawerButtonState extends State<LeftDrawerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 36,
          ),
          widget.icon,
          SizedBox(
            width: 16,
          ),
          Text(
            widget.text,
            style: GoogleFonts.montserrat(
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}
