import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Cities{
  static List<String>? cities;

  static List<String>? getList(){
    GetCities();
    return cities;
  }

  static Future<bool> GetCities() async{
    cities=await GetCitiesAsync();
    return true;
  }

  static Future<List<String>> GetCitiesAsync() async{
    CollectionReference _cities=FirebaseFirestore.instance.collection("cities");
    QuerySnapshot querySnapshot=await _cities.get();
    return querySnapshot.docs.map((doc) => doc.get('city').toString()).toList();
  }
}