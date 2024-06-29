class Player {
  final String name;
  int points = 9; // Add points field
  bool isPlayerTurn = true; // Add points field

  Player(
      {required this.name,
      this.points = 9,
      required this.isPlayerTurn}); // Initialize points to 9
}
