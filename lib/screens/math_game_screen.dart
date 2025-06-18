import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class MathGameScreen extends StatefulWidget {
  final String playerName;
  final String playerAvatar;
  
  const MathGameScreen({
    super.key,
    required this.playerName,
    required this.playerAvatar,
  });

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  int num1 = 0;
  int num2 = 0;
  String operator = '+';
  int correctAnswer = 0;
  int score = 0;
  int level = 1;
  final TextEditingController _answerController = TextEditingController();
  bool isCorrect = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    final random = Random();
    num1 = random.nextInt(10 * level) + 1;
    num2 = random.nextInt(10 * level) + 1;
    
    final operators = ['+', '-', '×'];
    operator = operators[random.nextInt(operators.length)];
    
    switch (operator) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        if (num1 < num2) {
          final temp = num1;
          num1 = num2;
          num2 = temp;
        }
        correctAnswer = num1 - num2;
        break;
      case '×':
        correctAnswer = num1 * num2;
        break;
    }
    
    _answerController.clear();
    message = '';
  }

  void checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    if (userAnswer == null) {
      setState(() {
        message = 'Lütfen geçerli bir sayı girin!';
        isCorrect = false;
      });
      return;
    }

    setState(() {
      if (userAnswer == correctAnswer) {
        score += 10;
        level++;
        message = 'Doğru! +10 puan';
        isCorrect = true;
        generateQuestion();
      } else {
        message = 'Yanlış! Doğru cevap: $correctAnswer';
        isCorrect = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.playerAvatar,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 10),
            Text(
              'Matematik Oyunu',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Oyuncu: ${widget.playerName}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Puan: $score',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Seviye: $level',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '$num1 $operator $num2 = ?',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 24),
              decoration: InputDecoration(
                hintText: 'Cevabınızı girin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                'Kontrol Et',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
} 