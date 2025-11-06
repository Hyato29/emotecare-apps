// lib/features/auth/data/models/user_model.dart

import 'package:emotcare_apps/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.contact,
    super.nik,
    super.gender,
    super.address,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // --- PERBAIKAN ---
      // Jika 'id' null, gunakan 0 sebagai default
      id: json['id'] ?? 0,

      // Jika 'name' null, gunakan string kosong
      name: json['name'] ?? '',

      // Jika 'email' null, gunakan string kosong
      email: json['email'] ?? '',

      // -----------------
      contact: json['contact'],
      nik: json['nik']
          ?.toString(), // .toString() aman untuk nilai int atau string
      gender: json['gender'],
      address: json['address'],
      role: json['role'],
    );
  }
}

class AuthResultModel extends AuthResult {
  const AuthResultModel({required super.user, required super.token});

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
