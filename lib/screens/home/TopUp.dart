import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopUp extends StatefulWidget{
  TopUp({Key? key}) : super(key: key);

  @override
  _TopUp createState() => _TopUp();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
String fullName = "";
double balance = 0.0;
String amountToAdd = "";
var _formKey = GlobalKey<FormState>();


class _TopUp extends State<TopUp> {
  @override
  Widget build(BuildContext context) {
    getName();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Top up'),
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
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(" Enter amount to add.", style: TextStyle(
                        color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (val) => val!.isEmpty || double.parse(val) <= 0? "Amount can't be empty or 0\€." : null,
                  cursorColor: Colors.black,
                  onChanged: (val) {
                    setState(() {
                      amountToAdd = val;
                    });
                  },

                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    labelText: 'Amount',
                    hintText: 'Enter amount to add',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    prefixIcon: Icon(IconData(0xe23c, fontFamily: 'MaterialIcons'), color: Colors.black, size: 18, ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox(height: 15),),
                IntrinsicHeight(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      if(!_formKey.currentState!.validate()) {
                        return;
                      }

                      updateBalance();
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                        "Top up", style: TextStyle(color: Colors.white)
                    ),
                  )
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

      if(this.mounted) {
        setState(() {
          fullName = firstName + " " + lastName;
          balance = double.parse(event.data()!['balance'].toString());
        });
      }
    });
  }

  Future<void> updateBalance() async {
    setState(() {
      balance = balance + double.parse(amountToAdd);
    });

    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid) // <-- Doc ID where data should be updated.
        .update({'balance' : balance})
        .then((value) {
          Flushbar(
            padding: EdgeInsets.all(10),
            backgroundColor: Colors.green.shade900,

            duration: Duration(seconds: 1),
            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
            forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
            message: amountToAdd + '\€ has been added to your balance.',
          ).show(context);
        })// <-- Nested value
        .catchError((error) => print('Update failed: $error'));
  }
}