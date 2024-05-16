import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Likes {
  static Future<void> likeOrUnlikeImage(String imageId) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    final CollectionReference likesCollection = FirebaseFirestore.instance.collection('images').doc(imageId).collection('likes');

    final likeQuery = await likesCollection.where('userId', isEqualTo: userId).get();

    if (likeQuery.docs.isEmpty) {
      await likesCollection.add({'userId': userId});
    } else {
      final likeId = likeQuery.docs.first.id;
      await likesCollection.doc(likeId).delete();
    }
  }

  static Future<bool> hasLikedImage(String imageId) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    final likeQuery = await FirebaseFirestore.instance.collection('images').doc(imageId).collection('likes').where('userId', isEqualTo: userId).get();

    return likeQuery.docs.isNotEmpty;
  }
}
