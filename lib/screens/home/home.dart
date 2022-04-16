import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/%20services/database.dart';
import 'package:untitled/main.dart';
import 'package:untitled/models/bentis.dart';
import 'package:untitled/screens/home/bentis_list.dart';

import '../authenticate/sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String phoneNumber = '';
String name = '';
String surname = '';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel(BuildContext context) {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: const Text('bottom sheet'),
        );
      });
    };

    Widget _showPostCreation(BuildContext context){
      return AlertDialog(
        title: const Text('Post Creation'),
        content: Column(
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Departure',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Destination'
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return StreamProvider<List<Bentis1>>.value(
        value: DatabaseService(uid:'').Bentis,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.brown[50],
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed:()=>
            {
              showDialog(
                context: context,
                builder: (BuildContext context) => _showPostCreation(context),
              ),
            },
          ),
          appBar: AppBar(
              title: const Text('Bentis'),
              backgroundColor: Colors.brown[400],
              elevation:0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('logout'),
                  onPressed: () async {
                    _signOut().then((value) => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => SignIn())));
                  },
                ),
                TextButton.icon(
                  icon:const Icon(Icons.settings),
                  label: Text('settings'),
                  onPressed: () => _showSettingsPanel(context),
                )
              ]
          ),
          body: const BentisList(),
        )
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }
}