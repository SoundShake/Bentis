import 'package:flutter/material.dart';
import 'package:untitled/models/bentis.dart';

class BentisTile extends StatelessWidget {

  final Bentis1 bentis;
  BentisTile({required this.bentis});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[50]
          ),
          title: Text(bentis.name),

        )
      )
    );
  }
}
