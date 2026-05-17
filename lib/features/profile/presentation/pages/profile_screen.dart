import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/manager/language_cubit.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../l10n/app_localizations.dart';
import '../manager/profile_bloc.dart';
import '../manager/profile_event.dart';
import '../manager/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  void _showLogoutConfirmationDialog(
      BuildContext context, AppLocalizations loc) {
    final bloc = context.read<ProfileBloc>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            AppSizes.gapH8,
            Text(loc.logoutDialogTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          loc.logoutDialogContent,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.dialogCancel, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(LogoutRequestedEvent());
            },
            child: Text(loc.menuLogout, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.menuLanguage,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                AppSizes.gapV24,
                ListTile(
                  leading: const Text("🇬🇧", style: TextStyle(fontSize: 24)),
                  title: const Text("English",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('en');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Text("🇪🇬", style: TextStyle(fontSize: 24)),
                  title: const Text("العربية",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage('ar');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
              final loc = AppLocalizations.of(context)!;
              final user = state.user;
              final String displayName =
                  user?.name ?? state.cachedName ?? "...";

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    AppSizes.gapV24,
                    ProfileHeader(
                        name: displayName, email: user?.email ?? "..."),
                    AppSizes.gapV24,
                    AppSizes.gapV8,
                    ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: loc.menuEditProfile,
                        onTap: () {
                          final currentState =
                              context.read<ProfileBloc>().state;
                          bool isOffline = false;
                          if (currentState.status == ProfileStatus.error &&
                              currentState.errorMessage != null) {
                            final errorStr =
                                currentState.errorMessage!.toLowerCase();
                            if (errorStr.contains('connection') ||
                                errorStr.contains('timeout') ||
                                errorStr.contains('network') ||
                                errorStr.contains('socket')) {
                              isOffline = true;
                            }
                          }
                          if (isOffline) {
                            CustomSnackBar.show(
                              context: context,
                              message: loc.errorNoConnection,
                              isError: true,
                              customIcon: Icons.wifi_off_rounded,
                            );
                            return;
                          }
                          Navigator.pushNamed(
                              context, AppRoutesName.editProfile,
                              arguments: context.read<ProfileBloc>());
                        }),
                    ProfileMenuItem(
                        icon: Icons.lock_outline,
                        title: loc.menuChangePassword,
                        onTap: () {
                          final currentState =
                              context.read<ProfileBloc>().state;
                          bool isOffline = false;
                          if (currentState.status == ProfileStatus.error &&
                              currentState.errorMessage != null) {
                            final errorStr =
                                currentState.errorMessage!.toLowerCase();
                            if (errorStr.contains('connection') ||
                                errorStr.contains('timeout') ||
                                errorStr.contains('network') ||
                                errorStr.contains('socket')) {
                              isOffline = true;
                            }
                          }
                          if (isOffline) {
                            CustomSnackBar.show(
                              context: context,
                              message: loc.errorNoConnection,
                              isError: true,
                              customIcon: Icons.wifi_off_rounded,
                            );
                            return;
                          }
                          Navigator.pushNamed(
                              context, AppRoutesName.changePassword,
                              arguments: context.read<ProfileBloc>());
                        }),
                    ProfileMenuItem(
                      icon: Icons.language_rounded,
                      title: loc.menuLanguage,
                      trailing: Text(loc.langCurrent,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 16)),
                      onTap: () => _showLanguageBottomSheet(context, loc),
                    ),
                    ProfileMenuItem(
                        icon: Icons.dark_mode_rounded,
                        title: loc.menuThemeMode,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.dark_mode_rounded,
                                color: AppColors.primaryBlue, size: 18),
                            AppSizes.gapH8,
                            Text(loc.themeDark,
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16)),
                          ],
                        ),
                        onTap: () {}),
                    ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: loc.menuSettings,
                        onTap: () {}),
                    AppSizes.gapV24,
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      title: loc.menuLogout,
                      textColor: Colors.redAccent,
                      onTap: () => _showLogoutConfirmationDialog(context, loc),
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
