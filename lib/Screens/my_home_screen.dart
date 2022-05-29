import 'package:crypto_application/Screens/buy_trade.dart';
import 'package:crypto_application/Screens/third_scree.dart';

import 'first_screen.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  const MyHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _screenList = [
    FirstScreen(),
    SwitchBuyTrade(),
    ThirdScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenList[_selectedIndex],
      // backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.stairs),
            label: 'Crypto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
