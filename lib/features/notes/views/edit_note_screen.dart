import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/note_bloc.dart';
import '../models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _commentController;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _commentController = TextEditingController(text: widget.note.comment);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать заметку'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            const SizedBox(height: 16),
            /// comment
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Комментарий'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            /// image
            if (widget.note.imagePath != null || _imageFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _imageFile != null
                    ? Image.file(File(_imageFile!.path))
                    : Image.file(File(widget.note.imagePath!)),
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Изменить фото'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateNote,
              child: const Text('Сохранить'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _updateNote() {
    final updatedNote = Note(
      id: widget.note.id,
      title: _titleController.text,
      comment: _commentController.text,
      imagePath: _imageFile?.path ?? widget.note.imagePath,
      createdAt: widget.note.createdAt,
    );

    context.read<NoteBloc>().add(UpdateNote(updatedNote));
    Navigator.pop(context);
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку'),
        content: const Text('Вы уверены, что хотите удалить эту заметку?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отменить'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteBloc>().add(DeleteNote(widget.note.id));
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit screen
            },
            child: const Text('удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}