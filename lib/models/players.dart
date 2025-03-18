/*The Player class is essential for managing player-related data in your Tic-Tac-Toe game. 
It acts as a data model to store, transfer, and manipulate player information efficiently.*/

/*The toMap() and fromMap() methods are used for data serialization and deserialization.

toMap(): Converts a Player object into a Map (key-value pairs).

fromMap(): Converts a Map (received from a database, API, or Socket.IO) back into a Player object.
*/

/// Player model class for managing player data.
class Player {
  final String username;
  final String socketID;
  final double points;
  final String playerType;

  /// Constructor to initialize a Player object.
  Player({
    required this.username,
    required this.socketID,
    required this.points,
    required this.playerType,
  });

  /// Converts a Player object into a Map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'socketID': socketID,
      'points': points,
      'playerType': playerType,
    };
  }

  /// Creates a Player object from a Map (deserialization).
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      username: map['username'] ?? '',
      socketID: map['socketID'] ?? '',
      points: map['points']?.toDouble() ?? 0.0,
      playerType: map['playerType'] ?? '',
    );
  }

  /// Returns a new Player object with updated fields.
  Player copyWith({
    String? username,
    String? socketID,
    double? points,
    String? playerType,
  }) {
    return Player(
      username: username ?? this.username,
      socketID: socketID ?? this.socketID,
      points: points ?? this.points,
      playerType: playerType ?? this.playerType,
    );
  }
}
