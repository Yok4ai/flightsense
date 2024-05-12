import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class GroupChatPage extends StatefulWidget {
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _currentUserEmail = '';
  List<String> _countries = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
    _fetchCountries();
  }

  void _getCurrentUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email!;
      });
    }
  }

  void _fetchCountries() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('group_chats').get();
    final countries = querySnapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      _countries = countries;
    });
  }

  void _addCountry(String countryName) async {
    // Add the country to Firestore
    await FirebaseFirestore.instance
        .collection('group_chats')
        .doc(countryName)
        .set({});

    // Update the local list of countries
    setState(() {
      _countries.add(countryName);
    });

    Navigator.pop(context); // Close the dialog
  }

  void _joinGroupChat(String countryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountryChatPage(
              countryName: countryName, currentUserEmail: _currentUserEmail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Country'),
                    content: TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(labelText: 'Country Name'),
                      onChanged: (value) {
                        // Handle text field changes
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          String countryName = _textFieldController.text.trim();
                          if (countryName.isNotEmpty) {
                            _addCountry(countryName);
                          }
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final countryName = _countries[index];

          return ListTile(
            title: Text(countryName),
            onTap: () {
              _joinGroupChat(countryName);
            },
          );
        },
      ),
    );
  }
}

class CountryChatPage extends StatefulWidget {
  final String countryName;
  final String currentUserEmail;

  CountryChatPage({required this.countryName, required this.currentUserEmail});

  @override
  _CountryChatPageState createState() => _CountryChatPageState();
}

class _CountryChatPageState extends State<CountryChatPage> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final currentTime = Timestamp.now();

    FirebaseFirestore.instance
        .collection('group_chats')
        .doc(widget.countryName)
        .collection('messages')
        .add({
      'senderEmail': widget.currentUserEmail,
      'message': message,
      'timestamp': currentTime,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('group_chats')
                  .doc(widget.countryName)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final senderEmail = message['senderEmail'];
                    final messageText = message['message'];
                    final timestamp = message['timestamp'] as Timestamp;
                    final messageTime =
                        timestamp.toDate(); // Convert timestamp to DateTime

                    final isCurrentUser =
                        senderEmail == widget.currentUserEmail;

                    return Column(
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCurrentUser ? Colors.green : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messageText,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${DateFormat('yyyy-MM-dd hh:mm a').format(messageTime)}', // Format timestamp
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            senderEmail,
                            style: TextStyle(color: Colors.grey),
                            textAlign: isCurrentUser
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
