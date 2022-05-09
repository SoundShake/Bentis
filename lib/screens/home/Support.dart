import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Help & Support'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
            Row(
            children: const [
            Text('Write you problem and we will contact you through email'),
              ],
            ),
              SizedBox(height: 30),
              Row(
                children: const [
                  Text('Email adress:'),
                ],
              ),

              TextField(
                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(
                  counter: Container(),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('Write your problem:'),
                ],
              ),

              TextField(
                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(
                  counter: Container(),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),


          OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(

              shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),

                  )
              ),
            ),
            child: const Text("Submit"),
          )
            ]
          )
            )

          ),
        );
  }
}
