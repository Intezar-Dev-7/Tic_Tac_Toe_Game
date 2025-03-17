import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  void createRoom(String username) {
    if (username.isNotEmpty) {
      _socketClient.emit('createRoom', {'username': username});
      print(username);
    }
  }

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(
        context,
        listen: false,
      ).updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }
}
