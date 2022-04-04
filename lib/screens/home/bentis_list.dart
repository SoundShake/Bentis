import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bentis.dart';
import "bentis_tile.dart";

class BentisList extends StatefulWidget {
  const BentisList({Key? key}) : super(key: key);

  @override
  State<BentisList> createState() => _BentisListState();
}

class _BentisListState extends State<BentisList> {
  @override
  Widget build(BuildContext context) {
    final bentis = Provider.of<List<Bentis1>>(context);
    
    return ListView.builder(
      itemCount: bentis.length,
      itemBuilder: (context, index){
        return BentisTile(bentis: bentis[index]);
      },
    );
  }
}
