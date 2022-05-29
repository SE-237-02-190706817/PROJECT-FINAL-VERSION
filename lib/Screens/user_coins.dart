import 'package:crypto_application/models/firebase%20models/coin_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCoins extends StatefulWidget {
  final num coinVal;
  final String coinName;
  UserCoins({Key? key, required this.coinVal, required this.coinName})
      : super(key: key);

  @override
  State<UserCoins> createState() => _UserCoinsState();
}

class _UserCoinsState extends State<UserCoins> {
  @override
  Widget build(BuildContext context) {
    final userCoins = Provider.of<List<CoinsFb>>(context);
    return Scaffold(
      body: ListView.builder(
          itemCount: userCoins.length,
          itemBuilder: (context, i) {
            return Text(userCoins[i].coinName);
          }),
    );
  }
}
