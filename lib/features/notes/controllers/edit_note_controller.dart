import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_bloc.dart';
import '../models/note.dart';

class EditNoteController {
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
   TextEditingController titleController = TextEditingController();
   TextEditingController commentController = TextEditingController();
  String? imagePath;

  void dispose() {
    titleController.dispose();
    commentController.dispose();
  }

  Future<void> updateNote(BuildContext context) async {
    if (editFormKey.currentState?.validate() ?? false) {
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        comment: commentController.text.trim(),
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );

      context.read<NoteBloc>().add(UpdateNote(note));
      Navigator.pop(context);
    }
  }

  Future<void> deleteNote(BuildContext context,Note note) async {

      context.read<NoteBloc>().add(DeleteNote(note.id));
      Navigator.pop(context); // Close dialog
      Navigator.pop(context); // Close edit screen
  }
  void setImagePath(String path) {
    imagePath = path;
  }
}