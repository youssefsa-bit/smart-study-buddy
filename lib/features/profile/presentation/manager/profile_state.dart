import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

enum ProfileStatus { initial, loading, success, error }
enum ProfileAction { none, getProfile, updateName, changePassword, logout }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileAction action;
  final UserProfileEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final String? cachedName;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.action = ProfileAction.none,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.cachedName,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileAction? action,
    UserProfileEntity? user,
    String? errorMessage,
    String? successMessage,
    String? cachedName,
  }) {
    return ProfileState(
      status: status ?? this.status,
      action: action ?? this.action,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
      cachedName: cachedName ?? this.cachedName,
    );
  }

  @override
  List<Object?> get props => [status, action, user, errorMessage, successMessage,cachedName];
}