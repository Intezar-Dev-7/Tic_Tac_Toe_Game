import 'package:flutter/material.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/screens/create_room_screen.dart';
import 'package:tic_tac_toe/screens/join_room_screen.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({super.key});

  void createRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/onBoardingImage.png'),
                width: 150,
              ),
              SizedBox(height: 60),

              CustomButton(
                onTap: () => createRoom(context),
                text: 'Create Room',
              ),
              SizedBox(height: 20),
              CustomButton(onTap: () => joinRoom(context), text: 'Join Room'),
            ],
          ),
        ),
      ),
    );
  }
}
