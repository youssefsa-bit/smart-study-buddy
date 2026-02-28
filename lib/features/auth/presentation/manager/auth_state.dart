abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final String name;
  AuthSuccess({required this.message, required this.name});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
