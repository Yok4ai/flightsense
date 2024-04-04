import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase{
  User? user= FirebaseAuth.instance.currentUser;

  final CollectionReference _posts= FirebaseFirestore.instance.collection('posts');

  Future<void> addpost( String message){
    return _posts.add({
      'UserEmail':user!.email,
      'PostMessage':message,
      'TimeStamp':Timestamp.now()
  });
  }

  Stream<QuerySnapshot> getPostsStreams(){
         final postStream= FirebaseFirestore.instance.collection('posts').orderBy('TimeStamp',descending: true).snapshots();

         return postStream;
  }

}