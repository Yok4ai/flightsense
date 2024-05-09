import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'sidebar.dart'; // Import the Sidebar class

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late Stream<QuerySnapshot> _imageStream; // Stream for listening to Firestore changes
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late String _userEmail; // Store the current user's email
  TextEditingController _captionController = TextEditingController(); // Controller for caption text field

  @override
  void initState() {
    super.initState();
    _imageStream = FirebaseFirestore.instance.collection('images').snapshots();
    _getUserEmail(); // Call function to get the current user's email
  }

  // Function to get the current user's email
  Future<void> _getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userEmail = user!.email!;
    });
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _postImage() async {
    if (_imageFile == null) return;

    try {
      final FirebaseStorage _storage = FirebaseStorage.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.${_imageFile!.path.split('.').last}';
      final Reference ref = _storage.ref().child('images/$fileName');

      final UploadTask uploadTask = ref.putFile(_imageFile!);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser; // Get current user
      final String userEmail = user!.email!; // Get current user's email

      final imageData = {
        'imageUrl': url,
        'userEmail': userEmail, // Add user's email to the data
        'caption': _captionController.text, // Add user's caption to the data
        'timestamp': DateTime.now(),
      };

      await _firestore.collection('images').add(imageData);

      setState(() {
        _imageFile = null;
        _captionController.clear(); // Clear caption text field after posting
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully!'),
        ),
      );
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: ${error.message}'),
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(

    appBar: AppBar(
      title: Text('User Feed'),
    ),
    drawer: Sidebar(),
    body: Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _imageStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final images = snapshot.data?.docs ?? [];

              return ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imageUrl = images[index].get('imageUrl');
                  final caption = images[index].get('caption');
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userEmail, // Use the stored user's email
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5), // Add some vertical space between the email and the date
                              Text(
                                'Posted on ${DateTime.now().toString()}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (caption != null && caption.isNotEmpty) // Display caption if available
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0), // Adjust horizontal padding here
                            child: Text(
                              caption,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        Image.network(imageUrl),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                    hintText: 'Enter caption...',
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              FloatingActionButton(
                onPressed: _postImage,
                child: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
