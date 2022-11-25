import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotebookModel extends Equatable {
  final String id;
  final String title;
  final Delta content;
  const NotebookModel({
    required this.id,
    required this.title,
    required this.content,
  });

  NotebookModel? fromJson(Map<String, dynamic> json) {
    try {
      return NotebookModel(
        id: json['\$id'],
        title: json['title'],
        content: Delta.fromJson(json['content']),
      );
    } catch (e) {
      return null;
    }
  }

  String toJson() {
    return {
      '\$id': id,
      'title': title,
      'content': content.toJson(),
    }.toString();
  }

  @override
  List<Object?> get props => [id, title, content];
}
