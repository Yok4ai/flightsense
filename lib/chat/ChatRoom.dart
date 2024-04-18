import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoom extends StatefulWidget {
  final String receiveEmail;

  ChatRoom({required this.receiveEmail});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveEmail)),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildMessageComposer(),
        ],
      ),
    );
  }

 Widget _buildMessages() {
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('chat_rooms')
        .doc(_generateChatRoomId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        final messages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index].data() as Map<String, dynamic>;
            final isCurrentUser = message['senderEmail'] == _auth.currentUser!.email;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'] ?? 'No message',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          message['senderEmail'] ?? 'Unknown sender',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    },
  );
}




  Widget _buildMessageComposer() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Enter your message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      String currentUserId = _auth.currentUser!.uid;
      String currentUserEmail = _auth.currentUser!.email!;
      Timestamp timestamp = Timestamp.now();

      _firestore
          .collection('chat_rooms')
          .doc(_generateChatRoomId())
          .collection('messages')
          .add({
        'senderID': currentUserId,
        'senderEmail': currentUserEmail,
        'receiverEmail': widget.receiveEmail,
        'message': messageText,
        'timestamp': timestamp,
      });
      _messageController.clear();
    }
  }

  String _generateChatRoomId() {
    List<String> ids = [_auth.currentUser!.uid, widget.receiveEmail];
    ids.sort();
    return ids.join('_');
  }
}