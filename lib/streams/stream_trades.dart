import 'package:crypto_application/data_base.dart';
import 'package:crypto_application/models/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/trade_Screen.dart';

class StreamTrades extends StatefulWidget {
  const StreamTrades({Key? key}) : super(key: key);

  @override
  State<StreamTrades> createState() => _StreamTradesState();
}

class _StreamTradesState extends State<StreamTrades> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  @override
  void initState() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Trade>>.value(
      initialData: [],
      value: Database().streamTrade(uid),
      child: TradeOffers(),
    );
  }
}

class StreamRecieved extends StatefulWidget {
  StreamRecieved({Key? key}) : super(key: key);

  @override
  State<StreamRecieved> createState() => _StreamRecievedState();
}

class _StreamRecievedState extends State<StreamRecieved> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  @override
  void initState() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Trade>>.value(
      initialData: [],
      value: Database().streamTradeRec(uid),
      child: TradeOffersRec(),
    );
  }
}
