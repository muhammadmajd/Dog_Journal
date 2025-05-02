import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;

  NoteBloc(this.noteRepository) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
  }

  FutureOr<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final notes = await noteRepository.getAllNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  FutureOr<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.addNote(event.note);
      final notes = await noteRepository.getAllNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.deleteNote(event.id);
      final notes = await noteRepository.getAllNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.updateNote(event.note);
      final notes = await noteRepository.getAllNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }


}