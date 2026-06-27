import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_assets.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); //
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppAssets.logoDarkBlue,
                      width: double.infinity,
                      height: 250,
                    ),
                    AppSizes.gapV24,
                    Text(loc.welcomeBack,
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    AppSizes.gapV24,
                    AppSizes.gapV16,
                    CustomTextField(
                      controller: _emailController,
                      labelText: loc.email,
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
                        return null;
                      },
                    ),
                    AppSizes.gapV24,
                    AppSizes.gapV8,
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Navigator.pushReplacementNamed(
                              context, AppRoutesName.main);
                        } else if (state is AuthFailure) {
                          CustomSnackBar.show(
                            context: context,
                            message: state.error,
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
                          text: loc.login,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    LoginRequested(
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
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutesName.register),
                        child: Text(loc.newHereCreateAccount,
                            style:
                                TextStyle(color: AppColors.primaryBlue)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
