import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_assets.dart';
import 'package:study_buddy/core/extensions/auth_error_extension.dart';
import 'package:study_buddy/core/extensions/auth_message_extension.dart';
import 'package:study_buddy/core/routes/app_routes_name.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/services/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../manager/auth_bloc.dart';
import '../manager/auth_event.dart';
import '../manager/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAssets.logoDarkBlue,
                    width: double.infinity,
                    height: 250,
                  ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
                  AppSizes.gapV24,
                  Text(loc.createAccount,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  AppSizes.gapV8,
                  Text(loc.fillYourDetails,
                      style: TextStyle(color: AppColors.textGrey)),
                  AppSizes.gapV24,
                  CustomTextField(
                    controller: _nameController,
                    labelText: loc.fullName,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.errorEmptyName;
                      }
                      if (value.trim().length < 3) {
                        return loc.errorNameShort;
                      }
                      return null;
                    },
                  ),
                  AppSizes.gapV16,
                  CustomTextField(
                    controller: _emailController,
                    labelText: loc.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.errorEmptyEmail;
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value.trim());
                      if (!emailValid) {
                        return loc.errorInvalidEmail;
                      }
                      return null;
                    },
                  ),
                  AppSizes.gapV16,
                  CustomTextField(
                    controller: _passwordController,
                    labelText: loc.password,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.errorEmptyPassword;
                      }
                      if (value.length < 8) {
                        return loc.errorPasswordShort;
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return loc.errorPasswordUppercase;
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return loc.errorPasswordNumber;
                      }
                      return null;
                    },
                  ),
                  AppSizes.gapV16,
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: loc.registerConfirmPassword,
                    prefixIcon: Icons.done_all_outlined,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.errorEmptyPassword;
                      }
                      if (value != _passwordController.text) {
                        return loc.errorPasswordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  AppSizes.gapV24,
                  AppSizes.gapV8,
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        CustomSnackBar.show(
                          context: context,
                          message: state.message?.localized(loc) ?? "",                          isError: false,
                        );
                        Navigator.pushReplacementNamed(
                            context, AppRoutesName.login);
                      } else if (state is AuthFailure) {
                        CustomSnackBar.show(
                          context: context,
                          message: state.error.localized(loc),
                          isError: true,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryBlue));
                      }

                      return AuthButton(
                        text: loc.signUp,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  RegisterRequested(
                                    _nameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                  AppSizes.gapV24,
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRoutesName.login),
                      child: RichText(
                        text: TextSpan(
                          text: loc.alreadyHaveAnAccount,
                          style: TextStyle(color: AppColors.textGrey),
                          children: [
                            TextSpan(
                                text: loc.login,
                                style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSizes.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
