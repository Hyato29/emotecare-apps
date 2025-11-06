// lib/features/auth/presentation/cubit/fingerprint/fingerprint_state.dart
part of 'fingerprint_cubit.dart';

@immutable
abstract class FingerprintState {}

class FingerprintInitial extends FingerprintState {}
class FingerprintLoading extends FingerprintState {}
class FingerprintSuccess extends FingerprintState {
  final User user;
  FingerprintSuccess(this.user);
}
class FingerprintFailure extends FingerprintState {
  final String error;
  FingerprintFailure(this.error);
}