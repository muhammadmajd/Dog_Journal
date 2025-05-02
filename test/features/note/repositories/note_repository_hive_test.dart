
import 'package:dog/features/notes/repositories/note_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dog/features/notes/models/note.dart';
import 'package:dog/features/notes/models/note.dart';
import 'package:path_provider/path_provider.dart';
void main() {
  late NoteRepository repository;
  //late Box<Note> testBox;


  setUp(() async {
    // Initialize Hive
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init('${appDir.path}_test');
    Hive.registerAdapter(NoteAdapter());

    // Ensure box is opened before repository initialization
    await Hive.openBox<Note>('notes');

    repository = NoteRepository();
    await repository.init(); // Now the box exists
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('notes');
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });
  tearDownAll(() async {
    //await testBox.close();
    await tearDownTestHive();
  });

  group('NoteRepository Hive Integration', () {
    final testNote = Note(
      id: '1',
      title: 'Test Note',
      comment: 'Test comment',
      createdAt: DateTime.now(),
    );

    test('addNote and getAllNotes', () async {
      // Initially empty
      expect(await repository.getAllNotes(), isEmpty);

      // Add note
      await repository.addNote(testNote);
      final notes = await repository.getAllNotes();

      // Verify
      expect(notes.length, 1);
      expect(notes.first.id, '1');
      expect(notes.first.title, 'Test Note');
    });

    test('updateNote modifies existing note', () async {
      // Add initial note
      await repository.addNote(testNote);

      // Update note
      final updatedNote = Note(
        id: testNote.id,
        title: 'Updated Title',
        comment: testNote.comment,
        createdAt: testNote.createdAt,
      );
      await repository.updateNote(updatedNote);

      // Verify
      final notes = await repository.getAllNotes();
      expect(notes.first.title, 'Updated Title');
    });

    test('deleteNote removes note', () async {
      // Add note
      await repository.addNote(testNote);
      expect(await repository.getAllNotes(), hasLength(1));

      // Delete note
      await repository.deleteNote(testNote.id);

      // Verify
      expect(await repository.getAllNotes(), isEmpty);
    });

    test('notes are sorted by createdAt descending', () async {
      final notes = [
        Note(id: '1', title: 'Oldest',comment: 'x old', createdAt: DateTime(2023)),
        Note(id: '2', title: 'Newest',comment: 'y new', createdAt: DateTime(2025)),
        Note(id: '3', title: 'Middle',comment: 'scilient', createdAt: DateTime(2024)),
      ];

      // Add notes in random order
      await repository.addNote(notes[0]);
      await repository.addNote(notes[2]);
      await repository.addNote(notes[1]);

      // Verify sorting
      final result = await repository.getAllNotes();
      expect(result[0].title, 'Newest');
      expect(result[1].title, 'Middle');
      expect(result[2].title, 'Oldest');
    });
  });
}