import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'models/player.dart';

class PlayerNameScreen extends StatefulWidget {
  const PlayerNameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    player1FocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
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
