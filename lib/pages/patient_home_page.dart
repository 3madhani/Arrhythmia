import 'package:arrhythmia/chatpapp/view/screens/chats_screen.dart';
import 'package:arrhythmia/pages/user_profile.dart';
import 'package:arrhythmia/pages/doctor-profile-page.dart';
import 'package:arrhythmia/pages/patient.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  static String id = "PatientHomePage";

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      const Patient(),
      const MyDoctors(),
      const ChatsScreen(),
      const UserProfile(),
    ];

    final items = <Widget>[
      const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            EvaIcons.home,
            size: 28,
          ),
          Text(
            "Home",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(
            "assets/svg/doctor_white_coat.svg",
            height: 36,
          ),
          const Text(
            "Doctors",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
      const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            EvaIcons.messageCircle,
            size: 30,
          ),
          Text(
            "Chats",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
      const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            EvaIcons.settings2,
            size: 30,
          ),
          Text(
            "Settings",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    ];
    return Container(
      color: Colors.blue,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
            buttonBackgroundColor: Colors.transparent,
            color: const Color(0xffd4d4d4),
            backgroundColor: Colors.transparent,
            index: index,
            items: items,
            height: 75,
            onTap: (index) => setState(() => this.index = index),
          ),
          body: screens[index],
        ),
      ),
    );
  }
}
