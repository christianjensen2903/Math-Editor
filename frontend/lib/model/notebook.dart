import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class Notebook extends Equatable {
  final String id;
  final String title;
  final Delta content;
  const Notebook({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content.toJson(),
    };
  }

  factory Notebook.fromMap(Map<String, dynamic> map, String id) {
    final contentJson =
        (map['content'] == null) ? [] : jsonDecode(map['content']);

    return Notebook(
      id: id,
      title: map['title'],
      content: Delta.fromJson(map['content']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notebook.fromJson(String source, String id) =>
      Notebook.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [id, title, content];
}
