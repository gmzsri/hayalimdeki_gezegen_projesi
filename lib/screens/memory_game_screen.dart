import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryGameScreen extends StatefulWidget {
  final String playerName;
  final String playerAvatar;
  
  const MemoryGameScreen({
    super.key,
    required this.playerName,
    required this.playerAvatar,
  });

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> emojis = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];
  List<String> gameEmojis = [];
  List<bool> cardFlips = [];
  int? firstCardIndex;
  int? secondCardIndex;
  int score = 0;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    gameEmojis = [...emojis, ...emojis]..shuffle();
    cardFlips = List.generate(gameEmojis.length, (index) => false);
    firstCardIndex = null;
    secondCardIndex = null;
    score = 0;
    moves = 0;
  }

  void checkMatch() {
    if (firstCardIndex != null && secondCardIndex != null) {
      moves++;
      if (gameEmojis[firstCardIndex!] == gameEmojis[secondCardIndex!]) {
        score += 10;
        firstCardIndex = null;
        secondCardIndex = null;
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            cardFlips[firstCardIndex!] = false;
            cardFlips[secondCardIndex!] = false;
            firstCardIndex = null;
            secondCardIndex = null;
          });
        });
      }
    }
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
              'Hafıza Oyunu',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
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
                  'Hamle: $moves',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: gameEmojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (firstCardIndex != null && secondCardIndex != null) return;
                    if (cardFlips[index]) return;

                    setState(() {
                      cardFlips[index] = true;
                      if (firstCardIndex == null) {
                        firstCardIndex = index;
                      } else {
                        secondCardIndex = index;
                        checkMatch();
                      }
                    });
                  },
                  child: Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardFlips[index]
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          cardFlips[index] ? gameEmojis[index] : '?',
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  startGame();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                'Yeni Oyun',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 