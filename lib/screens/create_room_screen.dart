import 'package:flutter/material.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/custom_text.dart';
import 'package:tic_tac_toe/widgets/custom_textfield.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.createRoomSuccessListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _nameController.dispose();
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
                text: 'Create Room',
                fontSize: 70,
              ),
              SizedBox(height: size.height * 0.08),

              // Custom TextField
              CustomTextField(
                controller: _nameController,
                hintText: 'Enter your username',
                focusNode: _nameFocus,
              ),
              SizedBox(height: size.height * 0.045),
              CustomButton(
                onTap: () => _socketMethods.createRoom(_nameController.text),
                text: 'Create',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
