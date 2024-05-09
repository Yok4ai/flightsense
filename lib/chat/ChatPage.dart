import 'package:firebase_auth/firebase_auth.dart';
import 'package:flightsense/chat/ChatRoom.dart';
import 'package:flightsense/chat/Messages.dart';
import 'package:flightsense/chat/UserTile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importing ChatRoom widget

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User List')),
      ),
      body: _buildBody(context),
    );
  }

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        final documents = snapshot.data?.docs ?? [];
        final currentUserEmail = _auth.currentUser!.email;
        
        // Filter out the current user's email
        final otherUsers = documents.where((doc) => doc['email'] != currentUserEmail).toList();

        return ListView(
          children: otherUsers.map((doc) {
            return UserTile(
              text: doc['email'],
              onTap: () {
                // Navigate to the chat room for the selected user
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatRoom(receiveEmail: doc['email']),
                  ),
                );
              },
            );
          }).toList(),
        );
      }
    },
  );
}


  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserId, receiverID];
    ids.sort(); // Sort the IDs alphabetically
    String chatRoomID = ids.join('_'); // Generate the chatroom ID

    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMAp());
  }
}
