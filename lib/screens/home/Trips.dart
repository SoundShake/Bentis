import 'package:flutter/material.dart';


class Trips extends StatelessWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Trips'),
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);

              },

            ),
          ),
        )
    );
  }
}