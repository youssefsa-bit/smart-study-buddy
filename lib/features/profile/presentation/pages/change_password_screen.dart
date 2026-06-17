import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_dialog.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../manager/profile_bloc.dart';
import '../manager/profile_event.dart';
import '../manager/profile_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(BuildContext context, AppLocalizations loc) {
    CustomDialog.showConfirmation(
      context: context,
      title: loc.changePassUpdateBtn,
      content: loc.changePassConfirmDesc,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orangeAccent,
      confirmText: loc.dialogConfirm,
      onConfirm: () {
        context.read<ProfileBloc>().add(
              ChangePasswordEvent(
                _currentPasswordController.text,
                _newPasswordController.text,
              ),
            );
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(loc.changePassSecurity,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          final listenerLoc = AppLocalizations.of(context)!;
          if (state.status == ProfileStatus.success &&
              state.action == ProfileAction.changePassword) {
            CustomSnackBar.show(
              context: context,
              message: listenerLoc.changePassSuccess,
              isError: false,
            );
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.error &&
              state.action == ProfileAction.changePassword) {
            String displayError = listenerLoc.changePassUnexpectedError;
            if (state.errorMessage != null) {
              final errorStr = state.errorMessage!.toLowerCase();
              if (errorStr.contains('connection') ||
                  errorStr.contains('timeout') ||
                  errorStr.contains('network') ||
                  errorStr.contains('socket')) {
                displayError = listenerLoc.errorNoConnection;
              } else if (errorStr.contains("password") ||
                  errorStr.contains("400") ||
                  errorStr.contains("401") ||
                  errorStr.contains("incorrect")) {
                displayError = listenerLoc.changePassIncorrect;
                _currentPasswordController.clear();
              } else {
                displayError = state.errorMessage!;
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
              state.action == ProfileAction.changePassword;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                const Icon(Icons.shield_outlined,
                    size: 80, color: AppColors.primaryBlue),
                AppSizes.gapV16,
                Text(
                  loc.menuChangePassword,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                AppSizes.gapV8,
                Text(
                  loc.changePassDesc,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                AppSizes.gapV24,
                AppSizes.gapV16,
                Text(loc.changePassCurrentLabel,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                AppSizes.gapV8,
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrent,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => (value == null || value.isEmpty)
                      ? loc.changePassCurrentEmpty
                      : null,
                  decoration: _buildInputDecoration(
                    icon: Icons.lock_outline,
                    isObscure: _obscureCurrent,
                    onToggleObscure: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                AppSizes.gapV24,
                Text(loc.changePassNewLabel,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                AppSizes.gapV8,
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return loc.changePassNewEmpty;
                    if (value.length < 8) return loc.errorPasswordShort;
                    if (!value.contains(RegExp(r'[A-Z]')))
                      return loc.errorPasswordUppercase;
                    if (!value.contains(RegExp(r'[0-9]')))
                      return loc.errorPasswordNumber;
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    icon: Icons.lock_reset_outlined,
                    isObscure: _obscureNew,
                    onToggleObscure: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                AppSizes.gapV24,
                Text(loc.changePassConfirmLabel,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                AppSizes.gapV8,
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return loc.changePassConfirmEmpty;
                    if (value != _newPasswordController.text)
                      return loc.changePassNotMatch;
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    icon: Icons.done_all_outlined,
                    isObscure: _obscureConfirm,
                    onToggleObscure: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
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
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(loc.changePassUpdateBtn,
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

  InputDecoration _buildInputDecoration(
      {required IconData icon,
      required bool isObscure,
      required VoidCallback onToggleObscure}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      suffixIcon: IconButton(
        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textSecondary),
        onPressed: onToggleObscure,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlue)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent)),
    );
  }
}
