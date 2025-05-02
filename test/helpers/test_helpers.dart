// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dog/features/notes/bloc/note_bloc.dart';
import 'package:dog/features/notes/models/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockNoteBloc extends Mock implements NoteBloc {}

Note createTestNote({String? id}) => Note(
  id: id ?? '1',
  title: 'Test Note',
  comment: 'Test comment',
  createdAt: DateTime.now(),
);

Widget createWidgetUnderTest(Widget child) {
  return MaterialApp(
    home: child,
    theme: ThemeData(), // Add your app theme here
  );
}