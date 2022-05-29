import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_application/widgets/sliver_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Screens/top_up_wallet.dart';
import '../data_base.dart';
import '../models/chart_data_model.dart';
import '../models/user.dart';
import '../streams/stream_user_coins.dart';

class YMDcoin extends StatelessWidget {
  YMDcoin({Key? key}) : super(key: key);
  final data = [
    ChartData(1, 2160),
    ChartData(1, 1440),
    ChartData(1, 720),
    ChartData(1, 24),
    ChartData(1, 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => YMDdetails()),
            );
          },
          child: Container(
            height: 160.0,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  height: 96.0,
                  width: 96.0,
                  //78 Remaining
                  child: Column(
                    children: [
                      Container(
                          height: 50.0,
                          width: 50.0,
                          child: Image.asset('assets/images/chinese-coin.png')),
                      const SizedBox(height: 4.0),
                      Text(
                        'YMD',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        "\$" + '1',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                CoinChartWidgetYMDd(
                  color: Colors.grey,
                  data: data,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class YMDdetails extends StatelessWidget {
  const YMDdetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int next(int min, int max) => random.nextInt(max - min);
    DateTime dateTime;
    dateTime = DateTime.now();

    String formatDate =
        '${dateTime.day}/${dateTime.month}/${dateTime.year}   ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';

    var data = [
      ChartData(next(110, 140), 1),
      ChartData(next(9, 41), 2),
      ChartData(next(140, 200), 3),
      ChartData(1, 4),
      ChartData(1, 5),
      ChartData(next(110, 140), 6),
      ChartData(next(9, 41), 7),
      ChartData(next(140, 200), 8),
      ChartData(1, 9),
      ChartData(1, 10),
      ChartData(next(110, 140), 12),
      ChartData(next(9, 41), 13),
      ChartData(1, 14),
      ChartData(next(9, 41), 15),
      ChartData(next(140, 200), 16),
      ChartData(1, 17),
      ChartData(1, 18),
      ChartData(next(110, 140), 19),
      ChartData(next(9, 41), 20),
      ChartData(next(140, 200), 21),
      ChartData(1, 22),
      ChartData(next(110, 140), 23),
    ];

    return Scaffold(
      // backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0)),
            pinned: true,
            snap: true,
            floating: true,
            backgroundColor: Color.fromRGBO(11, 12, 54, 1),
            expandedHeight: 280.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 4.4, 0.0),
                width: double.infinity,
                height: 56.0,
                child: ListTile(
                  title: Text(
                    'YMD Yousef Mohammad Dania',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // subtitle: Text(coin.slug),
                ),
              ),
              background: Image.asset('assets/images/chinese-coin.png'),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          YMDcoinChart(outputDate: formatDate, data: data),
          SliverToBoxAdapter(
            child: Container(
              height: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 400.0,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Circulating Supply: ",
                              // style: Theme.of(context).textTheme.subtitle1,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                            Text(
                              '0',
                              // style: Theme.of(context).textTheme.headline6,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Max Supply: ",
                              // style: Theme.of(context).textTheme.subtitle1,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                            Text(
                              '50000000',
                              // style: Theme.of(context).textTheme.headline6,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Market pairs: ",
                              // style: Theme.of(context).textTheme.subtitle1,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                            Text(
                              '0',
                              // style: Theme.of(context).textTheme.headline6,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Market Cap: ",
                              // style: Theme.of(context).textTheme.subtitle1,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                            Text(
                              '0',
                              // style: Theme.of(context).textTheme.headline6,
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class YMDcoinChart extends StatelessWidget {
  final String outputDate;
  final List<ChartData> data;
  const YMDcoinChart({Key? key, required this.outputDate, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 360.0,
        maxHeight: 360.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            children: [
              Text(
                '\$' '1',
                // style: Theme.of(context).textTheme.headline4,
                style: TextStyle(
                    color: Color.fromRGBO(11, 12, 54, 1), fontSize: 27),
              ),
              Text(
                outputDate,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              CoinChartWidgetYMD(color: Colors.green, data: data),
              const SizedBox(height: 8.0)
            ],
          ),
        ),
      ),
    );
  }
}

class CoinChartWidgetYMD extends StatelessWidget {
  const CoinChartWidgetYMD({
    Key? key,
    required this.data,
    required this.color,
  }) : super(key: key);

  final List<ChartData> data;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0),
            height: 96.0,
            width: double.infinity,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(isVisible: false),
              primaryYAxis: CategoryAxis(isVisible: false),
              legend: Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: false),
              series: <ChartSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData sales, _) => sales.year.toString(),
                  yValueMapper: (ChartData sales, _) => sales.value,
                ),
              ],
            ),
          ),
        ),
        color == Colors.green
            ? Container()
            : Container(
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.only(right: 16.0),
                alignment: Alignment.center,
                width: 72,
                height: 36,
                decoration: BoxDecoration(
                    color: 1 >= 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Text(
                  '1' + "%",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
      ],
    );
  }
}

