import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  User? fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['\$id'],
        name: json['name'],
        email: json['email'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [id, name, email];
}
