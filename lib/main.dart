import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/models/cities.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  List<String>? cities=await Cities.GetCitiesAsync();
  runApp(MyApp(cities));
}

class MyApp extends StatelessWidget {
  final List<String>? cities;
  const MyApp(this.cities, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value:AuthService().user,
      catchError: (_,__) {
        return null;
      },
      initialData: null,
      child: MaterialApp(
        home: Wrapper(cities),
      ),
    );
  }
}

