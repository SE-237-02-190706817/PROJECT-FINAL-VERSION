import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_application/Screens/wallet_sc.dart';
import 'package:crypto_application/data_base.dart';
import 'package:crypto_application/models/chart_data_model.dart';
import 'package:crypto_application/models/fetchCoins_models/fetch_coins_models.dart';
import 'package:crypto_application/Screens/coin_detail_screen.dart';
import 'package:crypto_application/models/user.dart';

import 'package:crypto_application/widgets/coin_logo_widget.dart';
import 'package:crypto_application/widgets/loader2.dart';
import 'package:crypto_application/widgets/widgets.dart';
import 'package:crypto_application/widgets/ymd.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Screens/top_up_wallet.dart';
import '../streams/stream_user_coins.dart';

class CoinListWidget extends StatelessWidget {
  final List<DataModel> coins;

  const CoinListWidget({
    Key? key,
    required this.coins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Color.fromRGBO(11, 12, 54, 1),
          title: Text(
            "Crypto Currency",
            // style: Theme.of(context).textTheme.headline5,
            style: TextStyle(fontSize: 28),
          ),
          leading: Image.asset(
            'assets/images/crypto.png',
            height: 25,
            width: 25,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Wallet.id);
                },
                icon: Icon(Icons.credit_card_rounded))
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            YMDcoin(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // itemExtent: 160,
                itemCount: coins.length,
                itemBuilder: (context, index) {
                  var coin = coins[index];
                  var coinPrice = coin.quoteModel.usdModel;
                  var data = [
                    ChartData(coinPrice.percentChange_90d, 2160),
                    ChartData(coinPrice.percentChange_60d, 1440),
                    ChartData(coinPrice.percentChange_30d, 720),
                    ChartData(coinPrice.percentChange_24h, 24),
                    ChartData(coinPrice.percentChange_1h, 1),
                  ];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoinDetailScreen(coin: coin)),
                      );
                    },
                    child: Container(
                      height: 160.0,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CoinLogoWidget(coin: coin),
                          CoinChartWidget(
                            data: data,
                            coinPrice: coinPrice,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinListWidgetForBuy extends StatefulWidget {
  final List<DataModel> coins;
  const CoinListWidgetForBuy({
    Key? key,
    required this.coins,
  }) : super(key: key);

  @override
  State<CoinListWidgetForBuy> createState() => _CoinListWidgetForBuyState();
}

class _CoinListWidgetForBuyState extends State<CoinListWidgetForBuy> {
  void _showBuyForm(num coinPrice, String coinName, String coinSym) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            //color: Color.fromRGBO(11, 12, 54, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: StreamProvider<FbUser?>.value(
              value: Database().user,
              initialData: null,
              child: BuyCoins(
                coinVal: coinPrice,
                coinName: coinName,
                coinSym: coinSym,
              ),
            ),
          );
        });
  }

  void _showSellForm(num coinPrice, String coinName) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // color: Color.fromRGBO(11, 12, 54, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: StreamProvider<FbUser?>.value(
              value: Database().user,
              initialData: null,
              child: StreamUserCoins(
                coinVal: coinPrice,
                coinName: coinName,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Text(
              "Buy / Sell Crypto Currency",

              // style: Theme.of(context).textTheme.headline5,
              style:
                  TextStyle(color: Color.fromRGBO(11, 12, 54, 1), fontSize: 28),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          YMDcoinBuying(),
          Expanded(
            child: ListView.builder(
              itemExtent: 160,
              itemCount: widget.coins.length,
              itemBuilder: (context, index) {
                var coin = widget.coins[index];
                var coinPrice = coin.quoteModel.usdModel;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoinDetailScreen(coin: coin)),
                    );
                  },
                  child: Container(
                    height: 160.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CoinLogoWidget(coin: coin),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(11, 12, 54, 1),
                              elevation: 5,
                            ),
                            onPressed: () {
                              print(coinPrice.price);
                              print(coin.name);

                              _showBuyForm(
                                  coinPrice.price, coin.name, coin.symbol);
                            },
                            child: Text('Buy')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(11, 12, 54, 1),
                              elevation: 5,
                            ),
                            onPressed: () {
                              print(coinPrice.price);
                              print(coin.name);

                              _showSellForm(coinPrice.price, coin.name);
                            },
                            child: Text('Sell')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BuyCoins extends StatefulWidget {
  final num coinVal;
  final String coinName, coinSym;
  BuyCoins({
    Key? key,
    required this.coinVal,
    required this.coinName,
    required this.coinSym,
  }) : super(key: key);

  @override
  State<BuyCoins> createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoins> {
  double coins = 0;
  double total = 0;
  double value = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromRGBO(11, 12, 54, 1),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color.fromRGBO(11, 12, 54, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                'You are Buying ${widget.coinName}',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.grey,
                  onChanged: (val) {
                    setState(() {
                      coins = double.parse(val);

                      total = coins * widget.coinVal;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'How Many Coins?',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 6.0, top: 8.0),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Value in USD: ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '$total',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              loader
                  ? Loader2()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 5 // Background color
                          ),
                      onPressed: () async {
                        setState(() {
                          loader = true;
                        });
                        double walletBalance = 0;
                        setState(() {
                          value = coins * widget.coinVal;
                        });
                        final User? user = auth.currentUser;
                        final uid = user!.uid;
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .get()
                            .then((value) {
                          walletBalance = value.data()!['wallet'];
                        });
                        if (walletBalance < total) {
                          Fluttertoast.showToast(
                              msg:
                                  'You Dont Have Enough Balance in your wallet');
                          setState(() {
                            loader = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopUpWallet(uid: uid)));
                        } else {
                          setState(() {
                            loader = false;
                          });
                          await Database().buyCoins(widget.coinName, coins, uid,
                              total, widget.coinSym, value);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Buy',
                        style: TextStyle(
                            fontSize: 18, color: Color.fromRGBO(11, 12, 54, 1)),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
