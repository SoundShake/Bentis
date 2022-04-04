import 'package:flutter/material.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/screens/authenticate/register.dart';
import 'package:untitled/shared/Loading.dart';
import 'package:untitled/shared/constants.dart';
// For Ovverided MaterialPageRout to tCustomPageRoute. To stop animation
class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
//----------------------------------------------------------------------


  class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);


    @override
    State<SignIn> createState() => _SignInState();
  }
  
  class _SignInState extends State<SignIn> {

    final AuthService _auth = AuthService();
    final _formKey = GlobalKey<FormState>();
    bool loading = false;

    //text field state
    String email ='';
    String password = '';
    String error = '';

    @override
    Widget build(BuildContext context) {
      return loading ? const Loading() : Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation:0.0,
          title: const Text('Sign in to Bentis'),
          actions: <Widget>
            [
              TextButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Register'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        CustomPageRoute(
                          builder: (context) => const Register(),
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
                    decoration:textInputDecoration.copyWith(hintText:'Email'),
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
                  child: const Text('Sign in'),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.pink[400]),
                      textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))),
                  onPressed: () async {
                  if(_formKey.currentState!.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                    if(result == null)
                      {
                         setState(()
                         {
                         error = 'Could not sign in with those credentials';
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
  