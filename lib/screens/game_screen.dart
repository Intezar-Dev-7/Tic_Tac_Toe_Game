import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';

import 'package:tic_tac_toe/utils/colors.dart';
import 'package:tic_tac_toe/widgets/scoreboard.dart';
import 'package:tic_tac_toe/widgets/tictactoe_board.dart';
import 'package:tic_tac_toe/widgets/waiting_lobby.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    _socketMethods.updateRoomListener(context);
    _socketMethods.updatePlayersStateListener(context);
    _socketMethods.pointIncreaseListener(context);
    _socketMethods.endGameListener(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      body:
          (roomDataProvider.roomData['isJoin'] ?? false)
              ? const WaitingLobby()
              : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Scoreboard(),
                    const TicTacToeBoard(),
                    Text(
                      '${roomDataProvider.roomData['turn']['username']}\'s turn',
                    ),
                    //
                  ],
                ),
              ),
    );
  }
}
