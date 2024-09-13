import 'package:mechine_test_flutter/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.email,
    required super.password,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
