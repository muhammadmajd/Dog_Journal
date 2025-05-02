import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_bloc.dart';
import '../models/note.dart';

class NoteListController {
  final PageController pageController = PageController(viewportFraction: 0.9);
  int currentPage = 0;

  void dispose() {
    pageController.dispose();
  }




}