import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'features/notes/bloc/note_bloc.dart';
import 'features/notes/models/note.dart';
import 'features/notes/repositories/note_repository.dart';

void main() async {
  ///
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hive
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoteBloc(NoteRepository())..add(LoadNotes()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
