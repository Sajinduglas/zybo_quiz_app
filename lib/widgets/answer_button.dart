import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final String optionLabel; // A, B, C, D
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.text,
    required this.optionLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final purpleColor = const Color(0xFF8A2BE2); // Adjust to match the design's purple
    final lightPurple = const Color(0xFFF3E5F5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? lightPurple : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? purpleColor : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                '$optionLabel. ',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? purpleColor : Colors.grey.shade600,
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
