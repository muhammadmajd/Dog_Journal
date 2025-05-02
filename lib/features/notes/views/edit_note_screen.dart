import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/note_bloc.dart';
import '../controllers/edit_note_controller.dart';
import '../models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final EditNoteController _controller;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _controller = EditNoteController();
    _controller.titleController = TextEditingController(text: widget.note.title);
    _controller.commentController = TextEditingController(text: widget.note.comment);
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: Form(
          key: _controller.editFormKey,
          child: Column(
            children: [

              /// title
              TextField(
                controller: _controller.titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              const SizedBox(height: 16),
              /// comment
              TextField(
                controller: _controller.commentController,
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
               // onPressed: ()=>_updateNote(),
                onPressed: () async {
                  String? path =  _imageFile?.path ?? widget.note.imagePath;

                  await _controller.updateNote(context,widget.note, path );
                },
                child: const Text('Сохранить'),
              ),
              const SizedBox(height: 100),
            ],
          ),
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
        _controller.setImagePath(image!.path);
      });
    }
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
            onPressed: () async{
            await _controller.deleteNote(context,widget.note);
            },

            child: const Text('удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}