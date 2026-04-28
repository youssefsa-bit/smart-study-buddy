import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
            Text("Update Password",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          "Are you sure you want to change your password? You will need to use the new password next time you log in.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileBloc>().add(
                    ChangePasswordEvent(_currentPasswordController.text,
                        _newPasswordController.text),
                  );
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Security",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success &&
              state.action == ProfileAction.changePassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Password changed successfully!"),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.error &&
              state.action == ProfileAction.changePassword) {
            String displayError =
                "An unexpected error occurred. Please try again.";
            if (state.errorMessage != null) {
              final errorStr = state.errorMessage!.toLowerCase();
              if (errorStr.contains("password") ||
                  errorStr.contains("400") ||
                  errorStr.contains("401") ||
                  errorStr.contains("incorrect")) {
                displayError = "The current password you entered is incorrect.";

                _currentPasswordController.clear();
              } else {
                displayError = state.errorMessage!;
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(displayError,
                            style: const TextStyle(color: Colors.white))),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 4),
              ),
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
                const Text(
                  "Change Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
               AppSizes.gapV8,
                const Text(
                  "Your password must be at least 8 characters and include 1 uppercase letter and 1 number.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
               AppSizes.gapV24,
               AppSizes.gapV16,
                const Text("Current Password",
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
              AppSizes.gapV8,
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrent,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Please enter your current password"
                      : null,
                  decoration: _buildInputDecoration(
                    icon: Icons.lock_outline,
                    isObscure: _obscureCurrent,
                    onToggleObscure: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                AppSizes.gapV24,
                const Text("New Password",
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
               AppSizes.gapV8,
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please enter a new password";
                    if (value.length < 8)
                      return "Must be at least 8 characters";
                    if (!value.contains(RegExp(r'[A-Z]')))
                      return "Must contain at least 1 uppercase letter";
                    if (!value.contains(RegExp(r'[0-9]')))
                      return "Must contain at least 1 number";
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
                const Text("Confirm New Password",
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                AppSizes.gapV8,
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Please confirm your new password";
                    if (value != _newPasswordController.text)
                      return "Passwords do not match";
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
                              _showConfirmationDialog(context);
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("Update Password",
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
