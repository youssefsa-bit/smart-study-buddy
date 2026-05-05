import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/mcq_entity.dart';
import '../widgets/options_card.dart';
import 'quiz_result_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizView extends StatefulWidget {
  final QuizEntity quiz;

  const QuizView({super.key, required this.quiz});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int currentIndex = 0;
  int score = 0;
  String? selectedOption;
  bool isAnswered = false;

  void _onOptionSelected(String optionLabel) {
    if (isAnswered) return;

    setState(() {
      selectedOption = optionLabel;
      isAnswered = true;
      if (optionLabel == widget.quiz.questions[currentIndex].correctAnswer) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        isAnswered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultView(
            score: score,
            total: widget.quiz.questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc=AppLocalizations.of(context)!;
    final question = widget.quiz.questions[currentIndex];
    final progressValue = (currentIndex + 1) / widget.quiz.questions.length;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${currentIndex + 1}/${widget.quiz.questions.length}",
                  style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: AppColors.surfaceHighlight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 30),

          Text(
            question.text,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                String label = String.fromCharCode(65 + index);
                return OptionCard(
                  label: label,
                  text: question.options[index],
                  isSelected: selectedOption == label,
                  isCorrect: isAnswered && label == question.correctAnswer,
                  isWrong: isAnswered && selectedOption == label && label != question.correctAnswer,
                  onTap: () => _onOptionSelected(label),
                );
              },
            ),
          ),

          if (isAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: _nextQuestion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentIndex == widget.quiz.questions.length - 1 ? loc.mcqShowResult : loc.mcqNextQuestion,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}