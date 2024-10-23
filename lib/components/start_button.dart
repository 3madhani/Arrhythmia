import 'package:arrhythmia/pages/login_signUp.dart';
import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
  });

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              if (isTapped == false) {
                isTapped = true;
              } else {
                isTapped = false;
              }
              Navigator.pushNamed(context, LoginSignUpScreen.id);
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Start',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: isTapped ? const Color(0xff56B4BE) : Colors.white,
              ),
            ),
            Icon(
              Icons.arrow_right,
              color: isTapped ? const Color(0xff56B4BE) : Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
