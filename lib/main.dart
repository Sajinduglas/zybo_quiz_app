import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/quiz_bloc.dart';
import 'repositories/quiz_repository.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => QuizRepository(),
      child: BlocProvider(
        create: (context) => QuizBloc(
          repository: context.read<QuizRepository>(),
        ),
        child: MaterialApp.router(
          title: 'Quiz App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            useMaterial3: true,
            textTheme: GoogleFonts.dmSansTextTheme(),
          ),
          routerConfig: _router,
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);
