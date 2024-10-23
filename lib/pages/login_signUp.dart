// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

import 'dart:io';
import 'dart:math';
import 'package:arrhythmia/chatpapp/service/firebase_firestore_service.dart';
import 'package:arrhythmia/chatpapp/service/notification_service.dart';
import 'package:arrhythmia/chatpapp/view/screens/auth/forgot_password_page.dart';
import 'package:arrhythmia/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:arrhythmia/palette.dart';
import '../components/build_text_form_field.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({super.key});

  static String id = 'LoginPage';

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  bool isSignUpScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  bool isLoading = false;
  String? email, password, userName, gender = "Male", imageUrl;
  Reference? imageStorage;
  File? file;
  var imagePicked;

  GlobalKey<FormState> formKey = GlobalKey();
  static final notifications = NotificationsService();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/20944833.jpg"),
                          fit: BoxFit.fill)),
                  child: Container(
                    padding: const EdgeInsets.only(top: 90, left: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        transform: const GradientRotation(-2),
                        colors: [
                          const Color(0xfff86c66).withOpacity(.85),
                          const Color(0xff56B4BE).withOpacity(.85),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: "Welcome ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                letterSpacing: 2,
                                color: Palette.backgroundColor,
                              ),
                              children: [
                                TextSpan(
                                  text: isSignUpScreen
                                      ? "to Arrhythmia,"
                                      : "Back,",
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: Palette.activeColor,
                                  ),
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          isSignUpScreen
                              ? "Signup to Continue"
                              : "Signin to Continue",
                          style: const TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Trick to add the shadow for the submit button
              buildBottomHalfContainer(true),
              //Main Container for Login and Signup
              AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                top: isSignUpScreen ? 200 : 230,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.bounceInOut,
                  height: isSignUpScreen ? 400 : 250,
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5),
                      ]),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  formKey.currentState!.reset();
                                  isSignUpScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignUpScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1),
                                  ),
                                  if (!isSignUpScreen)
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  formKey.currentState!.reset();
                                  isSignUpScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "SIGNUP",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSignUpScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1),
                                  ),
                                  if (isSignUpScreen)
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                        if (isSignUpScreen) buildSignUpSection(),
                        if (!isSignUpScreen) buildSignInSection(),
                      ],
                    ),
                  ),
                ),
              ),
              // Trick to add the submit button
              buildBottomHalfContainer(false),
              // Bottom buttons
              Positioned(
                top: MediaQuery.of(context).size.height - 100,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(
                      isSignUpScreen ? "Or SignUp with" : "Or SignIn with",
                      style: const TextStyle(
                        color: Palette.activeColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(right: 20, left: 20, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildTextButton(
                              // signInWithGoogle,
                              EvaIcons.facebookOutline,
                              "Facebook",
                              Palette.facebookColor),
                          buildTextButton(

                              // signInWithFacebook,
                              EvaIcons.googleOutline,
                              "Google",
                              Palette.googleColor),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildSignInSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          BuildTextFormField(
            isHidden: false,
            icon: EvaIcons.emailOutline,
            hintText: "info@demouri.com",
            isPassword: false,
            isEmail: true,
            onChange: (data) {
              email = data;
            },
          ),
          BuildTextFormField(
            isHidden: true,
            icon: EvaIcons.lockOutline,
            hintText: "**********",
            isPassword: true,
            isEmail: false,
            onChange: (data) {
              password = data;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  const Text("Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text("Forgot Password?",
                    style: TextStyle(
                        fontSize: 12,
                        color: Palette.textColor1,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  Container buildSignUpSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          BuildTextFormField(
            isHidden: false,
            icon: EvaIcons.personOutline,
            hintText: "User Name",
            isPassword: false,
            isEmail: false,
            onChange: (data) {
              userName = data;
            },
          ),
          BuildTextFormField(
            isHidden: false,
            icon: EvaIcons.emailOutline,
            hintText: "email",
            isPassword: false,
            isEmail: true,
            onChange: (data) {
              email = data;
            },
          ),
          BuildTextFormField(
            isHidden: true,
            icon: EvaIcons.lockOutline,
            hintText: "password",
            isPassword: true,
            isEmail: false,
            onChange: (data) {
              password = data;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                      gender = "Male";
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Palette.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Colors.transparent
                                    : Palette.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          Icons.male_outlined,
                          color: isMale ? Colors.white : Palette.iconColor,
                        ),
                      ),
                      const Text(
                        "Male",
                        style: TextStyle(
                          color: Palette.textColor1,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                      gender = "Female";
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              isMale ? Colors.transparent : Palette.textColor2,
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Palette.textColor1
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.female_outlined,
                          color: isMale ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      const Text(
                        "Female",
                        style: TextStyle(
                          color: Palette.textColor1,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showBottomSheet();
                  },
                  child: const Row(
                    children: [
                      Icon(EvaIcons.imageOutline),
                      Text(
                        "Add Image",
                        style: TextStyle(
                          color: Palette.activeColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  text: "By pressing 'Submit' you agree to our ",
                  style: TextStyle(color: Palette.textColor2),
                  children: [
                    TextSpan(
                      text: "term & conditions",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ]),
            ),
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  TextButton buildTextButton(
      // Function function,
      IconData icon,
      String title,
      Color backgroundColor) {
    return TextButton(
      onPressed: () async {
        // await function();
      },
      style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(width: 1, color: Colors.grey),
          minimumSize: const Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignUpScreen ? 552.5 : 422.5,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? InkWell(
                  onTap: () async {
                    if (isSignUpScreen) {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await imageStorage?.putFile(
                            File(
                              imagePicked.path,
                            ),
                          );
                          imageUrl = await imageStorage?.getDownloadURL();
                          await registerUser(
                              email: email!,
                              password: password!,
                              displayName: userName!,
                              gender: gender!,
                              image: imageUrl);

                          await FirebaseFirestore.instance
                              .collection('detection')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            "imageUrl": null,
                            "detection": null,
                          });
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomePage.id,
                            (route) => false,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            AwesomeDialog(
                              context: context,
                              title: 'Error',
                              body: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'The password provided is too weak',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.activeColor,
                                  ),
                                ),
                              ),
                            ).show();
                          } else if (e.code == 'email-already-in-use') {
                            AwesomeDialog(
                              context: context,
                              title: 'Error',
                              body: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'The account already exists for that email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.activeColor,
                                  ),
                                ),
                              ),
                            ).show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              title: 'Error',
                              body: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.code.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.activeColor,
                                  ),
                                ),
                              ),
                            ).show();
                          }
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            title: 'Error',
                            body: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'there was an error',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Palette.activeColor,
                                ),
                              ),
                            ),
                          ).show();
                        }
                        isLoading = false;
                        setState(() {});
                      }
                    } else {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await loginUser();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomePage.id,
                            (route) => false,
                            arguments: FirebaseAuth.instance.currentUser!.uid,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            AwesomeDialog(
                              context: context,
                              title: 'Error',
                              body: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Email or Password is wrong',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.activeColor,
                                  ),
                                ),
                              ),
                            ).show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              title: 'Error',
                              body: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.activeColor,
                                  ),
                                ),
                              ),
                            ).show();
                          }
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            title: 'Error',
                            body: const Text('there was an error'),
                          ).show();
                        }
                        isLoading = false;
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1))
                        ]),
                    child: const Icon(
                      EvaIcons.arrowIosForward,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Center(),
        ),
      ),
    );
  }

  Future<void> registerUser(
      {required String email,
      required String password,
      required String displayName,
      required String gender,
      required String? image}) async {
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestoreService.createUser(
        gender: gender,
        image: image,
        email: user.user!.email!,
        uid: user.user!.uid,
        name: displayName,
        userType: "patient",
      );
      
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      await FirebaseFirestoreService.updateUserData(
          {'lastActive': DateTime.now()},
          FirebaseAuth.instance.currentUser!.uid);

      await notifications.requestPermission();
      await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  showBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: Palette.backgroundColor.withOpacity(.80),
      context: context,
      builder: (context) {
        return Container(
          height: 180,
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please Choose Image",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () async {
                  imagePicked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (imagePicked != null) {
                    String imageName = imagePicked.name;
                    int random = Random().nextInt(10000000);
                    imageStorage = FirebaseStorage.instance
                        .ref("profileImages")
                        .child("$random$imageName");
                  }
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      EvaIcons.imageOutline,
                      size: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "From Gallery",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  imagePicked =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (imagePicked != null) {
                    String imageName = imagePicked.name;
                    var random = Random().nextInt(10000000);
                    imageStorage = FirebaseStorage.instance
                        .ref("profileImages")
                        .child("$random$imageName");
                  }
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      EvaIcons.cameraOutline,
                      size: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "From Camera",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
