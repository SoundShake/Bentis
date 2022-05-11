import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    getData();
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
                    if(seats>0)
                      {
                        joinPost(),
                      }
                    else{
                      null,
                    }
                  },
              ),
            ],
          ),
        ),
      )
    );
  }
  Future<void> getData() async{
    date=DateTime.parse(widget.post.get("date").toDate().toString());
    departure=widget.post.get("departure");
    arrival=widget.post.get("destination");
    price=widget.post.get("price");
    seats=widget.post.get("seats");
    driverRef=FirebaseFirestore.instance.collection("users").doc(widget.post.get("user")).get();
  }
  Future<void> joinPost() async{
    var user=FirebaseAuth.instance.currentUser;
    if(seats>0 && user!=null){
      setState(() {
        seats-=1;
      });
      List passengers=widget.post.get("passengers");
      passengers.add(user.uid);
      widget.post.reference.update({
        "seats": seats,
        "passengers": passengers,
      });
    }
    widget.post=await widget.post.reference.get();
    setState(() {});
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