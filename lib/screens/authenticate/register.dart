import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/screens/authenticate/sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:untitled/screens/home/home.dart';
import 'package:untitled/shared/Loading.dart';
import 'package:animate_do/animate_do.dart';
import 'package:untitled/shared/constants.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);


  @override
  State<Register> createState() => _RegisterState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _RegisterState extends State<Register> {
  var _formKey = GlobalKey<FormState>();
  var _formKeyOTP = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  String phoneNumber = 'numeris';
  String otpCode = '';
  String userFirstName = '';
  String userLastName = '';

  var isLoading = false;
  var isResend = false;
  var isRegisterScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  bool wrongNumber = true;
  bool showError = false;
  bool _isButtonLoading = false;
  bool userExists = false;
  bool isWrongCode = false;

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnRegisterScreen();
  }

  Widget returnRegisterScreen() {
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
                    child: Text('REGISTER',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey.shade900),),
                  ),
                  SizedBox(height: 15,),
                  FadeInDown(
                    delay: Duration(milliseconds: 300),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        labelText: 'Name',
                        hintText: 'Enter your first name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        prefixIcon: Icon(Iconsax.personalcard, color: Colors.black, size: 18, ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) => val!.isEmpty && val.length < 2 ? "Name is too short or empty" : null,
                      onChanged: (val) {
                        setState(() {
                          userFirstName = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  FadeInDown(
                    delay: Duration(milliseconds: 450),
                    child: TextFormField(
                      validator: (val) => val!.isEmpty && val.length < 2 ? "Surname is too short or empty" : null,
                      cursorColor: Colors.black,
                      onChanged: (val) {
                        setState(() {
                          userLastName = val;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        labelText: 'Surname',
                        hintText: 'Enter your last name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        prefixIcon: Icon(Iconsax.personalcard, color: Colors.black, size: 18, ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
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
                              setState(() {
                                phoneNumber = number.phoneNumber!;
                              });
                            },
                            onInputValidated: (bool value) {
                              if (value) {
                                setState(() {
                                  wrongNumber = false;
                                  print('Phone number we got: $phoneNumber');
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
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (wrongNumber && showError) ? 'Number is invalid or already in use' : '',
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
                      minWidth: double.infinity,
                      onPressed: () async {
                        if (wrongNumber) {
                          setState(() {
                            showError = true;
                          });
                        }

                        if(!_formKey.currentState!.validate() || wrongNumber) {
                          return;
                        }

                        userExists = await isUserInDatabase();

                        if (!userExists) {
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
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: _isButtonLoading  ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      ) :
                      Text("Request OTP", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 15,),
                  FadeInDown(
                    delay: Duration(milliseconds: 900),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?', style: TextStyle(color: Colors.grey.shade700),),
                        SizedBox(width: 5,),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                          },
                          child: Text('Login', style: TextStyle(color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.w400),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
                isResend = true;
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
                                  await registerUser();

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
                                  child: Text('Resend OTP', style: TextStyle(
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
    var result = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

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

            await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({
              'name' : userFirstName,
              'phoneNumber' : phoneNumber,
              'surname' : userLastName,
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
        }).catchError((error) => {
          debugPrint('Error saving user to db.' + error.toString())
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        setState(() {
          _isButtonLoading = false;
          showError = true;
          wrongNumber = true;
        });
      },
      codeSent: (verificationId, [forceResendingToken]) {
        setState(() {
          print('Code was sent');
          isOTPScreen = true;
          isRegisterScreen = false;
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
            message: 'One time password has been resent to your phone number',
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

  Future registerUser() async {
    setState(() {
      _isButtonLoading = true;
    });

    var attemptUserRegistration = _auth
    .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: otpCode))
    .then((user) async => {
      if (user != null) {
        await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
          'name' : userFirstName,
          'phoneNumber' : phoneNumber,
          'surname' : userLastName,
        }, SetOptions(merge: true))
        .then((value) => {
          setState(() {
            _isButtonLoading = false;
          })
        }),

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
    }).catchError((error) => {
      setState(() {
        _isButtonLoading = false;
        isWrongCode = true;
      })
    });

    try {
      await attemptUserRegistration;
    } catch (e) {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }
}