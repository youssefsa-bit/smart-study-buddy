import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/routes/app_routes_name.dart';
import 'package:study_buddy/core/services/injection_container.dart' as di;

import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    final prefs = di.sl<SharedPreferences>();
    await prefs.setBool('IS_FIRST_TIME', false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutesName.login);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: const EdgeInsets.only(bottom: 120),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 3;
            });
          },
          children: [
            _buildPage(
              context,
              icon: Icons.auto_awesome,
              title: loc.onboardingTitle1,
              description: loc.onboardingDesc1,
            ),
            _buildPage(
              context,
              icon: Icons.quiz_rounded,
              title: loc.onboardingTitle2,
              description: loc.onboardingDesc2,
            ),
            _buildPage(
              context,
              icon: Icons.translate_rounded,
              title: loc.onboardingTitle3,
              description: loc.onboardingDesc3,
            ),
            _buildPage(
              context,
              icon: Icons.history_rounded,
              title: loc.onboardingTitle4,
              description: loc.onboardingDesc4,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 120,
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmoothPageIndicator(
              controller: _pageController,
              count: 4,
              effect: ExpandingDotsEffect(
                spacing: 12,
                dotColor: Colors.grey.withOpacity(0.5),
                activeDotColor: AppColors.primaryBlue,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: isLastPage
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: () => _pageController.jumpToPage(3),
                          child: Text(
                            loc.onboardingSkip,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      isLastPage
                          ? loc.onboardingGetStarted
                          : loc.onboardingNext,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
                child: SizedBox(
              height: 15,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required IconData icon,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 100,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 64),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
