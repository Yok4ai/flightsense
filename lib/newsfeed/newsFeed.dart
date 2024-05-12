import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'sidebar.dart'; // Import the Sidebar class

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late Stream<QuerySnapshot>
      _imageStream; // Stream for listening to Firestore changes
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late String _userEmail; // Store the current user's email
  final TextEditingController _captionController =
      TextEditingController(); // Controller for caption text field

  @override
  void initState() {
    super.initState();
    // _imageStream = FirebaseFirestore.instance.collection('images').snapshots();
    _imageStream = FirebaseFirestore.instance
        .collection('images')
        .orderBy('timestamp', descending: true)
        .snapshots();
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

  Future<void> _deletePost(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('images').doc(documentId).delete();
  }

  // Function to show confirmation dialog before deleting
void _showConfirmDeleteDialog(String documentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Show a progress indicator dialog
              final progressDialog = showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context); // Close progress indicator dialog

              // Now close the confirmation dialog and delete
              Navigator.pop(context); // Close confirmation dialog
              _deletePost(documentId);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}


  Future<void> _postImage() async {
    if (_imageFile == null) return;

    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.${_imageFile!.path.split('.').last}';
      final Reference ref = storage.ref().child('images/$fileName');

      final UploadTask uploadTask = ref.putFile(_imageFile!);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser; // Get current user
      final String userEmail = user!.email!; // Get current user's email

      final imageData = {
        'imageUrl': url,
        'userEmail': userEmail, // Add user's email to the data
        // 'caption': _captionController.text, // Add user's caption to the data
        'caption': _captionController.text.isEmpty
            ? ''
            : _captionController
                .text, // Add user's caption to the data or empty string if no caption
        'timestamp': DateTime.now(),
      };

      await firestore.collection('images').add(imageData);

      setState(() {
        _imageFile = null;
        _captionController.clear(); // Clear caption text field after posting
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        title: const Text('User Feed'),
      ),
      drawer: const Sidebar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _imageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                    final userEmail = images[index].get(
                        'userEmail'); // Retrieve user's email from Firestore
                    final documentId = images[index]
                        .id; // Get the document ID for the current post

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userEmail, // Display user's email from Firestore
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Posted on ${DateTime.now().toString()}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (caption != null && caption.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              child: Text(
                                caption,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          Image.network(imageUrl),
                          if (userEmail ==
                              _userEmail) // Check if the post is from the current user
                            const Icon(
                              Icons.circle,
                              color: Color.fromARGB(255, 122, 76, 175),
                            ),
                          if (userEmail ==
                              _userEmail) // Check if the post is from the current user
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Call the _showConfirmDeleteDialog function with the document ID
                                _showConfirmDeleteDialog(documentId);
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter caption...',
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _uploadImage();
                  },
                  child: const Text('Choose Image'),
                ),
                const SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: _postImage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
