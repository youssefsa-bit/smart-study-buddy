import '../../domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final User user;
  AuthSuccess({required this.message, required this.user});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}