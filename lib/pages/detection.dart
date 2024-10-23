import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:arrhythmia/constant_model.dart';
import 'package:arrhythmia/custom_outline_model.dart';
import 'package:arrhythmia/pages/doctor-profile-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPage();
}

class _DetectionPage extends State<DetectionPage> {
  String? result;
  final picker = ImagePicker();
  File? img;
  var url = "http://10.0.2.2:5000/api";
  String? body = "";
  String? imageUrl;
  Future? _delayedFuture;
  Reference? imageStorage;
  Future pickImage() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        img = File(pickedFile.path);
        String imageName = pickedFile.name;
        imageStorage = FirebaseStorage.instance
            .ref("DetectionImages")
            .child("${FirebaseAuth.instance.currentUser!.uid}$imageName");
      } else {
        return;
      }
    });
  }

  Future<void> updateUserData(Map<String, dynamic> data) async =>
      await FirebaseFirestore.instance
          .collection('detection')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  Future predict() async {
    if (img == null) return "";

    String base64 = base64Encode(img!.readAsBytesSync());

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response =
        await http.put(Uri.parse(url), body: base64, headers: requestHeaders);

    if (!mounted) {
      return; // Check if the widget is still mounted before calling setState
    }
    setState(() {
      body = response.body;
    });

    // Save the delayed future
    _delayedFuture = Future.delayed(const Duration(seconds: 6), () {
      if (!mounted) {
        return; // Check if the widget is still mounted before calling setState
      }
      setState(() {
        body = '';
      });
    });
  }

  @override
  void dispose() {
    // Cancel the delayed future if it's still pending
    if (_delayedFuture != null) {
      _delayedFuture!.timeout(Duration.zero, onTimeout: () {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.kBlackColor,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil(
              (route) => route.isFirst,
            );
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFF95C55),
        centerTitle: true,
        title: const Text(
          'Arrhythmia Detection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(children: [
          Positioned(
            top: screenHeight * 0.1,
            left: -88,
            child: Container(
              height: 166,
              width: 166,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFF95C55)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            right: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                CustomOutline(
                  strokeWidth: 4,
                  radius: screenWidth * 0.8,
                  padding: const EdgeInsets.all(4),
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Constants.kPinkColor,
                        Constants.kPinkColor.withOpacity(0),
                        Constants.kGreenColor.withOpacity(0.1),
                        Constants.kGreenColor
                      ],
                      stops: const [
                        0.2,
                        0.4,
                        0.6,
                        1
                      ]),
                  child: Center(
                    child: img == null
                        ? Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset(
                              frameRate: const FrameRate(220),
                              "assets/lottie/Animation - 1717683725565.json",
                            ))
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomLeft,
                                image: FileImage(img!),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Center(
                    child: img == null
                        ? Text(
                            'THE MODEL HAS NOT BEEN PREDICTED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(
                                0.85,
                              ),
                              fontSize: screenHeight <= 667 ? 18 : 34,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            '$body',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(
                                0.85,
                              ),
                              fontSize: screenHeight <= 667 ? 18 : 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                // SizedBox(
                //   height: screenHeight * 0.03,
                // ),
                body == "Non-ecotic beats (normal beat)" || body == ""
                    ? SizedBox(
                        height: screenHeight * 0.05,
                      )
                    : IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MyDoctors(),
                            ),
                          );
                        },
                        icon: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Check Doctor",
                              style: TextStyle(
                                color: Color(0xfff95c55),
                                fontSize: 20,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right_rounded,
                              size: 50,
                              color: Color(0xfff95c55),
                            ),
                          ],
                        ),
                      ),
                CustomOutline(
                  strokeWidth: 3,
                  radius: 20,
                  padding: const EdgeInsets.all(3),
                  width: 190,
                  height: 50,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Constants.kPinkColor, Constants.kGreenColor],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Constants.kPinkColor.withOpacity(0.5),
                          Constants.kGreenColor.withOpacity(0.5)
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.white12,
                        ),
                      ),
                      onPressed: () {
                        pickImage();
                      },
                      child: const Text('Pick Image Here',
                          style: TextStyle(
                            fontSize: 16,
                            color: Constants.kWhiteColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomOutline(
                  strokeWidth: 3,
                  radius: 20,
                  padding: const EdgeInsets.all(3),
                  width: 190,
                  height: 50,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Constants.kPinkColor, Constants.kGreenColor],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Constants.kPinkColor.withOpacity(0.5),
                          Constants.kGreenColor.withOpacity(0.5)
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.white12,
                        ),
                      ),
                      onPressed: () async {
                        predict();
                        if (img == null || body == null) {
                          return;
                        }
                        await imageStorage?.putFile(
                          File(
                            PickedFile(img!.path).path,
                          ),
                        );
                        imageUrl = await imageStorage?.getDownloadURL();
                        updateUserData({
                          "imageUrl": imageUrl,
                          "detection": "$body",
                        });
                      },
                      child: const Text('predict Image',
                          style: TextStyle(
                            fontSize: 16,
                            color: Constants.kWhiteColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
