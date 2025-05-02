import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_bloc.dart';
import '../models/note.dart';

class AddNoteController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  String? imagePath;

  void dispose() {
    titleController.dispose();
    commentController.dispose();
  }

  Future<void> saveNote(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        comment: commentController.text.trim(),
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );

      context.read<NoteBloc>().add(AddNote(note));
      Navigator.pop(context);
    }
  }

  void setImagePath(String path) {
    imagePath = path;
  }
}