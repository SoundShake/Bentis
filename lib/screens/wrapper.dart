import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/cities.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/authenticate/authenticate.dart';
import 'package:untitled/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  final List<String>? cities;
  const Wrapper(this.cities, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user =  Provider.of<MyUser?>(context);
    //return either Home or Authenticate widget
    if(user == null)
      {
        return Authenticate(cities);
      }
    else{
      return Home(cities);
    }
  }
}
