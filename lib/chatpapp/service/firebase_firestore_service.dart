import 'dart:async';
import 'dart:typed_data';
import 'package:arrhythmia/chatpapp/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/message.dart';
import '../model/user.dart';
import 'firebase_storage_service.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;
  static final String myUid = FirebaseAuth.instance.currentUser!.uid;

  static Future<void> createUser({
    required String name,
    required String? image,
    required String email,
    required String uid,
    required String gender,
    required String userType,
  }) async {
    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
      image: image,
      gender: gender,
      userType: userType,
      isOnline: true,
      lastActive: DateTime.now(),
    );

    await firestore.collection('users').doc(uid).set(user.toJson());
  }

  static Future<void> createRoom(
    String userId,
  ) async {
    // final userEmail =
    // await firestore.collection("users").where("uid", isEqualTo: uid).get();

    // String userId = userEmail.docs.first.id;

    List<String> members = [myUid, userId]..sort(
        (a, b) => a.compareTo(b),
      );

    QuerySnapshot roomExists = await firestore
        .collection("rooms")
        .where("members", isEqualTo: members)
        .get();

    if (roomExists.docs.isEmpty) {
      ChatRoom chatRoom = ChatRoom(
        id: "",
        createdAt: DateTime.now().toString(),
        lastMessage: "",
        lastMessageTime: DateTime.now().toString(),
        members: members,
      );

      await firestore
          .collection("rooms")
          .doc(members.toString())
          .set(chatRoom.toJson());
    }
  }

  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> _addMessageToChat(
    String receiverId,
    Message message,
  ) async {
    await firestore
        .collection('rooms')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await firestore
        .collection('rooms')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  static Future<void> updateUserData(
          Map<String, dynamic> data, String uid) async =>
      await firestore.collection('users').doc(uid).update(data);

  static Future<List<UserModel>> searchUser(String name) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: name)
          .where('userType', isEqualTo: 'doctor')
          .get();

      print(snapshot.docs.length);
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching user: $e');
      return [];
    }
  }
}
