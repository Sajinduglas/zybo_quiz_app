import '../models/question.dart';

class QuizRepository {
  List<Question> getQuestions() {
    return const [
      Question(
        text: 'Who won the Dadasaheb Phalke award in 2025?',
        options: ['Rajnikant', 'Mohanlal', 'Shah Rukh Khan', 'Chiranjeevi'],
        correctAnswerIndex: 1,
      ),
      Question(
        text: 'Which country won the FIFA World Cup in 2022?',
        options: ['France', 'Argentina', 'Brazil', 'Croatia'],
        correctAnswerIndex: 1,
      ),
      Question(
        text: 'In cricket, how many players are there in one team on the field?',
        options: ['9', '10', '11', '12'],
        correctAnswerIndex: 2,
      ),
      Question(
        text: 'Who is known as the "King of Pop"?',
        options: ['Elvis Presley', 'Freddie Mercury', 'Michael Jackson', 'Justin Timberlake'],
        correctAnswerIndex: 2,
      ),
      Question(
        text: 'Which Indian musician won an Oscar for Slumdog Millionaire?',
        options: ['Zakir Hussain', 'A.R. Rahman', 'Ravi Shankar', 'Ilaiyaraaja'],
        correctAnswerIndex: 1,
      ),
    ];
  }
}
