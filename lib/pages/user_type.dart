// ignore_for_file: must_be_immutable

import 'package:arrhythmia/pages/doctor_home_page.dart';
import 'package:arrhythmia/pages/patient_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserType extends StatefulWidget {
  const UserType({
    super.key,
  });

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.data()?["userType"] == "patient") {
            return const PatientHomePage();
          } else {
            return const DoctorHomePage();
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("error"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
