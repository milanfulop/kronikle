import 'package:client/pages/notes/note_adder.dart';
import 'package:client/widgets/notes/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/data/note_data.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        List<Note> notes = noteProvider.notes;
        return SizedBox(
          width: screenSize.width - 300,
          height: screenSize.height - 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 8),
              ...notes
                  .map(
                    (note) => NoteWidget(note: note),
                  )
                  .toList(),
              const NoteAdder(),
            ],
          ),
        );
      },
    );
  }
}
