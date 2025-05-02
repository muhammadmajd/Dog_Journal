import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/note_bloc.dart';
import '../controllers/add_note_controller.dart';
import '../models/note.dart';
import '../widgets/photo_picker.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  XFile? _imageFile;

  late final AddNoteController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddNoteController();
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
        title: const Text('Добавить новую заметку'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              /// title
              TextFormField(
                controller: _controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Название заметки',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              /// comment
              TextFormField(
                controller: _controller.commentController,
                decoration: const InputDecoration(
                  labelText: 'Комментарий',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите комментарий';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              /// photo picker
              PhotoPicker(
                imageFile: _imageFile,
                onImagePicked: (XFile? image) {
                  //_controller.setImagePath(image!.path);
                  setState(() {
                    _imageFile = image;
                    _controller.setImagePath(image!.path);
                  });
                },
              ),
              const SizedBox(height: 24),
              /// save button
              ElevatedButton(
                //onPressed: _saveNote,
                onPressed: () async {
                  await _controller.saveNote(context);
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}