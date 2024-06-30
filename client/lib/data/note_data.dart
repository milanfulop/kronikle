import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Note {
  String name;
  String text;

  Note({
    required this.name,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'text': text,
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
        name: json['name'],
        text: json['text'],
      );
}

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  NoteProvider() {
    loadState();
  }

  List<Note> get notes => _notes;

  void addNote(Note note) async {
    _notes.add(note);
    notifyListeners();
    await saveState();
  }

  void removeNote(Note note) {
    _notes.remove(note);
    notifyListeners();
    saveState();
  }

  void updateNote(Note oldNote, {String? newName, String? newText}) {
    bool noteUpdated = false;

    for (var n in _notes) {
      if (n.name == oldNote.name && n.text == oldNote.text) {
        n.name = newName ?? n.name;
        n.text = newText ?? n.text;
        noteUpdated = true;
        break;
      }
    }

    if (noteUpdated) {
      notifyListeners();
      saveState();
    }
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'notes',
      jsonEncode(
        _notes.map((note) => note.toJson()).toList(),
      ),
    );
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('notes');
    if (jsonString != null) {
      List<dynamic> jsonNotes = jsonDecode(jsonString);
      _notes = jsonNotes.map((jsonNote) => Note.fromJson(jsonNote)).toList();
      notifyListeners();
    }
  }
}
