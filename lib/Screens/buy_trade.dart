import 'package:crypto_application/Screens/second_screen.dart';
import 'package:crypto_application/Screens/trade_Screen.dart';
import 'package:flutter/material.dart';

class SwitchBuyTrade extends StatefulWidget {
  const SwitchBuyTrade({Key? key}) : super(key: key);

  @override
  State<SwitchBuyTrade> createState() => _SwitchBuyTradeState();
}

class _SwitchBuyTradeState extends State<SwitchBuyTrade>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
        leading: Text(''),
        title: TabBar(
          controller: _tabController,
          tabs: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Buy/Sell',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Trade',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [SecondScreen(), TradeScreen()]),
    );
  }
}
