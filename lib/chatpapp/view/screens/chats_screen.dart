import 'package:arrhythmia/chatpapp/model/room.dart';
import 'package:arrhythmia/chatpapp/model/user.dart';
import 'package:arrhythmia/chatpapp/view/widgets/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../service/firebase_firestore_service.dart';
import '../../service/notification_service.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with WidgetsBindingObserver {
  final notificationService = NotificationsService();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    notificationService.firebaseNotification(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        }, FirebaseAuth.instance.currentUser!.uid);
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserData(
            {'isOnline': false}, FirebaseAuth.instance.currentUser!.uid);
        break;
      // TODO: Handle this case.
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff95c55),
        elevation: 10,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("rooms")
            .where("members",
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChatRoom> rooms = snapshot.data!.docs
                .map((doc) => ChatRoom.fromJson(doc.data()))
                .toList()
              ..sort(
                (a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),
              );
            print(rooms.length);
            return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: rooms.length,
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(rooms[index]
                            .members!
                            .where((element) =>
                                element !=
                                FirebaseAuth.instance.currentUser!.uid)
                            .first)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel users;
                        users = UserModel.fromJson(snapshot.data!.data()!);
                        return UserItem(user: users);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
