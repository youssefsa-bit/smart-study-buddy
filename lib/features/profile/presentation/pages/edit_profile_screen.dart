import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
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
    final currentUser = context.read<ProfileBloc>().state.user;
    _nameController = TextEditingController(text: currentUser?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            Icon(Icons.info_outline, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text("Confirm Update",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          "Are you sure you want to save these changes to your profile?",
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
              context
                  .read<ProfileBloc>()
                  .add(UpdateNameEvent(_nameController.text.trim()));
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
        title: const Text("Edit Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success &&
              state.action == ProfileAction.updateName) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Name updated successfully!"),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.error &&
              state.action == ProfileAction.updateName) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? "Error updating name"),
                  backgroundColor: Colors.redAccent),
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
                const Icon(Icons.person_pin_rounded,
                    size: 80, color: AppColors.primaryBlue),
                AppSizes.gapV16,
                const Text(
                  "Update Your Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                AppSizes.gapV8,
                const Text(
                  "Make sure your name matches your academic records.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                AppSizes.gapV24,
                AppSizes.gapV24,
                const Text("Full Name",
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
                AppSizes.gapV8,
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name cannot be empty";
                    }
                    if (value.trim().length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: AppColors.primaryBlue)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.redAccent)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.redAccent)),
                  ),
                ),
                const SizedBox(height: 40),
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
                        : const Text("Save Changes",
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
