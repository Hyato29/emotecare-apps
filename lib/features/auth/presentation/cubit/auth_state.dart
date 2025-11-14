// lib/features/auth/presentation/cubit/auth/auth_state.dart
part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String token;
  Authenticated(this.user, this.token);
}

class Unauthenticated extends AuthState {
  final String? message;
  Unauthenticated({this.message});
}

// State untuk kegagalan umum (register/login)
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

// --- TAMBAHKAN KEMBALI STATE INI UNTUK GPS ---
class GetLocationLoading extends AuthState {}

class GetLocationSuccess extends AuthState {
  final String address;
  GetLocationSuccess(this.address);
}

class GetLocationFailure extends AuthState {
  final String error;
  final bool openSettings;
  GetLocationFailure(this.error, {this.openSettings = false});
}
// -----------------------------------------