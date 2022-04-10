import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//import 'package:untitled/%20services/auth.dart';
import 'package:untitled/screens/authenticate/register.dart';
import 'package:untitled/screens/home/home.dart';
// For Overrided MaterialPageRout to tCustomPageRoute. To stop animation
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

  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  //text field state
  bool wrongNumber = true;
  String email ='';
  String password = '';
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Container(
                    padding: EdgeInsets.all(30),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInDown(
                          delay: Duration(milliseconds: 150),
                          child: Image(
                            image: AssetImage("assets/images/B_2.png"), fit: BoxFit.cover, width:200,
                          ),
                        ),

                        SizedBox(height: 15,),
                        FadeInDown(
                          delay: Duration(milliseconds: 300),
                          child: Text('LOGIN',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey.shade900),),
                        ),
                        FadeInDown(
                          delay: Duration(milliseconds: 450),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                            child: Text('Login to your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                          ),
                        ),
                        SizedBox(height: 25,),
                        FadeInDown(
                            delay: Duration(milliseconds: 600),
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200, width: 2),
                                ),
                                child: Stack(
                                  children: [
                                    InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        print(number.phoneNumber);
                                      },
                                      onInputValidated: (bool value) {
                                        if (value) {
                                          setState(() {
                                            wrongNumber = false;
                                          });
                                        }
                                        else {
                                          setState(() {
                                            wrongNumber = true;
                                          });
                                        }
                                        print(value);
                                      },
                                      selectorConfig: SelectorConfig(
                                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                      ),

                                      initialValue: PhoneNumber(isoCode: 'LT'),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode.disabled,
                                      validator: (val) {
                                        if (wrongNumber) {
                                          setState(() {
                                            showError = true;
                                          });
                                        } else {
                                          setState(() {
                                            showError = false;
                                          });
                                        }
                                        return null;
                                      },

                                      selectorTextStyle: TextStyle(color: Colors.black),
                                      textFieldController: TextEditingController(),
                                      formatInput: false,
                                      maxLength: 9,
                                      keyboardType:
                                      TextInputType.numberWithOptions(signed: true, decimal: true),
                                      cursorColor: Colors.black,
                                      inputDecoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                                        border: InputBorder.none,
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                      onSaved: (PhoneNumber number) {
                                        print('On Saved: $number');
                                      },
                                    ),
                                    Positioned(
                                      left: 90,
                                      top: 8,
                                      bottom: 8,
                                      child: Container(
                                        height: 40,
                                        width: 1,
                                        color: Colors.black.withOpacity(0.13),
                                      ),
                                    ),
                                  ],
                                )
                            )
                        ),
                        SizedBox(height: 3,),
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                (wrongNumber && showError) ? 'Number is invalid' : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        FadeInDown(
                          delay: Duration(milliseconds: 750),
                          child: MaterialButton(
                            onPressed: (){
                              if (wrongNumber) {
                                setState(() {
                                  showError = true;
                                });
                                return;
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              Future.delayed(Duration(milliseconds: 1500), () {
                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                              });
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: _isLoading  ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            ) :
                            Text("Login", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                          ),
                        ),
                        SizedBox(height: 15,),
                        FadeInDown(
                          delay: Duration(milliseconds: 900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?', style: TextStyle(color: Colors.grey.shade700),),
                              SizedBox(width: 5,),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                                },
                                child: Text('Register', style: TextStyle(color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}
