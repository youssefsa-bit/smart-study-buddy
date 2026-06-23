import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mcq_entity.dart';
import '../widgets/options_card.dart';
import 'quiz_result_view.dart';

class QuizView extends StatefulWidget {
  final QuizEntity quiz;

  const QuizView({super.key, required this.quiz});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int currentIndex = 0;
  Map<int, String> userAnswers = {};

  int get score {
    int s = 0;
    userAnswers.forEach((index, answer) {
      if (widget.quiz.questions[index].correctAnswer == answer) {
        s++;
      }
    });
    return s;
  }

  void _onOptionSelected(String optionLabel) {
    if (userAnswers.containsKey(currentIndex)) return;

    setState(() {
      userAnswers[currentIndex] = optionLabel;
    });
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (currentIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentIndex++;
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
    final loc = AppLocalizations.of(context)!;
    final question = widget.quiz.questions[currentIndex];
    final progressValue = (currentIndex + 1) / widget.quiz.questions.length;
    final selectedOption = userAnswers[currentIndex];
    final isAnswered = userAnswers.containsKey(currentIndex);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${currentIndex + 1}/${widget.quiz.questions.length}",
                  style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: AppColors.surfaceHighlight,
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 30),
          Text(
            question.text,
            style: TextStyle(
                color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
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
                  isWrong: isAnswered &&
                      selectedOption == label &&
                      label != question.correctAnswer,
                  onTap: () => _onOptionSelected(label),
                );
              },
            ),
          ),
          Row(
            children: [
              if (currentIndex > 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade300
                            : AppColors.surfaceHighlight,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _previousQuestion,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios,
                              color: AppColors.textPrimary, size: 14),
                          const SizedBox(width: 2),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                loc.mcqPreviousQuestion,
                                style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (isAnswered)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: currentIndex > 0 ? 8.0 : 0.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _nextQuestion,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                currentIndex == widget.quiz.questions.length - 1
                                    ? loc.mcqShowResult
                                    : loc.mcqNextQuestion,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
