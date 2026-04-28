import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/utils/app_sizes.dart';
import '../manager/profile_bloc.dart';
import '../manager/profile_event.dart';
import '../manager/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  void _showLogoutConfirmationDialog(BuildContext context) {
    final bloc = context.read<ProfileBloc>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "Are you sure you want to log out? You will need to enter your credentials to access your account again.",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(LogoutRequestedEvent());
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(LoadProfileEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.status == ProfileStatus.success &&
                  state.action == ProfileAction.logout) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutesName.login, (route) => false);
              }
            },
            builder: (context, state) {
              if (state.status == ProfileStatus.loading &&
                  state.action == ProfileAction.getProfile) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryBlue));
              }
              final user = state.user;

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    AppSizes.gapV24,
                    ProfileHeader(
                        name: user?.name ?? "...", email: user?.email ?? "..."),
                    const SizedBox(height: 32),
                    ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: "Edit Profile",
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              AppRoutesName.editProfile,
                              arguments: context.read<ProfileBloc>()
                          );
                        }),
                    ProfileMenuItem(
                        icon: Icons.lock_outline,
                        title: "Change Password",
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              AppRoutesName.changePassword,
                              arguments: context.read<ProfileBloc>()
                          );
                        }),
                    ProfileMenuItem(
                        icon: Icons.language_rounded,
                        title: "Language",
                        trailing: const Text("🇬🇧 English",
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 16)),
                        onTap: () {}),
                    ProfileMenuItem(
                        icon: Icons.dark_mode_rounded,
                        title: "Theme Mode",
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.dark_mode_rounded,
                                color: AppColors.primaryBlue, size: 18),
                            AppSizes.gapH8,
                            const Text("Dark",
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16)),
                          ],
                        ),
                        onTap: () {}),
                    ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: "Settings",
                        onTap: () {}),
                    AppSizes.gapV24,
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      title: "Log Out",
                      textColor: Colors.redAccent,
                        onTap: () => _showLogoutConfirmationDialog(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
