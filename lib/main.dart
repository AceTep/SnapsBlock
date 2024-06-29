import 'package:flutter/material.dart';
import 'models/player.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const SnapsBlok());
}

class SnapsBlok extends StatelessWidget {
  const SnapsBlok({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snaps Blok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home:
          const SplashScreenWidget(), // Use SplashScreenWidget as the initial screen
    );
  }
}

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    // Simulacija vremena za prikaz SplashScreen-a, ovdje možete postaviti i stvarnu logiku za inicijalizaciju
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlayerNameScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Snaps Blok',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'images/logo.png', // Put your logo asset path here
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerNameScreen extends StatefulWidget {
  const PlayerNameScreen({super.key});

  @override
  _PlayerNameScreenState createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  final FocusNode player1FocusNode = FocusNode(); // Focus node for player 1

  String player1HintText = 'Igrač 1 treba mješati prvi'; // Initial hint text

  @override
  void initState() {
    super.initState();
    // Listen for focus changes
    player1FocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Clean up the focus node when done
    player1FocusNode.removeListener(_onFocusChange);
    player1FocusNode.dispose();
    super.dispose();
  }

  // Update hint text when focus changes
  void _onFocusChange() {
    setState(() {
      if (player1FocusNode.hasFocus) {
        player1HintText = 'Igrač 1 treba mješati prvi';
      } else {
        player1HintText = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unesite imena igrača"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: player1Controller,
              focusNode: player1FocusNode, // Assign focus node
              decoration: InputDecoration(
                labelText: "Ime igrača 1",
                hintText: player1HintText, // Use hint text dynamically
              ),
            ),
            TextField(
              controller: player2Controller,
              decoration: const InputDecoration(labelText: "Ime igrača 2"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (player1Controller.text.isEmpty ||
                    player2Controller.text.isEmpty) {
                  _showWarningDialog(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        player1: Player(
                            name: player1Controller.text, isPlayerTurn: true),
                        player2: Player(
                            name: player2Controller.text, isPlayerTurn: true),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("POČNI IGRU",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upozorenje'),
          content: const Text('Morate unijeti imena igrača!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

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
                          borderRadius:
                              BorderRadius.circular(5), // Adjust as needed
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
                childAspectRatio: 1.1, // Adjust ratio as needed
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
      isPlayerTurn: !widget.player1.isPlayerTurn, // Change the desired property
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
