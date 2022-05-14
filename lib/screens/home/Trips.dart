import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ services/database.dart';
import '../../models/bentis.dart';
import '../post/view.dart';

List ridesHistory = [];
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Trips extends StatefulWidget {
  const Trips({Key? key}) : super(key: key);
  @override
  State<Trips> createState() => _Trips();
}

class _Trips extends State<Trips>{
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
          appBar: AppBar(
            title: const Text('Trips history'),
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
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
                        children: snapshot.data!.docs.where((element) => ridesHistory.contains(element.id)).map((document) {
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
      setState(() {
        ridesHistory = event.data()!['ridesHistory'];
      });
    });
  }

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 0));
  }
}