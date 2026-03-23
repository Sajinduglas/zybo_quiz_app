import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final int questionIndex;
  final String questionText;
  final int score; // 0 or 1
  final int timeTaken; // in seconds

  const QuizResult({
    required this.questionIndex,
    required this.questionText,
    required this.score,
    required this.timeTaken,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionIndex': questionIndex,
      'questionText': questionText,
      'score': score,
      'timeTaken': timeTaken,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      questionIndex: map['questionIndex'],
      questionText: map['questionText'],
      score: map['score'],
      timeTaken: map['timeTaken'],
    );
  }

  @override
  List<Object?> get props => [questionIndex, questionText, score, timeTaken];
}
