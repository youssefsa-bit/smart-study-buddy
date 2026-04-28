import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_name_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateNameUseCase updateNameUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateNameUseCase,
    required this.changePasswordUseCase,
    required this.logoutUseCase,
  }) : super(const ProfileState()) {

    on<LoadProfileEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading, action: ProfileAction.getProfile));
      try {
        final user = await getProfileUseCase.call();
        emit(state.copyWith(status: ProfileStatus.success, action: ProfileAction.getProfile, user: user));
      } catch (e) {
        emit(state.copyWith(status: ProfileStatus.error, action: ProfileAction.getProfile, errorMessage: e.toString()));
      }
    });

    on<UpdateNameEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading, action: ProfileAction.updateName));
      try {
        final updatedUser = await updateNameUseCase.call(event.newName);
        emit(state.copyWith(status: ProfileStatus.success, action: ProfileAction.updateName, user: updatedUser, successMessage: "Name updated successfully"));
      } catch (e) {
        emit(state.copyWith(status: ProfileStatus.error, action: ProfileAction.updateName, errorMessage: e.toString()));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading, action: ProfileAction.changePassword));
      try {
        await changePasswordUseCase.call(event.currentPassword, event.newPassword);
        emit(state.copyWith(status: ProfileStatus.success, action: ProfileAction.changePassword, successMessage: "Password changed successfully"));
      } catch (e) {
        emit(state.copyWith(status: ProfileStatus.error, action: ProfileAction.changePassword, errorMessage: e.toString()));
      }
    });

    on<LogoutRequestedEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading, action: ProfileAction.logout));
      try {
        await logoutUseCase.call();
        emit(state.copyWith(status: ProfileStatus.success, action: ProfileAction.logout));
      } catch (e) {
        emit(state.copyWith(status: ProfileStatus.error, action: ProfileAction.logout, errorMessage: e.toString()));
      }
    });
  }
}