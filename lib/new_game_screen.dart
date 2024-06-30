import 'package:flutter/material.dart';
import 'models/player.dart';
import 'package:confetti/confetti.dart';
import 'player_name_screen.dart';
import 'home_screen.dart';

class NewGameScreen extends StatefulWidget {
  final Player player1;
  final Player player2;
  final int player1Sum;
  final int player2Sum;
  final bool isPlayerTurn;

  const NewGameScreen({
    super.key,
    required this.player1,
    required this.player2,
    required this.player1Sum,
    required this.player2Sum,
    required this.isPlayerTurn,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  bool _isNewGameEnabled = true; // Initially enabled
  bool x = false;
  late String winner;

  @override
  void initState() {
    super.initState();
    determineWinner();
  }

  void determineWinner() {
    if (widget.player1Sum == 0 && widget.player2Sum == 0) {
      print("Game over");
    } else {
      if (widget.player1Sum > widget.player2Sum) {
        if (widget.player2Sum == 0) {
          widget.player1.points -= 3;
        } else if (widget.player2Sum < 33) {
          widget.player1.points -= 2;
        } else {
          widget.player1.points -= 1;
        }
        if (widget.player1.points < 0) {
          widget.player1.points = 0;
        }
      } else {
        if (widget.player1Sum == 0) {
          widget.player2.points -= 3;
        } else if (widget.player1Sum < 33) {
          widget.player2.points -= 2;
        } else {
          widget.player2.points -= 1;
        }
        if (widget.player2.points < 0) {
          widget.player2.points = 0;
        }
      }
      if (widget.player1.points == 0) {
        setState(() {
          x = true;
          _isNewGameEnabled = false;
          winner = widget.player1.name;
        });
      }
      if (widget.player2.points == 0) {
        setState(() {
          x = true;
          _isNewGameEnabled = false;
          winner = widget.player2.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Player modifiedPlayer1 = Player(
      name: widget.player1.name,
      points: widget.player1.points,
      isPlayerTurn: !widget.player1.isPlayerTurn,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snaps blok'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(widget.player1.name,
                        style: TextStyle(
                            fontSize: 30,
                            color: widget.isPlayerTurn
                                ? Colors.green
                                : Colors.black)),
                    Text(widget.player1.points.toString(),
                        style:
                            const TextStyle(fontSize: 50, color: Colors.red)),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Text(widget.player2.name,
                        style: TextStyle(
                            fontSize: 30,
                            color: !widget.isPlayerTurn
                                ? Colors.green
                                : Colors.black)),
                    Text(widget.player2.points.toString(),
                        style:
                            const TextStyle(fontSize: 50, color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isNewGameEnabled
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                player1: modifiedPlayer1,
                                player2: widget.player2,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'NOVA IGRA',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: x,
                  child: Builder(
                    builder: (context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showWinnerDialog(context, winner);
                      });
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Visibility(
                  visible: x,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.player1.points = 9;
                      widget.player1.isPlayerTurn = true;

                      widget.player2.points = 9;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            player1: widget.player1,
                            player2: widget.player2,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 112),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('REFRESH',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('KRAJ',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWinnerDialog(BuildContext context, String winner) {
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              title: const Text('Čestitamo!'),
              content: Text('Pobijedio je $winner!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ],
        );
      },
    );

    confettiController.play();
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Jeste li sigurni?'),
          content: const Text('Želite li stvarno završiti igru?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'NE',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerNameScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'DA',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
