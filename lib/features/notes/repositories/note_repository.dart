import 'package:hive/hive.dart';
import '../models/note.dart';

class NoteRepository {
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  Box<Note>? _box;

  set box(Box<Note> box) => _box = box;



  Future<void> init() async {
    _box = await Hive.openBox<Note>('notes');
  }
  Future<List<Note>> getAllNotes() async {
    return _notesBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addNote(Note note) async {
    await _notesBox.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  Future<void> updateNote(Note note) async {
    await _notesBox.put(note.id, note);
  }


}