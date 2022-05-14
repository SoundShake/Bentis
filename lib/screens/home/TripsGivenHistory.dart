import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ services/database.dart';
import '../../models/bentis.dart';
import '../post/view.dart';

List givenRidesHistory = [];
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TripsTakenHistory extends StatefulWidget {
  const TripsTakenHistory({Key? key}) : super(key: key);
  @override
  State<TripsTakenHistory> createState() => _TripsTakenHistory();
}

class _TripsTakenHistory extends State<TripsTakenHistory>{
  @override
  Widget build(BuildContext context) {
    getUserData();
    return StreamProvider<List<Bentis1>>.value(
        value:
        DatabaseService(uid: FirebaseAuth.instance.currentUser.toString())
            .Bentis,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs.where((element) => givenRidesHistory.contains(element.id)).map((document) {
                          return Container(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ViewPost(document, true)),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Text("${document['departure']} -> ${document['destination']}"),
                              subtitle: Text(
                                  "Price: ${document['price']}€, Number of seats: ${document['seats']}"),
                              trailing: const Icon(Icons.arrow_right_sharp),
                            ),
                          );
                        }).toList(),
                      );
                    })),
          ),
        )
    );
  }

  void getUserData() async {
    await _firestore.collection("users").doc(_auth.currentUser?.uid).get().then((event) {
      if(this.mounted) {
        setState(() {
          givenRidesHistory = event.data()!['createdRides'];
        });
      }
    });
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 0));
  }
}