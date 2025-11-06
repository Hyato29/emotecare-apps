// lib/features/auth/domain/entities/user.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? contact;
  final String? nik;
  final String? gender;
  final String? address;
  final String? role; // <-- TAMBAHKAN INI

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.contact,
    this.nik,
    this.gender,
    this.address,
    this.role, // <-- TAMBAHKAN INI
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    contact,
    nik,
    gender,
    address,
    role,
  ];
}

class AuthResult extends Equatable {
  final User user;
  final String token;

  const AuthResult({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}
