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
  Map<String, bool> _noteHidden = {};

  NoteProvider() {
    loadState().then((_) {
      initializeNoteHidden();
    });
  }

  List<Note> get notes => _notes;
  Map<String, bool> get noteHidden => _noteHidden;

  void addNote(Note note) async {
    if (_notes.any((existingNote) => existingNote.name == note.name)) {
      throw Exception('Note name "${note.name}" must be unique.');
    }

    _notes.add(note);
    _noteHidden[note.name] = false;
    notifyListeners();
    await saveState();
  }

  void removeNote(Note note) {
    _notes.remove(note);
    _noteHidden.remove(note.name);
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
      _noteHidden[newName] = _noteHidden.remove(oldNote.name) ?? false;
    }

    notifyListeners();
    saveState();
  }

  Note getNoteByName(String name) {
    return _notes.firstWhere(
      (note) => note.name == name,
      orElse: () => Note(
        name: "",
        text: "",
      ),
    );
  }

  bool isNoteHidden(String name) {
    return _noteHidden[name] ?? false;
  }

  void toggleNoteHidden(String name) {
    if (_noteHidden.containsKey(name)) {
      _noteHidden[name] = !_noteHidden[name]!;
      notifyListeners();
    }
  }

  void initializeNoteHidden() {
    for (var note in _notes) {
      if (!_noteHidden.containsKey(note.name)) {
        _noteHidden[note.name] = false;
      }
    }
    notifyListeners();
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'notes',
      jsonEncode(
        _notes.map((note) => note.toJson()).toList(),
      ),
    );
    prefs.setString(
      'noteHidden',
      jsonEncode(_noteHidden),
    );
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('notes');
    if (jsonString != null) {
      List<dynamic> jsonNotes = jsonDecode(jsonString);
      _notes = jsonNotes.map((jsonNote) => Note.fromJson(jsonNote)).toList();
    }

    jsonString = prefs.getString('noteHidden');
    if (jsonString != null) {
      Map<String, dynamic> jsonHidden = jsonDecode(jsonString);
      _noteHidden =
          jsonHidden.map((key, value) => MapEntry(key, value as bool));
    }

    notifyListeners();
  }

  Future<void> loadNoteState(String noteText, String name) async {
    for (int i = 0; i < _notes.length; i++) {
      if (_notes[i].name == name) {
        _notes[i].text = jsonDecode(noteText);
        notifyListeners();
      }
    }
  }
}
