import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget{
  Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
String fullName = "";
double balance = 0.0;

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
                    Text(balance.toString() + " \€", style: TextStyle(
                        color: Colors.green.shade900, fontSize: 25.0, fontWeight: FontWeight.w900)),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 10,
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {

                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                        "TOP UP WALLET", style: TextStyle(color: Colors.white)
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  void getName() async {
    await _firestore.collection("users").doc(_auth.currentUser?.uid).get().then((event) {
      String firstName = event.data()!['name'];
      String lastName = event.data()!['surname'];
      fullName = firstName + " " + lastName;

      balance = event.data()!['balance'];
    });
  }
}