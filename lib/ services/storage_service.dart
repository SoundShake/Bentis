import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);
    try {
      await storage.ref('Avatars/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e)
    {
      print(e);
    }

  }

  Future<String> downloadURL(String imageName ) async {
    String downloadUrl = await storage.ref('Avatars/$imageName').getDownloadURL();
    await _firestore.collection("users").doc(_auth.currentUser?.uid).update({'imageUrl': downloadUrl});
    return downloadUrl;
  }

}