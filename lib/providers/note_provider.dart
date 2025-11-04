import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  static const String _kNotesKey = 'notes_key';

  final List<Note> _notes = [];

  NoteProvider() {
    _loadNotes();
  }

  // Returns notes in reverse chronological order (newest first)
  List<Note> get notes => List.unmodifiable(_notes.reversed.toList());

  Note? getById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  void addNote(String title, String content) {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
    );
    _notes.add(note);
    _saveToPrefs();
    notifyListeners();
  }

  void updateNote(String id, String title, String content) {
    final idx = _notes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notes[idx].title = title;
      _notes[idx].content = content;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void clearAll() {
    _notes.clear();
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_kNotesKey);
      if (jsonString == null || jsonString.isEmpty) return;
      final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
      _notes.clear();
      _notes.addAll(
          decoded.map((e) => Note.fromMap(Map<String, dynamic>.from(e))));
      notifyListeners();
    } catch (e) {
      // ignore errors and keep empty list
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(_notes.map((n) => n.toMap()).toList());
      await prefs.setString(_kNotesKey, encoded);
    } catch (e) {
      // ignore errors for now
    }
  }
}
