import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizStarted extends QuizEvent {}

class QuestionAnswered extends QuizEvent {
  final int selectedIndex;
  const QuestionAnswered(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

class TimerTicked extends QuizEvent {
  final int duration;
  const TimerTicked(this.duration);

  @override
  List<Object?> get props => [duration];
}

class TimerExpired extends QuizEvent {}

class NextButtonPressed extends QuizEvent {}

class QuizReset extends QuizEvent {}
