import 'package:flutter/material.dart';
import 'models/player.dart';
import 'new_game_screen.dart';

class HomeScreen extends StatefulWidget {
  final Player player1;
  final Player player2;

  const HomeScreen({
    super.key,
    required this.player1,
    required this.player2,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String player1IgraText = '';
  String player1ZvanjeText = '';
  String player2IgraText = '';
  String player2ZvanjeText = '';

  bool isCalculatingIgra = true;
  bool isPlayer1Active = true;
  void _updateText(String newText) {
    setState(() {
      if (isPlayer1Active) {
        if (newText == '>') {
          // Reset all scores to ''
          player1IgraText = '';
          player1ZvanjeText = '';
          player2IgraText = '';
          player2ZvanjeText = '';
        } else if (newText == '<') {
          // Delete last digit of player1's igraText or zvanjeText based on active mode
          if (isCalculatingIgra && player1IgraText.isNotEmpty) {
            player1IgraText =
                player1IgraText.substring(0, player1IgraText.length - 1);
            // Recalculate player2's igraText
            if (player1IgraText == "") {
              player1IgraText = '0';
            }
            player2IgraText =
                (120 - int.parse(player1IgraText)).clamp(0, 120).toString();
            if (player1IgraText == '0') {
              player1IgraText = '';
            }
          } else if (!isCalculatingIgra && player1ZvanjeText.isNotEmpty) {
            player1ZvanjeText =
                player1ZvanjeText.substring(0, player1ZvanjeText.length - 1);
          }
        } else {
          if (isCalculatingIgra) {
            if (player1IgraText.length < 3) {
              player1IgraText += newText;
              // Calculate player2IgraText, clamping it to 0 if it goes negative
              player2IgraText =
                  (120 - int.parse(player1IgraText)).clamp(0, 120).toString();
            }
          } else {
            if (player1ZvanjeText.length < 3) {
              player1ZvanjeText += newText;
            }
          }
        }
      } else {
        if (newText == '>') {
          // Reset all scores to ''
          player1IgraText = '';
          player1ZvanjeText = '';
          player2IgraText = '';
          player2ZvanjeText = '';
        } else if (newText == '<') {
          // Delete last digit of player2's igraText or zvanjeText based on active mode
          if (isCalculatingIgra && player2IgraText.isNotEmpty) {
            player2IgraText =
                player2IgraText.substring(0, player2IgraText.length - 1);
            // Recalculate player1's igraText
            if (player2IgraText == "") {
              player2IgraText = '0';
            }
            player1IgraText =
                (120 - int.parse(player2IgraText)).clamp(0, 120).toString();
            if (player2IgraText == '0') {
              player2IgraText = '';
            }
          } else if (!isCalculatingIgra && player2ZvanjeText.isNotEmpty) {
            player2ZvanjeText =
                player2ZvanjeText.substring(0, player2ZvanjeText.length - 1);
          }
        } else {
          if (isCalculatingIgra) {
            if (player2IgraText.length < 3) {
              player2IgraText += newText;
              // Calculate player1IgraText, clamping it to 0 if it goes negative

              player1IgraText =
                  (120 - int.parse(player2IgraText)).clamp(0, 120).toString();
            }
          } else {
            if (player2ZvanjeText.length < 3) {
              player2ZvanjeText += newText;
            }
          }
        }
      }
    });
  }

  Widget _buildButton(String label) {
    return Container(
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: () => _updateText(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Colors.white,
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    int player1IgraInt =
        player1IgraText.isEmpty ? 0 : int.parse(player1IgraText);
    int player1ZvanjeInt =
        player1ZvanjeText.isEmpty ? 0 : int.parse(player1ZvanjeText);
    int player1Sum = player1IgraInt + player1ZvanjeInt;

    int player2IgraInt =
        player2IgraText.isEmpty ? 0 : int.parse(player2IgraText);
    int player2ZvanjeInt =
        player2ZvanjeText.isEmpty ? 0 : int.parse(player2ZvanjeText);
    int player2Sum = player2IgraInt + player2ZvanjeInt;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trenutna igra"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green[50],
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPlayer1Active = true;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            widget.player1.name,
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  isPlayer1Active ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Igra: $player1IgraText",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  isPlayer1Active ? Colors.black : Colors.grey,
                            ),
                          ),
                          Text(
                            "Zvanje: $player1ZvanjeText",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  isPlayer1Active ? Colors.black : Colors.grey,
                            ),
                          ),
                          Text(
                            "Ukupno: $player1Sum",
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  isPlayer1Active ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPlayer1Active = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            widget.player2.name,
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  !isPlayer1Active ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Igra: $player2IgraText",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  !isPlayer1Active ? Colors.black : Colors.grey,
                            ),
                          ),
                          Text(
                            "Zvanje: $player2ZvanjeText",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  !isPlayer1Active ? Colors.black : Colors.grey,
                            ),
                          ),
                          Text(
                            "Ukupno: $player2Sum",
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  !isPlayer1Active ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCalculatingIgra = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 4,
                        backgroundColor:
                            isCalculatingIgra ? Colors.green : Colors.grey,
                      ),
                      child: const Text('IGRA',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCalculatingIgra = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 4,
                        backgroundColor:
                            !isCalculatingIgra ? Colors.green : Colors.grey,
                      ),
                      child: const Text('ZVANJA',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(1.0),
              child: GridView.count(
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling,
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.1,
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('>'),
                  _buildButton('0'),
                  _buildButton('<'),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: (player1Sum == 0 && player2Sum == 0)
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewGameScreen(
                            player1: widget.player1,
                            player2: widget.player2,
                            isPlayerTurn: !widget.player1.isPlayerTurn,
                            player1Sum: player1Sum,
                            player2Sum: player2Sum,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text('GOTOVO',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
