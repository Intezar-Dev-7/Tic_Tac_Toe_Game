import 'package:flutter/material.dart';
import 'package:tic_tac_toe/models/players.dart';

// RoomDataProvider is a ChangeNotifier that manages the game state.
// It keeps track of room data, players, and game progress.
class RoomDataProvider extends ChangeNotifier {
  // Stores the room data, such as room ID and other metadata.
  Map<String, dynamic> _roomData = {};

  // Represents the Tic-Tac-Toe board with 9 empty slots initially.
  List<String> _displayElement = ['', '', '', '', '', '', '', '', ''];

  // Keeps track of the number of filled boxes in the game.
  int _filledBoxes = 0;

  // Player 1 (X) details.
  Player _player1 = Player(
    username: '',
    socketID: '',
    points: 0,
    playerType: 'X',
  );

  // Player 2 (O) details.
  Player _player2 = Player(
    username: '',
    socketID: '',
    points: 0,
    playerType: 'O',
  );

  // Getters to access private variables.
  Map<String, dynamic> get roomData => _roomData;
  int get filledBoxes => _filledBoxes;
  List<String> get displayElements => _displayElement;
  Player get player1 => _player1;
  Player get player2 => _player2;

  // Updates room data and notifies listeners.
  void updateRoomData(Map<String, dynamic> data) {
    _roomData = data;
    notifyListeners();
  }

  // Updates Player 1 data from a map.
  void updatePlayer1(Map<String, dynamic> player1Data) {
    _player1 = Player.fromMap(player1Data);
    notifyListeners();
  }

  // Updates Player 2 data from a map.
  void updatePlayer2(Map<String, dynamic> player2Data) {
    _player2 = Player.fromMap(player2Data);
    notifyListeners();
  }

  // Updates the Tic-Tac-Toe board when a player makes a move.
  void updateDisplayElements(int index, String choice) {
    _displayElement[index] = choice;
    _filledBoxes += 1;
    notifyListeners();
  }

  // Resets the filled boxes count when a new game starts.
  void setFilledBoxTo0() {
    _filledBoxes = 0;
  }
}
