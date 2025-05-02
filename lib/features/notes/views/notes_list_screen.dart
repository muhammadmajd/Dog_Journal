import 'dart:io';



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/utils/shimmer_loading.dart';
import '../bloc/note_bloc.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoading) {
          return _buildLoadingState();
        } else if (state is NoteLoaded) {
          return _buildLoadedState(context, state.notes);
        } else if (state is NoteError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Пока нет заметок'));
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          isLoading: true,
          child: const NoteCardShimmer(),
        );
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Пока нет заметок'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNoteScreen(),
                  ),
                );
              },
              child: const Text('Добавьте свою первую заметку'),
            ),
          ],
        ),
      );
    }

    final imageNotes = notes.where((note) => note.imagePath != null).toList();

    return Column(
      children: [
        if (imageNotes.isNotEmpty) Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildImageSlider(imageNotes),
        ),
        /// list view to display notes
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                     // builder: (context) => NoteDetailScreen(note: note),
                      builder: (context) => EditNoteScreen(note: note),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider(List<Note> imageNotes) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageNotes.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final note = imageNotes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(note.imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                imageNotes.length,
                    (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  imageNotes[_currentPage].title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCardShimmer extends StatelessWidget {
  const NoteCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 20,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 16,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 16,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}