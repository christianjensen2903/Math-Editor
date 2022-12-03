import 'package:equatable/equatable.dart';
import 'dart:convert';

class Notebook extends Equatable {
  final String id;
  final String title;
  final List content;
  final List<String> blocks;

  const Notebook({
    required this.id,
    this.title = 'Untitled',
    this.content = const [],
    this.blocks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'blocks': blocks,
    };
  }

  factory Notebook.fromMap(Map<String, dynamic> map, String id) {
    return Notebook(
      id: id,
      title: map['title'] ?? 'Untitled',
      content: List.from(map['content'] ?? []),
      blocks: List.from(map['blocks'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notebook.fromJson(String source, String id) =>
      Notebook.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [id];
}
