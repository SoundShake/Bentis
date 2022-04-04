import 'package:flutter/material.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/screens/authenticate/sign_in.dart';
import 'package:untitled/shared/Loading.dart';
import 'package:untitled/shared/constants.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation:0.0,
          title: const Text('Sign up to Bentis'),
            actions: <Widget>
            [
              TextButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Sign in'),
                  onPressed: (){
                        Navigator.of(context).pushReplacement(
                            CustomPageRoute(
                          builder: (context) => const SignIn(),
                        ));
                  }
              )
            ]
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>
                    [
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText:'Email'),
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() =>email = val);
                          }
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          decoration:textInputDecoration.copyWith(hintText:'Password'),
                          validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long': null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() =>password = val);
                          }
                      ),
                      const SizedBox(height: 20.00,),
                      ElevatedButton(
                        child: const Text('Register'),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.pink[400]),
                            textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              loading =true;
                            });
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if(result == null)
                              {
                                setState(() {
                                  error = 'please supply a valid email';
                                  loading = false;
                                });
                              }

                          }
                        },
                      ),
                        const SizedBox(height: 12.00,),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize:14.0),
                      )
                    ]
                )
            )
        )
    );
  }
}
