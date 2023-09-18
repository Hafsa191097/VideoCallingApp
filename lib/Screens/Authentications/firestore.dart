import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDataBase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   getQuizData() {
    return _firestore.collection('Quiz').snapshots();
  }
    Future<void> addLData(img,title,desc) async {
     
      final ref = FirebaseFirestore.instance
      .collection('Images')
      .doc();
      var data1 = {
        'Image' : img,
      };

      await ref.set(data1, SetOptions(merge: true));
      
  }

  Future<QuerySnapshot<Map<String,dynamic>>> getData(String QuizId)  {
    return _firestore.collection('Quiz').doc(QuizId).collection('Images').get();
    
  }
  Stream<QuerySnapshot<Map<String,dynamic>>> getDataStream()  {
    return _firestore.collection('Users').snapshots();
  }
  
}