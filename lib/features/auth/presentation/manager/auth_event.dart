abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
}
class CheckAuthStatus extends AuthEvent {}

class UpdateAuthNameEvent extends AuthEvent{
  final String newName;
   UpdateAuthNameEvent({required this.newName});
  @override
  List<Object> get props => [newName];
}
