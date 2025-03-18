import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/game_methods.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/utils/utils.dart';

class SocketMethods {
  // Getting the singleton instance of the socket client
  final _socketClient = SocketClient.instance.socket!;

  // Getter to expose the socket instance
  Socket get socketClient => _socketClient;

  // ------------------ SOCKET EMITS (Sending Data to Server) ------------------

  // Emit an event to create a new game room
  void createRoom(String username) {
    if (username.isNotEmpty) {
      _socketClient.emit('createRoom', {'username': username});
      print(username);
    }
  }

  // Emit an event to join an existing game room
  void joinRoom(String username, String roomId) {
    if (username.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit('joinRoom', {'username': username, 'roomId': roomId});
    }
  }

  // Emit an event when a player taps on a grid cell
  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {'index': index, 'roomId': roomId});
    }
  }

  // ------------------ SOCKET LISTENERS (Receiving Data from Server) ------------------

  // Listen for a successful room creation and navigate to the game screen
  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(
        context,
        listen: false,
      ).updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  // Listen for a successful room join and navigate to the game screen
  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(
        context,
        listen: false,
      ).updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  // Listen for error messages and display them as a snackbar
  void errorOccurredListener(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  // Listen for updates to the player states (e.g., when a new player joins)
  void updatePlayersStateListener(BuildContext context) {
    _socketClient.on('updatePlayers', (playerData) {
      Provider.of<RoomDataProvider>(
        context,
        listen: false,
      ).updatePlayer1(playerData[0]);
      Provider.of<RoomDataProvider>(
        context,
        listen: false,
      ).updatePlayer2(playerData[1]);
    });
  }

  // Listen for updates to the room state (e.g., game progress)
  void updateRoomListener(BuildContext context) {
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(
        context,
        listen: false,
      ).updateRoomData(data);
    });
  }

  // Listen for a grid tap event and update the board accordingly
  void tappedListener(BuildContext context) {
    _socketClient.on('tapped', (data) {
      RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(
        context,
        listen: false,
      );
      roomDataProvider.updateDisplayElements(data['index'], data['choice']);
      roomDataProvider.updateRoomData(data['room']);
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  // Listen for point increases when a player wins a round
  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointIncrease', (playerData) {
      var roomDataProvider = Provider.of<RoomDataProvider>(
        context,
        listen: false,
      );
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  // Listen for the end of the game and display a winner dialog
  void endGameListener(BuildContext context) {
    _socketClient.on("endGame", (playerData) {
      showGameDialog(context, '${playerData['username']} won the game!!');
      Navigator.popUntil(context, (route) => false);
    });
  }
}
