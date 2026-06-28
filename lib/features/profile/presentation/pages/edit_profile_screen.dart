import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_dialog.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../auth/presentation/manager/auth_bloc.dart';
import '../../../auth/presentation/manager/auth_event.dart';
import '../manager/profile_bloc.dart';
import '../manager/profile_event.dart';
import '../manager/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    final initialName =
        profileState.user?.name ?? profileState.cachedName ?? '';
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(BuildContext context, AppLocalizations loc) {
    CustomDialog.showConfirmation(
      context: context,
      title: loc.editProfileConfirmTitle,
      content: loc.editProfileConfirmDesc,
      icon: Icons.info_outline,
      iconColor: AppColors.primaryBlue,
      confirmText: loc.dialogConfirm,
      onConfirm: () {
        context
            .read<ProfileBloc>()
            .add(UpdateNameEvent(_nameController.text.trim()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(loc.menuEditProfile,
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          final listenerLoc = AppLocalizations.of(context)!;
          if (state.status == ProfileStatus.success &&
              state.action == ProfileAction.updateName) {
            CustomSnackBar.show(
              context: context,
              message: listenerLoc.editProfileSuccess,
              isError: false,
            );
            if (state.user != null) {
              context
                  .read<AuthBloc>()
                  .add(UpdateAuthNameEvent(newName: state.user!.name));
            }
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.error &&
              state.action == ProfileAction.updateName) {
            String displayError =
                state.errorMessage ?? listenerLoc.editProfileError;
            if (state.errorMessage != null) {
              final errorStr = state.errorMessage!.toLowerCase();
              if (errorStr.contains('connection') ||
                  errorStr.contains('timeout') ||
                  errorStr.contains('network') ||
                  errorStr.contains('socket')) {
                displayError = listenerLoc.errorNoConnection;
              }
            }
            CustomSnackBar.show(
              context: context,
              message: displayError,
              isError: true,
              customIcon: displayError == listenerLoc.errorNoConnection
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ProfileStatus.loading &&
              state.action == ProfileAction.updateName;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Icon(Icons.person_pin_rounded,
                    size: 80, color: AppColors.primaryBlue),
                AppSizes.gapV16,
                Text(
                  loc.editProfileSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                AppSizes.gapV8,
                Text(
                  loc.editProfileDesc,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                AppSizes.gapV24,
                AppSizes.gapV24,
                Text(loc.fullName,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                AppSizes.gapV8,
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: AppColors.textPrimary),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return loc.editProfileNameEmpty;
                    }
                    if (value.trim().length < 3) {
                      return loc.errorNameShort;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    prefixIcon: Icon(Icons.person_outline,
                        color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.primaryBlue)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.redAccent)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.redAccent)),
                  ),
                ),
                AppSizes.gapV24,
                AppSizes.gapV16,
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _showConfirmationDialog(context, loc);
                            }
                          },
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(loc.editProfileSaveBtn,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
