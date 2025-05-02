part of 'note_bloc.dart';
/// define all events
abstract class NoteEvent extends Equatable {
  const NoteEvent();
}

class LoadNotes extends NoteEvent {
  @override
  List<Object> get props => [];
}

class AddNote extends NoteEvent {
  final Note note;
  const AddNote(this.note);
  @override
  List<Object> get props => [note];
}

class UpdateNote extends NoteEvent {
  final Note note;
  const UpdateNote(this.note);
  @override
  List<Object> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String id;
  const DeleteNote(this.id);
  @override
  List<Object> get props => [id];
}