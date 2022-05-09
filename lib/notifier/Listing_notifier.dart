import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/listing.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
addListing(Listing listingData) async {
  await _db.collection("posts").add(listingData.toMap());
}

updateListing(Listing listingData) async {
  await _db.collection("posts").doc(listingData.id).update(listingData.toMap());
}

Future<void> deleteListing(String documentId) async {
  await _db.collection("posts").doc(documentId).delete();

}

Future<List<Listing>> retrieveListing() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
  await _db.collection("posts").get();
  return snapshot.docs
      .map((docSnapshot) => Listing.fromDocumentSnapshot(docSnapshot))
      .toList();
}