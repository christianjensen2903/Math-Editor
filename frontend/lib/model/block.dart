import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

enum BlockType {
  text,
  code,
  math,
}

class Block extends Equatable {
  final String id;
  final List content;
  final BlockType type;

  const Block({
    required this.id,
    this.content = const [],
    this.type = BlockType.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'type': type.toString(),
    };
  }

  factory Block.fromMap(Map<String, dynamic> map, String id) {
    return Block(
      id: id,
      content: List.from(map['content'] ?? []),
      type: BlockType.values.firstWhere((e) => e.toString() == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Block.fromJson(String source, String id) =>
      Block.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [id];
}
