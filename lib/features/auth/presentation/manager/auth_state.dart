import '../../domain/entities/auth_message.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthMessage? message;
  final String name;
  AuthSuccess({required this.name, this.message,});}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
