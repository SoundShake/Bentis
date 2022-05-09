import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String user;
  final int seats;
  final Double price;
  final String destination;
  final String departure;
  final DateTime date;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'seats': seats,
      'price': price,
      'destination': destination,
      'departure': departure,
      'date': date
    };
  }

  //Listing(this.user, this.seats, this.price, this.destination, this.departure, this.date);

  Listing.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        user = doc.data()!["user"],
        seats = doc.data()!["seats"],
        price = doc.data()!["price"],
        destination = doc.data()!["destination"],
        departure = doc.data()!["departure"],
        date = doc.data()!["date"];
}





