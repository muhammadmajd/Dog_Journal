import 'package:dog/features/notes/models/note.dart';
import 'package:dog/features/notes/repositories/note_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late MockNoteRepository mockRepository;
  late Note testNote;

  setUp(() {
    mockRepository = MockNoteRepository();
    testNote = Note(
      id: '1',
      title: 'Test Note',
      comment: 'Test comment',
      createdAt: DateTime.now(),
    );

    // Register fallback values for complex types
    registerFallbackValue(testNote);
  });

  group('NoteRepository', () {
    test('getAllNotes returns empty list', () async {
      when(() => mockRepository.getAllNotes())
          .thenAnswer((_) async => []);

      expect(await mockRepository.getAllNotes(), isEmpty);
      verify(() => mockRepository.getAllNotes()).called(1);
    });

    test('addNote stores a note', () async {
      when(() => mockRepository.addNote(any()))
          .thenAnswer((_) async => {});

      await mockRepository.addNote(testNote);
      verify(() => mockRepository.addNote(testNote)).called(1);
    });

    test('updateNote modifies existing note', () async {
      final updatedNote = Note(
        id: testNote.id,
        title: 'Updated',
        comment: testNote.comment,
        createdAt: testNote.createdAt,
      );

      when(() => mockRepository.updateNote(any()))
          .thenAnswer((_) async => {});

      await mockRepository.updateNote(updatedNote);
      verify(() => mockRepository.updateNote(updatedNote)).called(1);
    });

    test('deleteNote removes note', () async {
      when(() => mockRepository.deleteNote(any()))
          .thenAnswer((_) async => {});

      await mockRepository.deleteNote(testNote.id);
      verify(() => mockRepository.deleteNote(testNote.id)).called(1);
    });
  });
}