import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TopUp.dart';

class Wallet extends StatefulWidget{
  Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
String fullName = "";
double balance = 0.01;

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    getName();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            },
        ),
      ),
      body: Form(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(fullName, style: TextStyle(
                        color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Current balance: ", style: TextStyle(
                    color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w500)),
                    Text(balance.toStringAsFixed(2) + " \€", style: TextStyle(
                        color: Colors.green.shade900, fontSize: 25.0, fontWeight: FontWeight.w900)),
                  ],
                ),
                const Expanded(child: SizedBox(height: 15),),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TopUp()));
                    },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text(
                      "Top up wallet", style: TextStyle(color: Colors.white)
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Future<void> getName() async {
    await _firestore.collection("users").doc(_auth.currentUser?.uid).get().then((event) {
      String firstName = event.data()!['name'];
      String lastName = event.data()!['surname'];

      if(this.mounted) {
        setState(() {
          fullName = firstName + " " + lastName;
          balance = double.parse(event.data()!['balance'].toString());
        });
      }
    });
  }
}