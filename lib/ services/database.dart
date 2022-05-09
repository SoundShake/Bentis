import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/bentis.dart';

import '../models/listing.dart';


class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');


  Future updateUserData(String name, String surname,String phoneNumber,String imageUrl) async
  {
    return await usersCollection.doc(uid).set({
      'name':name,
      'surname':surname,
      'phoneNumber':phoneNumber,
      'ImageUrl': imageUrl,

    });
  }

  //Bentis list from snapshot
  List<Bentis1> _bentisListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc1) {
      return Bentis1(
        name: doc1.get('name') ?? '',
        surname: doc1.get('surname') ?? '',
        phoneNumber: doc1.get('phoneNumber') ?? '',
        imageUrl: doc1.get('imageUrl') ?? '',
      );
    }).toList();
  }

  //get Bentis stream
  Stream<List<Bentis1>> get Bentis {
    return usersCollection.snapshots().map(_bentisListFromSnapshot);
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Listing>> retrieveListing() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("posts").get();
    return snapshot.docs
        .map((docSnapshot) => Listing.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addListing(Listing listingData) async {
    await _db.collection("posts").add(listingData.toMap());
  }

  updateListing(Listing listingData) async {
    await _db.collection("posts").doc(listingData.id).update(
        listingData.toMap());
  }

  Future<void> deleteListing(String documentId) async {
    await _db.collection("posts").doc(documentId).delete();
  }
}