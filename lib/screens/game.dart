import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constant/colors.dart';

import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  String result = '';
  List<int> matchIndices = [];

  int attemps = 0;

  int oScore = 0;
  int xScore = 0;
  int filled = 0;

  bool winnerFound = false;

  TextStyle upperTextStyle() {
    return GoogleFonts.coiny(color: MainColor.secondary, fontSize: 40);
  }

  void updateScore(String winner) {
    if (winner == '0') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }

    winnerFound = true;
  }

  void clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      result = '';
    });
    filled = 0;
    matchIndices = [];
  }

  Timer? timer;
  static const int maxSeconds = 30;
  int seconds = maxSeconds;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (value) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  Widget _buildTimer() {
    final bool isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1 - seconds / maxSeconds,
                valueColor: AlwaysStoppedAnimation(MainColor.primary),
                strokeWidth: 8,
                backgroundColor: MainColor.secondary,
              ),
              Center(
                child: Text(
                  '$seconds',
                  style: TextStyle(
                    color: MainColor.accent,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
        : ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: MainColor.secondary),
          onPressed: () {
            startTimer();
            clearBoard();
            attemps++;
          },
          child: Text(
            attemps == 0 ? 'Start' : 'Play Again !',
            style: TextStyle(color: MainColor.accent, fontSize: 22),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MainColor.primary,
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Player 0', style: upperTextStyle()),
                      Text(oScore.toString(), style: upperTextStyle()),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Player X', style: upperTextStyle()),
                      Text(xScore.toString(), style: upperTextStyle()),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: EdgeInsets.all(5),
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: MainColor.primary, width: 5),
                        color:
                            matchIndices.contains(index)
                                ? MainColor.secondary
                                : MainColor.accent,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          displayXO[index],
                          style: GoogleFonts.coiny(fontSize: 70),
                          // style: TextStyle(fontSize: 46)
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(result, style: upperTextStyle()),
                    SizedBox(height: 10),
                    _buildTimer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    final bool isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = '0';
          filled++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filled++;
        }

        oTurn = !oTurn;

        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // checking 1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        result = 'Player ${displayXO[0]} Wins !';
        matchIndices.addAll([0, 1, 2]);
        stopTimer();
        updateScore(displayXO[0]);
      });
    }

    // checking 2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        result = 'Player ${displayXO[3]} Wins !';
        matchIndices.addAll([3, 4, 5]);
        stopTimer();
        updateScore(displayXO[3]);
      });
    }

    // checking 3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        result = 'Player ${displayXO[6]} Wins !';
        matchIndices.addAll([6, 7, 8]);
        stopTimer();
        updateScore(displayXO[6]);
      });
    }

    // checking LTR Diagonal
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        result = 'Player ${displayXO[0]} Wins !';
        matchIndices.addAll([0, 4, 8]);
        stopTimer();
        updateScore(displayXO[0]);
      });
    }

    // checking RTL Diagonal
    if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != '') {
      setState(() {
        result = 'Player ${displayXO[2]} Wins !';
        matchIndices.addAll([2, 4, 6]);
        stopTimer();
        updateScore(displayXO[2]);
      });
    }

    // checking 1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        result = 'Player ${displayXO[0]} Wins !';
        matchIndices.addAll([0, 3, 6]);
        stopTimer();
        updateScore(displayXO[0]);
      });
    }

    // checking 2nd column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        result = 'Player ${displayXO[1]} Wins !';
        matchIndices.addAll([1, 4, 7]);
        stopTimer();
        updateScore(displayXO[1]);
      });
    }
    // checking 3rd column
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      setState(() {
        result = 'Player ${displayXO[2]} Wins !';
        matchIndices.addAll([2, 5, 8]);
        stopTimer();
        updateScore(displayXO[2]);
      });
    }
    if (!winnerFound && filled == 9) {
      setState(() {
        result = 'Nobody Wins !';
        // stopTimer();
      });
    }
  }
}
