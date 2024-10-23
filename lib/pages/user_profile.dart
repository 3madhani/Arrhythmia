import 'package:arrhythmia/components/user_profile_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return UserProfileComponent(
            name: snapshot.data!.data()!["name"],
            imageUrl: snapshot.data!.data()!["image"],
            userType: snapshot.data!.data()!["userType"],
            gender: snapshot.data!.data()!["gender"],
            email: snapshot.data!.data()!["email"],
            biography: snapshot.data!.data()?["bio"],
            rating: snapshot.data!.data()?["rating"],
            specialty: snapshot.data!.data()?["specialty"],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else {
          return const Center(
            child: Text("Loading"),
          );
        }
      },
    );
  }
}
