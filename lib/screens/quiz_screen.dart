import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/answer_button.dart';
import '../widgets/timer_badge.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final purpleColor = const Color(0xFF8A2BE2);
    final lightPurple = const Color(0xFFF3E5F5);

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizFinished) {
          context.go('/result');
        }
      },
      builder: (context, state) {
        if (state is QuizInitial) {
          context.read<QuizBloc>().add(QuizStarted());
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is! QuizInProgress) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final question = state.questions[state.currentQuestionIndex];
        final questionNumber = (state.currentQuestionIndex + 1).toString().padLeft(2, '0');
        final totalQuestions = state.questions.length.toString().padLeft(2, '0');

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
              ),
              onPressed: () {
                context.read<QuizBloc>().add(QuizReset());
                context.go('/');
              },
            ),
            title: Text(
              'Quiz',
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question',
                          style: GoogleFonts.dmSans(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: questionNumber,
                                style: GoogleFonts.dmSans(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' /$totalQuestions',
                                style: GoogleFonts.dmSans(
                                  color: Colors.grey.shade300,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TimerBadge(seconds: state.remainingTime),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  question.text,
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
                      return AnswerButton(
                        text: question.options[index],
                        optionLabel: optionLabel,
                        isSelected: state.selectedIndex == index,
                        onTap: () {
                          context.read<QuizBloc>().add(QuestionAnswered(index));
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () {
                              
                              context.read<QuizBloc>().add(QuizReset());
                              context.go('/');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: lightPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: GoogleFonts.dmSans(
                                color: purpleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<QuizBloc>().add(NextButtonPressed());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purpleColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Next',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
