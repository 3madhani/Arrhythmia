import 'package:arrhythmia/chatGpt/providers/chats_provider.dart';
import 'package:arrhythmia/chatGpt/providers/models_provider.dart';
import 'package:arrhythmia/chatpapp/provider/firebase_provider.dart';
import 'package:arrhythmia/pages/doctor_home_page.dart';
import 'package:arrhythmia/pages/home_page.dart';
import 'package:arrhythmia/pages/patient.dart';
import 'package:arrhythmia/pages/patient_home_page.dart';
import 'package:arrhythmia/pages/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_signUp.dart';
import 'pages/startup_page.dart';
import 'payment/core/utils/api_keys.dart';

bool? isLogin;
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  Stripe.publishableKey = ApiKeys.publishableKey;
  runApp(const Arrhythmia());
}

class Arrhythmia extends StatelessWidget {
  const Arrhythmia({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => FirebaseProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ModelsProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ChatProvider(),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Poppins',
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            StartupPage.id: (context) => const StartupPage(),
            LoginSignUpScreen.id: (context) => const LoginSignUpScreen(),
            PatientHomePage.id: (context) => const PatientHomePage(),
            DoctorHomePage.id: (context) => const DoctorHomePage(),
            HomePage.id: (context) => const HomePage(),
            Patient.id: (context) => const Patient(),
          },
          home: isLogin == false ? const SplashScreen() : const HomePage(),
        ));
  }
}
