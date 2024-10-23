import 'package:arrhythmia/chatpapp/view/screens/chats_screen.dart';
import 'package:arrhythmia/pages/user_profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  static String id = "DoctorHomePage";

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ChatsScreen(),
      const UserProfile(),
    ];

    final items = <Widget>[
      const Icon(
        EvaIcons.messageCircle,
        size: 30,
      ),
      const Icon(
        EvaIcons.settings2,
        size: 30,
      ),
    ];
    return Container(
      color: Colors.blue,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: const Color(0xff448aff),
          bottomNavigationBar: CurvedNavigationBar(
            buttonBackgroundColor: Colors.transparent,
            color: const Color(0xffd4d4d4),
            backgroundColor: Colors.transparent,
            index: index,
            items: items,
            height: 70,
            onTap: (index) => setState(() => this.index =
                index),
          ),
          body: screens[index],
        ),
      ),
    );
  }
}
