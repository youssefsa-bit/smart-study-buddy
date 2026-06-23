import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateNameEvent extends ProfileEvent {
  final String newName;
  const UpdateNameEvent(this.newName);

  @override
  List<Object?> get props => [newName];
}

class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordEvent(this.currentPassword, this.newPassword);

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class LogoutRequestedEvent extends ProfileEvent {}
