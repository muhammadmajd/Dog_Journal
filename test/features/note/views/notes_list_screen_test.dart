// test/features/notes/views/notes_list_screen_test.dart
import 'package:dog/features/notes/views/add_note_screen.dart';
import 'package:dog/features/notes/views/edit_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dog/features/notes/bloc/note_bloc.dart';
import 'package:dog/features/notes/models/note.dart';
import 'package:dog/features/notes/views/notes_list_screen.dart';

class MockNoteBloc extends Mock implements NoteBloc {}

void main() {
  late MockNoteBloc mockNoteBloc;
  final testNote = Note(
    id: '1',
    title: 'Test Note',
    comment: 'Test comment',
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(NoteInitial());
    registerFallbackValue(LoadNotes());
  });

  setUp(() {
    mockNoteBloc = MockNoteBloc();
  });

  tearDown(() {
    reset(mockNoteBloc);
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<NoteBloc>.value(
        value: mockNoteBloc,
        child: Scaffold(body: child),
      ),
    );
  }

  group('NotesListScreen', () {
    testWidgets('shows loading indicator when state is NoteLoading', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteLoading());

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of notes when state is NoteLoaded', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteLoaded([testNote]));

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      expect(find.text('Test Note'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows error message when state is NoteError', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteError('Test error'));

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      expect(find.text('Test error'), findsOneWidget);
    });

    testWidgets('displays empty state when no notes are available', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteLoaded([]));

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      expect(find.text('No notes yet'), findsOneWidget);
    });

    testWidgets('navigates to AddNoteScreen when add button is pressed', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteLoaded([]));
      when(() => mockNoteBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(AddNoteScreen), findsOneWidget);
    });

    testWidgets('dispatches LoadNotes event when initialized', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteInitial());
      when(() => mockNoteBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      verify(() => mockNoteBloc.add(LoadNotes())).called(1);
    });

    testWidgets('shows note details when note is tapped', (tester) async {
      when(() => mockNoteBloc.state).thenReturn(NoteLoaded([testNote]));

      await tester.pumpWidget(
        createTestWidget(const NotesListScreen()),
      );

      await tester.tap(find.text('Test Note'));
      await tester.pumpAndSettle();

      expect(find.byType(EditNoteScreen), findsOneWidget);
    });
  });
}