class CoinChartWidgetYMDd extends StatelessWidget {
  const CoinChartWidgetYMDd({
    Key? key,
    required this.data,
    required this.color,
  }) : super(key: key);

  final List<ChartData> data;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0),
              height: 96.0,
              width: double.infinity,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(isVisible: false),
                primaryYAxis: CategoryAxis(isVisible: false),
                legend: Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: false),
                series: <ChartSeries<ChartData, String>>[
                  LineSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData sales, _) => sales.year.toString(),
                    yValueMapper: (ChartData sales, _) => sales.value,
                  ),
                ],
              ),
            ),
          ),
          color == Colors.green
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(right: 16.0),
                  alignment: Alignment.center,
                  width: 72,
                  height: 36,
                  decoration: BoxDecoration(
                      color: 1 >= 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Text(
                    '1' + "%",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }
}

class YMDcoinBuying extends StatefulWidget {
  YMDcoinBuying({Key? key}) : super(key: key);

  @override
  State<YMDcoinBuying> createState() => _YMDcoinBuyingState();
}

class _YMDcoinBuyingState extends State<YMDcoinBuying> {
  String coinName = 'YMD';

  double coinVal = 1;

  String coinImage =
      'https://firebasestorage.googleapis.com/v0/b/crypto-e952a.appspot.com/o/chinese-coin.png?alt=media&token=c4202f3b-4535-443c-bf91-16547daf197a';

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
              child: BuyCoinsYMD(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.6),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16.0),
                height: 96.0,
                width: 96.0,
                //78 Remaining
                child: Column(
                  children: [
                    Container(
                        height: 50.0,
                        width: 50.0,
                        child: Image.asset('assets/images/chinese-coin.png')),
                    const SizedBox(height: 4.0),
                    Text(
                      'YMD',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "\$" + '1',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(11, 12, 54, 1),
                    elevation: 5,
                  ),
                  onPressed: () {
                    _showBuyForm(coinVal, coinName, coinImage);
                  },
                  child: Text('Buy')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(11, 12, 54, 1),
                    elevation: 5,
                  ),
                  onPressed: () {
                    _showSellForm(coinVal, coinName);
                  },
                  child: Text('Sell')),
            ],
          ),
        ),
      ],
    );
  }
}

class BuyCoinsYMD extends StatefulWidget {
  final num coinVal;
  final String coinName, coinSym;
  BuyCoinsYMD({
    Key? key,
    required this.coinVal,
    required this.coinName,
    required this.coinSym,
  }) : super(key: key);

  @override
  State<BuyCoinsYMD> createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoinsYMD> {
  double coins = 0;
  double total = 0;
  double value = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 5 // Background color
                    ),
                onPressed: () async {
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
                        msg: 'You Dont Have Enough Balance in your wallet');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpWallet(uid: uid)));
                  } else {
                    await Database().buyCoinsYMD(widget.coinName, coins, uid,
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

class YMDcoinTrade extends StatefulWidget {
  final selectCoin;

  YMDcoinTrade({Key? key, required this.selectCoin}) : super(key: key);

  @override
  State<YMDcoinTrade> createState() => _YMDcoinTradeState();
}

class _YMDcoinTradeState extends State<YMDcoinTrade> {
  final data = [
    ChartData(1, 2160),
    ChartData(1, 1440),
    ChartData(1, 720),
    ChartData(1, 24),
    ChartData(1, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            widget.selectCoin('YMD',
                'https://firebasestorage.googleapis.com/v0/b/crypto-e952a.appspot.com/o/chinese-coin.png?alt=media&token=c4202f3b-4535-443c-bf91-16547daf197a');
            Navigator.pop(context);
          },
          child: Container(
            height: 160.0,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  height: 96.0,
                  width: 96.0,
                  //78 Remaining
                  child: Column(
                    children: [
                      Container(
                          height: 50.0,
                          width: 50.0,
                          child: Image.asset('assets/images/chinese-coin.png')),
                      const SizedBox(height: 4.0),
                      Text(
                        'YMD',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        "\$" + '1',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                CoinChartWidgetYMDd(
                  color: Colors.grey,
                  data: data,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
