import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:untitled/screens/home/TripsTakenHistory.dart';

import 'TripsGivenHistory.dart';


class Trips extends StatefulWidget {
  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  final _bottomNavigationBarItems = [
    BottomNavigationBarItem(
        icon: Icon(IconData(0xe1d7, fontFamily: 'MaterialIcons'), color: Colors.black),
        label: 'Joined trips',
    ),
    BottomNavigationBarItem(
        icon: Icon(IconData(0xe1d7, fontFamily: 'MaterialIcons'), color: Colors.black),
        label: 'Created trips'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// #region AppBar()
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Trips',
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
// #endregion
      body: PageView(
        controller: pageController,
        onPageChanged: (page){
          setState(() {
            _currentIndex = page;
          });
        },
        children: [
          TripsGivenHistory(),
          TripsTakenHistory(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _bottomNavigationBarItems,
        onTap: (index) {
          _onItemTapped(index);
        },
        //type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
  }
}