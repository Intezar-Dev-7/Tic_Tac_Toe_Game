import 'package:flutter/material.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/custom_text.dart';
import 'package:tic_tac_toe/widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _gameIdFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _gameIdFocus.dispose();
    _nameController.dispose();
    _gameIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                shadows: [Shadow(blurRadius: 40, color: Colors.blue)],
                text: 'Join Room',
                fontSize: 70,
              ),
              SizedBox(height: size.height * 0.08),

              // Custom TextField
              CustomTextfield(
                controller: _nameController,
                text: 'Enter your username',
                focusNode: _nameFocus,
              ),
              SizedBox(height: 20),
              CustomTextfield(
                controller: _gameIdController,
                text: 'Enter Game Id',
                focusNode: _gameIdFocus,
              ),
              SizedBox(height: size.height * 0.08),
              CustomButton(onTap: () {}, text: 'Join'),
            ],
          ),
        ),
      ),
    );
  }
}
