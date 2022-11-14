import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  UserModel? fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
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
