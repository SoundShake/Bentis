import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
List passengers = List.filled(5, 0, growable: true);
String currentUserName = "";
String postUserName = "";
double currentBalance = 0.0;
bool canJoinTheRide = false;

class ViewPost extends StatefulWidget{
  DocumentSnapshot post;
  ViewPost(this.post, {Key? key}) : super(key: key);

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost>{
  DateTime? date;
  String departure="";
  String arrival="";
  double price=0;
  int seats=0;
  Future<DocumentSnapshot>? driverRef;

  @override
  Widget build(BuildContext context){
    getPostData();
    getUserData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('View post'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Date: "+DateFormat('yyyy-MM-dd HH:mm').format(date as DateTime)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text("Departure: "+departure),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text("Destination: "+arrival),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text("Price: "+price.toString()+" €"),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text("Seats: "+seats.toString()),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  driverDisplay(driverRef),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
                  ),
                  onPressed: () => {
                    if (currentUserName == postUserName) {
                      Flushbar(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.red.shade900,

                        duration: Duration(seconds: 3),
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                        title: 'Joining ride was denied.',
                        message: 'Creator of the post can\'t join their own ride.',
                      ).show(context),
                    }
                    else if(passengers.contains(_auth.currentUser?.uid)) {
                      Flushbar(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.red.shade900,

                        duration: Duration(seconds: 3),
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                        title: 'Joining ride was denied.',
                        message: 'You\'ve already joined the ride.',
                      ).show(context),
                    }
                    else if(price > currentBalance) {
                        Flushbar(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.red.shade900,

                          duration: Duration(seconds: 3),
                          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                          title: 'Joining ride was denied.',
                          message: 'Your current balance is too low to join the ride.',
                        ).show(context),
                    }
                    else if(seats>0){
                        joinPost(),
                    }
                  },
              ),
            ],
          ),
        ),
      )
    );
  }
  Future<void> getPostData() async{
    date=DateTime.parse(widget.post.get("date").toDate().toString());
    departure=widget.post.get("departure");
    arrival=widget.post.get("destination");
    price=widget.post.get("price");
    seats=widget.post.get("seats");
    driverRef=FirebaseFirestore.instance.collection("users").doc(widget.post.get("user")).get();
  }

  void getUserData() async {
    await _firestore.collection("users").doc(_auth.currentUser?.uid).get().then((event) {
      String firstName = event.data()!['name'];
      String lastName = event.data()!['surname'];
      currentUserName = firstName + " " + lastName;
      passengers = widget.post.get("passengers");
      currentBalance = event.data()!['balance'];
    });
  }

  Future<void> joinPost() async{
    var user=FirebaseAuth.instance.currentUser;
    if(seats>0 && user!=null){
      setState(() {
        seats-=1;
      });
      passengers=widget.post.get("passengers");
      passengers.add(user.uid);
      widget.post.reference.update({
        "seats": seats,
        "passengers": passengers,
      });
    }
    widget.post=await widget.post.reference.get();
    updateBalance();
    setState(() {});
  }

  Future<void> updateBalance() async {
    setState(() {
      currentBalance = currentBalance - price;
    });

    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid) // <-- Doc ID where data should be updated.
        .update({'balance' : currentBalance})
        .then((value) {
      Flushbar(
        padding: EdgeInsets.all(10),
        backgroundColor: Colors.green.shade900,

        duration: Duration(seconds: 2),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        message: 'You\'ve successfully joined the ride.',
      ).show(context);
    })// <-- Nested value
        .catchError((error) => print('Update failed: $error'));
  }
}
class driverDisplay extends StatelessWidget{
  Future<DocumentSnapshot>? driver;
  driverDisplay(this.driver, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context){
    return FutureBuilder<String>(
      future: snapshot(),
      builder: (context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          postUserName = snapshot.data as String;
          return Text("Driver: "+(snapshot.data as String));
        }
        else{
          return CircularProgressIndicator();
        }
      }
    );
  }

  Future<String> snapshot() async{
    DocumentSnapshot? doc=await driver;
    String name=(doc as DocumentSnapshot).get("name")+" "+(doc as DocumentSnapshot).get("surname");
    return name;
  }
}