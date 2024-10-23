import 'package:arrhythmia/chatpapp/service/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../model/user.dart';
import '../screens/chat_screen.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  void initState() {
    FirebaseFirestoreService.createRoom(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: () {
              FirebaseFirestoreService.createRoom(widget.user.uid);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChatScreen(userId: widget.user.uid)));
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    (widget.user.image == null)
                        ? CircleAvatar(
                            radius: 30,
                            child: Text(widget.user.name[0]),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(widget.user.image!),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        backgroundColor:
                            widget.user.isOnline ? Colors.green : Colors.grey,
                        radius: 5,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Last Active : ${timeago.format(widget.user.lastActive)}',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // trailing: Badge(
                //   label: Text(
                //     widget.user.isOnline ? 'Online' : 'Offline',
                //     style: const TextStyle(
                //       color: Colors.blue,
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
              ),
            ),
          ),
          const Divider(
            color: Colors.blueAccent,
            thickness: 1,
            indent: 80,
          ),
        ],
      );
}
