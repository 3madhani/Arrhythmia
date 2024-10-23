// ignore_for_file: must_be_immutable
import 'package:arrhythmia/chatGpt/screens/chat_screen.dart';
import 'package:arrhythmia/pages/breathing_exercise.dart';
import 'package:arrhythmia/payment/Features/checkout/presentation/my_cart_views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class Patient extends StatefulWidget {
  const Patient({super.key});

  static String id = "patient";

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              snapshot.data!.data()!["image"] == null
                                  ? CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.blue,
                                      child: CircleAvatar(
                                        radius: 43,
                                        child: Text(
                                          "${snapshot.data!.data()!["name"][0]}",
                                          style: const TextStyle(
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Aclonica",
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.blue,
                                      child: CircleAvatar(
                                        maxRadius: 43,
                                        backgroundImage: (NetworkImage(
                                            "${snapshot.data!.data()!["image"]}")),
                                      ),
                                    ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextAnimator(
                                    "Welcome",
                                    atRestEffect: WidgetRestingEffects.size(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff95c55),
                                      fontFamily: "Aclonica",
                                    ),
                                  ),
                                  Text(
                                    maxLines: 2,
                                    "${snapshot.data!.data()!["name"]}",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ]);
                      } else {
                        return const Text(
                          "loading",
                        );
                      }
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                height: 330,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  borderOnForeground: false,
                  shadowColor: Colors.blue,
                  elevation: 10,
                  color: Colors.blueGrey,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("detection")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            snapshot.data?.data()?["imageUrl"] == null
                                ? Lottie.asset(
                                    frameRate: const FrameRate(220),
                                    // height: 200,
                                    "assets/lottie/Animation - 1717683660636.json",
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      width: 350,
                                      "${snapshot.data!.data()!["imageUrl"]}",
                                    ),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            snapshot.data?.data()?["detection"] == null
                                ? const SizedBox(
                                    height: 50,
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        "Result Of Detection",
                                        style: TextStyle(
                                            color: Color(0xffff4e4c),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Aclonica")),
                                  )
                                : SizedBox(
                                    height: 50,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      "${snapshot.data!.data()!["detection"]}",
                                      style: const TextStyle(
                                        color: Color(0xffff4e4c),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: PushableButton(
                  height: 60,
                  elevation: 8,
                  hslColor: const HSLColor.fromAHSL(1.0, .93, 1.0, 0.65),
                  shadow: BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MyCartView(),
                    ),
                  ),
                  child: TextAnimator(
                    "Arrhythmia Detection",
                    atRestEffect: WidgetRestingEffects.pulse(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: PushableButton(
                  height: 60,
                  elevation: 8,
                  hslColor: const HSLColor.fromAHSL(1.0, .93, 1.0, 0.65),
                  shadow: BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BreathingExercise(),
                    ),
                  ),
                  child: TextAnimator(
                    "Breathing Exercise",
                    atRestEffect: WidgetRestingEffects.size(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: PushableButton(
                  height: 60,
                  elevation: 8,
                  hslColor: const HSLColor.fromAHSL(1.0, .93, 1.0, 0.65),
                  shadow: BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChatScreen(),
                    ),
                  ),
                  child: TextAnimator(
                    "Chat GPT",
                    atRestEffect: WidgetRestingEffects.rotate(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigateButton extends StatelessWidget {
  const NavigateButton({
    super.key,
    required this.hight,
    required this.width,
    required this.data,
    required this.color,
  });
  final double hight, width;
  final String data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hight,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(26),
        ),
      ),
      child: Center(
        child: Text(
          data,
          style: const TextStyle(
            letterSpacing: 2,
            fontFamily: 'Aclonica',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
