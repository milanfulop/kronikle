import 'dart:convert';

import 'package:client/data/note_data.dart';
import 'package:client/utilities/create_widget.dart';
import 'package:client/utilities/notify_server_subclient_close.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  final String? widgetId;

  const NoteWidget({
    required this.note,
    this.widgetId,
    Key? key,
  }) : super(key: key);

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _noteController.text = widget.note.text;
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: noteProvider.isNoteHidden(widget.note.name) == true
                ? Container(
                    color: Colors.black,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, widget.note, noteProvider),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _noteController,
                              onChanged: (value) {
                                noteProvider.updateNote(widget.note,
                                    newText: value);
                              },
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter note text',
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, Note note, NoteProvider noteProvider) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 217, 217, 217),
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: DragToMoveArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                note.name,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: widget.widgetId == null
                  ? IconButton(
                      onPressed: () async {
                        noteProvider.toggleNoteHidden(widget.note.name);
                        await createWidget(
                          const Size(250, 400).toString(),
                          "note:${widget.note.name}",
                        );
                      },
                      icon: const Icon(Icons.do_not_touch),
                    )
                  : IconButton(
                      onPressed: () async {
                        await notifyServerNote(
                          widget.note.name,
                          jsonEncode(_noteController.text),
                        );
                        windowManager.close();
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
