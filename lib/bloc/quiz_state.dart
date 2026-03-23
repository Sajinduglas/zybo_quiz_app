import 'package:equatable/equatable.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizInProgress extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int remainingTime;
  final List<QuizResult> results;
  final int? selectedIndex; // Index of option selected for current question

  const QuizInProgress({
    required this.questions,
    required this.currentQuestionIndex,
    required this.remainingTime,
    required this.results,
    this.selectedIndex,
  });

  QuizInProgress copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? remainingTime,
    List<QuizResult>? results,
    int? selectedIndex,
    bool clearSelection = false,
  }) {
    return QuizInProgress(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      results: results ?? this.results,
      selectedIndex: clearSelection ? null : (selectedIndex ?? this.selectedIndex),
    );
  }

  @override
  List<Object?> get props => [questions, currentQuestionIndex, remainingTime, results, selectedIndex];
}

class QuizFinished extends QuizState {
  final List<QuizResult> results;
  final int totalScore;

  const QuizFinished({
    required this.results,
    required this.totalScore,
  });

  @override
  List<Object?> get props => [results, totalScore];
}
