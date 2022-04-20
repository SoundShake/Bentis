import 'package:flutter/material.dart';
import 'package:untitled/screens/authenticate/register.dart';
import 'package:untitled/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  final List<String>? cities;
  const Authenticate(this.cities, {Key? key}) : super(key: key);
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
      return SignIn(widget.cities);
  }
}
