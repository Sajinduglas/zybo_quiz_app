import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });

  @override
  List<Object?> get props => [text, options, correctAnswerIndex];
}
