// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'dart:math';
import 'package:arrhythmia/chatpapp/service/firebase_firestore_service.dart';
import 'package:arrhythmia/pages/startup_page.dart';
import 'package:arrhythmia/palette.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileComponent extends StatefulWidget {
  UserProfileComponent({
    super.key,
    this.imageUrl,
    this.name,
    this.email,
    this.gender,
    this.userType,
    this.specialty,
    this.biography,
    this.rating,
  });
  var imageUrl, name, email, gender, userType, biography, rating;
  String? specialty;

  @override
  State<UserProfileComponent> createState() => _UserProfileComponentState();
}

class _UserProfileComponentState extends State<UserProfileComponent> {
  TextEditingController? nameCo = TextEditingController();
  TextEditingController? bioCo = TextEditingController();
  TextEditingController imageCo = TextEditingController();
  TextEditingController? specialtyCo = TextEditingController();
  bool nameEdit = false;
  bool bioEdit = false;
  bool specialtyEdit = false;
  var imagePicked, imageUrl, image;
  Reference? imageStorage;

  @override
  Widget build(BuildContext context) {
    nameCo?.text = widget.name;
    bioCo?.text = widget.biography.toString();
    specialtyCo?.text = widget.specialty.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff95c55),
        elevation: 5,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  imagePicked == null
                      ? (widget.imageUrl == null)
                          ? const CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                maxRadius: 73,
                                child: Icon(
                                  Icons.person,
                                  size: 90,
                                  color: Color(0xff1c1c1c),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                maxRadius: 73,
                                backgroundImage:
                                    (NetworkImage(widget.imageUrl)),
                              ),
                            )
                      : CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            maxRadius: 73,
                            backgroundImage: (NetworkImage(widget.imageUrl)),
                          ),
                        ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: IconButton.filled(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        showBottomSheet();
                      },
                      icon: const Icon(EvaIcons.edit2Outline),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: 370,
                        child: TextField(
                          style: nameEdit == false
                              ? const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: "Aclonica",
                                )
                              : const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Aclonica",
                                ),
                          textAlign: TextAlign.center,
                          controller: nameCo,
                          enabled: nameEdit,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 310,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () {
                            if (nameEdit == false) {
                              setState(() {
                                nameEdit = true;
                              });
                            } else {
                              setState(() {
                                FirebaseFirestoreService.updateUserData({
                                  'name': nameCo?.text,
                                }, FirebaseAuth.instance.currentUser!.uid);
                              });

                              nameEdit = false;
                            }
                          },
                          icon: nameEdit == true
                              ? const Icon(EvaIcons.save)
                              : const Icon(EvaIcons.edit2Outline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              widget.userType == "patient"
                  ? Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: const Icon(EvaIcons.emailOutline),
                            title: const Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.email}",
                              style: const TextStyle(),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(EvaIcons.personOutline),
                            title: const Text(
                              "User Type",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.userType}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: widget.gender == "Male"
                                ? const Icon(Icons.male_outlined)
                                : const Icon(Icons.female_outlined),
                            title: const Text(
                              "Gender",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.gender}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: const Icon(
                              size: 35,
                              EvaIcons.emailOutline,
                            ),
                            title: const Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.email}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(
                              size: 35,
                              EvaIcons.personOutline,
                            ),
                            title: const Text(
                              "User Type",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.userType}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontFamily: "Aclonica",
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                if (specialtyEdit == false) {
                                  setState(() {
                                    specialtyEdit = true;
                                  });
                                } else {
                                  setState(() {
                                    FirebaseFirestoreService.updateUserData({
                                      'specialty': specialtyCo?.text,
                                    }, FirebaseAuth.instance.currentUser!.uid);
                                    specialtyEdit = false;
                                  });
                                }
                              },
                              icon: specialtyEdit == true
                                  ? const Icon(EvaIcons.save)
                                  : const Icon(EvaIcons.edit2Outline),
                            ),
                            leading: Image.asset(
                              "assets/images/nephrologist.png",
                              width: 35,
                            ),
                            title: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: specialtyEdit == true
                                    ? Colors.black
                                    : Colors.blue,
                                fontFamily: "Aclonica",
                              ),
                              controller: specialtyCo,
                              enabled: specialtyEdit,
                              decoration: const InputDecoration(
                                labelText: "Specialty",
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                if (bioEdit == false) {
                                  setState(() {
                                    bioEdit = true;
                                  });
                                } else {
                                  setState(() {
                                    FirebaseFirestoreService.updateUserData({
                                      'bio': bioCo?.text,
                                    }, FirebaseAuth.instance.currentUser!.uid);
                                    bioEdit = false;
                                  });
                                }
                              },
                              icon: bioEdit == true
                                  ? const Icon(EvaIcons.save)
                                  : const Icon(EvaIcons.edit2Outline),
                            ),
                            leading: Image.asset(
                              "assets/images/curriculum-vitae (1).png",
                              width: 35,
                            ),
                            title: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bioEdit == true
                                    ? Colors.black
                                    : Colors.blue,
                                fontFamily: "Aclonica",
                              ),
                              controller: bioCo,
                              enabled: bioEdit,
                              decoration: const InputDecoration(
                                labelText: "Biography",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              "assets/images/star.png",
                              width: 35,
                            ),
                            title: const Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.rating}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                                fontFamily: "Aclonica",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(300, 55)),
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, StartupPage.id);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Log out',
                      style: TextStyle(
                        fontFamily: "Aclonica",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      EvaIcons.logOutOutline,
                      color: Colors.black,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                    Navigator.pop(context);
                    await imageStorage!.putFile(
                      File(
                        imagePicked.path,
                      ),
                    );
                    imageUrl = await imageStorage?.getDownloadURL();
                    FirebaseFirestoreService.updateUserData({
                      "image": imageUrl,
                    }, FirebaseAuth.instance.currentUser!.uid);
                  }
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
                        .ref("Images")
                        .child("$random$imageName");
                    Navigator.pop(context);
                    await imageStorage?.putFile(
                      File(
                        imagePicked.path,
                      ),
                    );
                    imageUrl = await imageStorage?.getDownloadURL();
                    FirebaseFirestoreService.updateUserData({
                      "image": imageUrl,
                    }, FirebaseAuth.instance.currentUser!.uid);
                  }
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

cardWidget(
    {required Widget widget, required String infoType, required String info}) {
  return Card(
    child: ListTile(
      leading: widget,
      title: Text(
        infoType,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        info,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontFamily: "Aclonica",
        ),
      ),
    ),
  );
}
