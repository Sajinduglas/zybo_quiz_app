import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/quiz_repository.dart';
import '../models/quiz_result.dart';
import '../database/database_helper.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;
  Timer? _timer;
  static const int questionDuration = 30;

  QuizBloc({required QuizRepository repository})
      : _repository = repository,
        super(QuizInitial()) {
    on<QuizStarted>(_onQuizStarted);
    on<QuestionAnswered>(_onQuestionAnswered);
    on<TimerTicked>(_onTimerTicked);
    on<TimerExpired>(_onTimerExpired);
    on<NextButtonPressed>(_onNextButtonPressed);
    on<QuizReset>(_onQuizReset);
  }

  void _onQuizStarted(QuizStarted event, Emitter<QuizState> emit) {
    final questions = _repository.getQuestions();
    emit(QuizInProgress(
      questions: questions,
      currentQuestionIndex: 0,
      remainingTime: questionDuration,
      results: const [],
    ));
    _startTimer();
  }

  void _onQuestionAnswered(QuestionAnswered event, Emitter<QuizState> emit) {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;
    
    // Update selected index in state so UI shows selection
    emit(currentState.copyWith(selectedIndex: event.selectedIndex));
    
    
  }

  
  
  void _onTimerTicked(TimerTicked event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      if (event.duration > 0) {
        emit(currentState.copyWith(remainingTime: event.duration));
      } else {
        add(TimerExpired());
      }
    }
  }

  Future<void> _onTimerExpired(TimerExpired event, Emitter<QuizState> emit) async {
    await _moveToNextQuestion(emit, timedOut: true);
  }

  Future<void> _onNextButtonPressed(NextButtonPressed event, Emitter<QuizState> emit) async {
    await _moveToNextQuestion(emit, timedOut: false);
  }

  Future<void> _moveToNextQuestion(Emitter<QuizState> emit, {bool timedOut = false}) async {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;
    _timer?.cancel();

    final currentQuestion = currentState.questions[currentState.currentQuestionIndex];
    final timeTaken = timedOut ? questionDuration : (questionDuration - currentState.remainingTime);
    
    int score = 0;
    if (!timedOut && currentState.selectedIndex != null) {
      if (currentState.selectedIndex == currentQuestion.correctAnswerIndex) {
        score = 1;
      }
    }

    final result = QuizResult(
      questionIndex: currentState.currentQuestionIndex + 1,
      questionText: currentQuestion.text,
      score: score,
      timeTaken: timeTaken,
    );

    // Save to DB
    await DatabaseHelper.instance.insertResult(result);

    final updatedResults = List<QuizResult>.from(currentState.results)..add(result);

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(QuizInProgress(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        remainingTime: questionDuration,
        results: updatedResults,
        selectedIndex: null,
      ));
      _startTimer();
    } else {
      final totalScore = updatedResults.fold(0, (sum, r) => sum + r.score);
      emit(QuizFinished(results: updatedResults, totalScore: totalScore));
    }
  }

  // Public method for Next button
  Future<void> nextQuestion() async {
    // This is a bit tricky since I'm in a Bloc. 
    // I should probably add a NextQuestionPressed event.
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = questionDuration - timer.tick;
      add(TimerTicked(remaining));
      if (remaining <= 0) {
        timer.cancel();
      }
    });
  }

  void _onQuizReset(QuizReset event, Emitter<QuizState> emit) {
    _timer?.cancel();
    emit(QuizInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
