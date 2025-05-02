import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'note.g.dart';
/// Define Note object
@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String comment;

  @HiveField(3)
  final String? imagePath;

  @HiveField(4)
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.comment,
    this.imagePath,
    required this.createdAt,
  });

  // Add this to your Note class (features/notes/models/note.dart)
  Note copyWith({
    String? id,
    String? title,
    String? comment,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}