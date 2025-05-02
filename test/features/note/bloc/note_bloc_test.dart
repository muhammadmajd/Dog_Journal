// test/features/notes/bloc/note_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dog/features/notes/bloc/note_bloc.dart';

import 'package:dog/features/notes/models/note.dart';
import 'package:dog/features/notes/repositories/note_repository.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late MockNoteRepository mockRepository;
  late NoteBloc noteBloc;
  final testNote = Note(
    id: '1',
    title: 'Test Note',
    comment: 'Test comment',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockRepository = MockNoteRepository();
    noteBloc = NoteBloc(mockRepository);

    // Register fallback values for mocktail
    registerFallbackValue(testNote);
  });

  tearDown(() {
    noteBloc.close();
  });

  group('NoteBloc', () {
    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteLoaded] when LoadNotes is added',
      build: () {
        when(() => mockRepository.getAllNotes())
            .thenAnswer((_) async => [testNote]);
        return noteBloc;
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        NoteLoading(),
        NoteLoaded([testNote]),
      ],
      verify: (_) {
        verify(() => mockRepository.getAllNotes()).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoaded] when AddNote is successful',
      build: () {
        when(() => mockRepository.addNote(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllNotes())
            .thenAnswer((_) async => [testNote]);
        return noteBloc;
      },
      act: (bloc) => bloc.add(AddNote(testNote)),
      expect: () => [
        NoteLoaded([testNote]),
      ],
      verify: (_) {
        verify(() => mockRepository.addNote(testNote)).called(1);
        verify(() => mockRepository.getAllNotes()).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoaded] when UpdateNote is successful',
      build: () {
        when(() => mockRepository.updateNote(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllNotes())
            .thenAnswer((_) async => [testNote]);
        return noteBloc;
      },
      act: (bloc) => bloc.add(UpdateNote(testNote)),
      expect: () => [
        NoteLoaded([testNote]),
      ],
      verify: (_) {
        verify(() => mockRepository.updateNote(testNote)).called(1);
        verify(() => mockRepository.getAllNotes()).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoaded] when DeleteNote is successful',
      build: () {
        when(() => mockRepository.deleteNote(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllNotes())
            .thenAnswer((_) async => []);
        return noteBloc;
      },
      act: (bloc) => bloc.add(DeleteNote(testNote.id)),
      expect: () => [
        NoteLoaded([]),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteNote(testNote.id)).called(1);
        verify(() => mockRepository.getAllNotes()).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteError] when repository throws exception',
      build: () {
        when(() => mockRepository.getAllNotes())
            .thenThrow(Exception('Database error'));
        return noteBloc;
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        NoteLoading(),
        NoteError('Exception: Database error'),
      ],
    );
  });
}