import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/%20services/database.dart';
import 'package:untitled/main.dart';
import 'package:untitled/models/bentis.dart';
import 'package:untitled/screens/home/Profile.dart';
import 'package:untitled/screens/home/bentis_list.dart';
import 'package:untitled/screens/post/creation.dart';
import 'package:untitled/models/cities.dart';
import '../../models/listing.dart';
import '../../notifier/Listing_notifier.dart';
import '../authenticate/sign_in.dart';
import '../post/view.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String phoneNumber = '';
String name = '';
String surname = '';

class Home extends StatefulWidget {
  final List<String>? cities;

  const Home(this.cities, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    Future<void> _initRetrieval() async {
      Future<Map<String, dynamic>> futureListing =
          (await retrieveListing()) as Future<Map<String, dynamic>>;
    }

    @override
    void initState() {
      super.initState();
      _initRetrieval();
    }

    void _showSettingsPanel(BuildContext context) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: TextButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Profile'),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(widget.cities)),
                  ),
                },
              ),
            );
          });
    }

    ;


    return StreamProvider<List<Bentis1>>.value(
        value:
            DatabaseService(uid: FirebaseAuth.instance.currentUser.toString())
                .Bentis,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePost(widget.cities)),
              ),
            },
          ),
          appBar: AppBar(
              title: const Text('Bentis'),

              backgroundColor: Colors.black,
              elevation:0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon:const Icon(Icons.person),
                  label: Text('Profile'),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(widget.cities)),
                    ),
                  },
            )
              ]),
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
                        children: snapshot.data!.docs.where((element) => Timestamp.now().compareTo(element['date']) < 0 && element['seats'] > 0).map((document) {
                          return Container(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ViewPost(document, false)),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Text("${document['departure']} -> ${document['destination']}"),
                              subtitle: Text(
                                  "Price: ${document['price']}€, Number of seats: ${document['seats']}\nDate: ${DateFormat("yyyy-MM-dd hh:mm").format(DateTime.parse(document['date'].toDate().toString()))}"),
                              trailing: const Icon(Icons.arrow_right_sharp),
                            ),
                          );
                        }).toList(),
                      );
                    })),
          ),
        ));
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }
}

Future<void> _refresh() {
  return Future.delayed(const Duration(seconds: 0));
}
