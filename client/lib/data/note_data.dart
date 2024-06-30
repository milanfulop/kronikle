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
    if (_notes.any((existingNote) => existingNote.name == note.name)) {
      throw Exception('Note name "${note.name}" must be unique.');
    }

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
    if (newName != null &&
        newName != oldNote.name &&
        _notes.any((existingNote) => existingNote.name == newName)) {
      throw Exception('Note name "$newName" must be unique.');
    }

    Note updatedNote = _notes.firstWhere((note) => note.name == oldNote.name);
    updatedNote.name = newName ?? oldNote.name;
    updatedNote.text = newText ?? oldNote.text;

    if (newName != null && newName != oldNote.name) {
      _notes.removeWhere((note) => note.name == oldNote.name);
      _notes.add(updatedNote);
    }

    notifyListeners();
    saveState();
  }

  Note getNoteByName(String name) {
    print(_notes);
    return _notes.firstWhere(
      (note) => note.name == name,
      orElse: () => Note(
        name: "",
        text: "",
      ),
    );
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
    print(jsonString);
    if (jsonString != null) {
      List<dynamic> jsonNotes = jsonDecode(jsonString);
      _notes = jsonNotes.map((jsonNote) => Note.fromJson(jsonNote)).toList();
      print(_notes);
      notifyListeners();
    }
  }
}
