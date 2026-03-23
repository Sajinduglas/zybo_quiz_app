import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerBadge extends StatelessWidget {
  final int seconds;

  const TimerBadge({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final purpleColor = const Color(0xFF8A2BE2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: purpleColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '${seconds}s',
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
