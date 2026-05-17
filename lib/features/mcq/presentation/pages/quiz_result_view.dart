import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class QuizResultView extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultView({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    double percentage = total == 0 ? 0 : (score / total);
    int percentageInt = (percentage * 100).toInt();
    Color resultColor =
        percentage >= 0.5 ? Colors.greenAccent : Colors.orangeAccent;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                    ),
                    Center(
                      child: Text(
                        "$percentageInt%",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: resultColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                loc.mcqResultKeepStudying,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                loc.mcqResultScoreLabel(score, total),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutesName.main,
                        arguments: 1);
                  },
                  child: Text(loc.mcqResultDoneBtn,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
