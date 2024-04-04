import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flightsense/database/firestore.dart';
import 'package:flightsense/mypostbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Threads extends StatelessWidget {
  Threads({Key? key});

  final FireStoreDatabase database = FireStoreDatabase();

  final TextEditingController newPostcontroller = TextEditingController();

  void PostMessage() {
    if (newPostcontroller.text.isNotEmpty) {
      String message = newPostcontroller.text;
      database.addpost(message);
    }

    newPostcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Center(child: Text("T H R E A D S")),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Say Something",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: false,
                    controller: newPostcontroller,
                  ),
                ),
                MyPostButton(ontap: PostMessage),
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStreams(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;

              if (posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Posts.. Post Something!"),
                  ),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    bottom: 25,
                  ),
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      String message = post['PostMessage'];
                      String userEmail = post['UserEmail'];
                      Timestamp timeStamp = post['TimeStamp'];

                      // Convert timestamp to DateTime
                      DateTime dateTime = timeStamp.toDate();

                      // Format date
                      String formattedDate = DateFormat.yMMMd()
                          .format(dateTime); // Example: Apr 4, 2024

                      // Format time
                      String formattedTime = DateFormat.jm().format(dateTime);

                      // Format time zone
                      String formattedTimeZone =
                          DateFormat('z').format(dateTime);

                      // Combine time and time zone
                      String formattedDateTime =
                          '$formattedDate $formattedTime $formattedTimeZone';

                      return ListTile(
                        title: Text(message, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userEmail,
                              style: const TextStyle(color: Colors.red),
                            ),
                            Text(
                              formattedDateTime,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 249, 249, 249)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
