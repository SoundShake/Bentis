import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/bentis.dart';


class DatabaseService
{
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String surname,String phoneNumber, String imageUrl) async
  {
    return await usersCollection.doc(uid).set({
      'name':name,
      'surname':surname,
      'phoneNumber':phoneNumber,
      'imageUrl':imageUrl,
    });
  }
  //Bentis list from snapshot
  List<Bentis1> _bentisListFromSnapshot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc1){
      return Bentis1(
        name: doc1.get('name') ?? '',
        surname: doc1.get('surname') ?? '',
        phoneNumber: doc1.get('phoneNumber') ?? '',
        imageUrl: doc1.get('imageUrl') ?? '',
      );
    }).toList();
  }
  //get Bentis stream
  Stream<List<Bentis1>> get Bentis
  {
    return usersCollection.snapshots().map(_bentisListFromSnapshot);
  }

}