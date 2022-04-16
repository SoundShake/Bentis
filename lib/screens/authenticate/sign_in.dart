import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/screens/authenticate/register.dart';
import 'package:untitled/screens/home/home.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:untitled/shared/Loading.dart';
import 'package:untitled/shared/constants.dart';
// For Overrided MaterialPageRout to tCustomPageRoute. To stop animation
class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
//----------------------------------------------------------------------

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String phoneNumber = 'numeris';
  String otpCode = '';

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  bool _isButtonLoading = false;
  bool wrongNumber = true;
  bool userExists = false;
  bool showError = false;
  bool isWrongCode = false;

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Container(
                    padding: EdgeInsets.all(30),
                    width: double.infinity,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInDown(
                          delay: Duration(milliseconds: 150),
                          child: Image(
                            image: AssetImage("assets/images/B_2.png"),
                            fit: BoxFit.cover,
                            width: 200,
                          ),
                        ),

                        SizedBox(height: 15,),
                        FadeInDown(
                          delay: Duration(milliseconds: 300),
                          child: Text('LOGIN',
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.grey.shade900),),
                        ),
                        FadeInDown(
                          delay: Duration(milliseconds: 450),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20),
                            child: Text('Login to your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),),
                          ),
                        ),
                        SizedBox(height: 10,),
                        FadeInDown(
                            delay: Duration(milliseconds: 600),
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.shade200, width: 2),
                                ),
                                child: Stack(
                                  children: [
                                    InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        setState(() {
                                          phoneNumber = number.phoneNumber!;
                                        });
                                      },
                                      onInputValidated: (bool value) {
                                        if (value) {
                                          setState(() {
                                            wrongNumber = false;
                                            print('Phone number: $phoneNumber');
                                          });
                                        }
                                        else {
                                          setState(() {
                                            wrongNumber = true;
                                            phoneNumber = '';
                                          });
                                        }
                                        print(value);
                                      },
                                      selectorConfig: SelectorConfig(
                                        selectorType: PhoneInputSelectorType
                                            .BOTTOM_SHEET,
                                      ),

                                      initialValue: PhoneNumber(isoCode: 'LT'),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode
                                          .disabled,
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

                                      selectorTextStyle: TextStyle(color: Colors
                                          .black),
                                      textFieldController: TextEditingController(),
                                      formatInput: false,
                                      maxLength: 9,
                                      keyboardType:
                                      TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                      cursorColor: Colors.black,
                                      inputDecoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 15, left: 0),
                                        border: InputBorder.none,
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Positioned(
                                      left: 94,
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
                                (wrongNumber && showError)
                                    ? 'Number is invalid'
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        FadeInDown(
                          delay: Duration(milliseconds: 750),
                          child: MaterialButton(
                            onPressed: () async {
                              if (wrongNumber) {
                                setState(() {
                                  showError = true;
                                });
                                return;
                              }

                              userExists = await isUserInDatabase();
                              print('User exists:' + userExists.toString());

                              setState(() {
                                _isButtonLoading = false;
                              });

                              if (userExists) {
                                setState(() {
                                  wrongNumber = false;
                                  showError = false;
                                });

                                String resendCode = "no";
                                await askForCode(resendCode);
                              }
                              else {
                                setState(() {
                                  wrongNumber = true;
                                  showError = true;
                                });
                              }
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            child: _isButtonLoading ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            ) :
                            Text("Login", style: TextStyle(
                                color: Colors.white, fontSize: 16.0),),
                          ),
                        ),
                        SizedBox(height: 15,),
                        FadeInDown(
                          delay: Duration(milliseconds: 900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?',
                                style: TextStyle(color: Colors.grey.shade700),),
                              SizedBox(width: 5,),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Register()));
                                },
                                child: Text('Register', style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),),
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

  Widget returnOTPScreen() {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              setState(() {
                isOTPScreen = false;
                isLoginScreen = true;
                phoneNumber = '';
              });
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKeyOTP,
                child: Container(
                    padding: EdgeInsets.all(30),
                    width: double.infinity,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInDown(
                              delay: Duration(milliseconds: 150),
                              child: Image(
                                image: AssetImage("assets/images/phoneAuth.png"),
                                fit: BoxFit.cover,
                                width: 220,
                              ),
                          ),
                          SizedBox(height: 15,),
                          FadeInDown(
                            delay: Duration(milliseconds: 300),
                            child: Text('VERIFICATION',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey.shade900),),
                          ),
                          FadeInDown(
                            delay: Duration(milliseconds: 450),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                              child: Text('Enter the code sent to: $phoneNumber',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                            ),
                          ),
                          SizedBox(height: 10,),
                          FadeInDown(
                            delay: Duration(milliseconds: 600),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              validator: (val) {
                                if (val?.length != 6) {
                                  Future.delayed(Duration.zero, () async {
                                    setState(() {
                                      isWrongCode = false;
                                    });
                                  });

                                  return "Enter 6 numbers please";
                                } else if (isWrongCode) {
                                  Future.delayed(Duration.zero, () async {
                                    setState(() {
                                      _isButtonLoading = false;
                                    });
                                  });

                                  return "You've written incorrect OTP code";
                                }

                                return null;
                              },
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              onChanged: (String value) {
                                if (value.length == 6) {
                                  otpCode = value;
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          FadeInDown(
                            delay: Duration(milliseconds: 750),
                            child: MaterialButton(
                              onPressed: () async {
                                if(_formKeyOTP.currentState!.validate()) {
                                  await login();

                                  setState(() {
                                    isResend = false;
                                    _isButtonLoading = true;
                                  });
                                }
                              },
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: _isButtonLoading ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              ) :
                              Text("Verify", style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),),
                            ),
                          ),
                          SizedBox(height: 15,),
                          FadeInDown(
                            delay: Duration(milliseconds: 900),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Didn\'t receive code?',
                                  style: TextStyle(color: Colors.grey.shade700),),
                                SizedBox(width: 5,),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isResend = true;
                                    });

                                    String resendCode = "yes";
                                    await askForCode(resendCode);


                                  },
                                  child: Text('Resend verification code', style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),),
                                )
                              ],
                            ),
                          )
                        ]
                    )
                )
            )
        )
    );
  }


  Future<bool> isUserInDatabase() async {
    setState(() {
      _isButtonLoading = true;
    });

    var result =     await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    print('If number is found result == 1, result = ' + result.docs.length.toString());
    bool userExists = result.docs.length > 0;
    return Future<bool>.value(userExists);
  }

  Future askForCode(String isResend) async {
    if (isResend != "yes") {
      setState(() {
        _isButtonLoading = true;
      });
    }

    var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
            if (user != null) {
             setState(() {
               _isButtonLoading = false;
              }),
            }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          setState(() {
            _isButtonLoading = false;
          });

          Flushbar(
            padding: EdgeInsets.all(10),
            backgroundColor: Colors.red.shade900,

            duration: Duration(seconds: 4),
            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
            forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
            title: isResend == "yes" ? 'Resend failed.' : 'Login failed.',
            message:  isResend == "yes" ? 'Too many attempts to resend code. Try again later.' : 'Too many attempts to login. Try again later.',
          ).show(context);
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isOTPScreen = true;
            isLoginScreen = false;
            _isButtonLoading = false;
            verificationCode = verificationId;
          });

          if (isResend == "yes") {
            Flushbar(
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.green.shade900,

              duration: Duration(seconds: 4),
              dismissDirection: FlushbarDismissDirection.HORIZONTAL,
              forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
              message: 'Verification code has been resent to your phone number',
            ).show(context);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _isButtonLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration (seconds: 10),
    );

    await verifyPhoneNumber;
  }

  Future login() async {
    setState(() {
      _isButtonLoading = true;
    });

    var attemptSignIn = _auth
        .signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId:
            verificationCode,
            smsCode: otpCode,
        ))
        .then((user) async => {
      //sign in was success
      if (user != null)
        {
          //store registration details in firestore database
          setState(() {
            _isButtonLoading = false;
            isResend = false;
          }),
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext
              context) =>
                  Home(),
            ),
                (route) => false,
          )
        }
    })
        .catchError((error) => {
      setState(() {
        _isButtonLoading = false;
        isWrongCode = true;
      }),
    });

    try {
      await attemptSignIn;
    } catch (e) {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }
}