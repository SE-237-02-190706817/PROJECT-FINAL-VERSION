import 'package:crypto_application/data_base.dart';
import 'package:crypto_application/widgets/ymd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../models/chart_data_model.dart';
import '../models/fetchCoins_models/big_data_model.dart';
import '../models/fetchCoins_models/data_model.dart';
import '../models/trade.dart';
import '../repository/repository.dart';
import '../streams/stream_trades.dart';
import '../widgets/coin_chart_widget.dart';
import '../widgets/coin_logo_widget.dart';
import '../widgets/loader2.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(11, 12, 54, 1),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, TradeSc.id);
                  },
                  child: Text(
                    'Trade',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(11, 12, 54, 1),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SwitchTrade())));
                  },
                  child: Text(
                    'Trade Offers',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}

class TradeSc extends StatefulWidget {
  static String id = 'tradeSc';

  TradeSc({Key? key}) : super(key: key);

  @override
  State<TradeSc> createState() => _TradeScState();
}

class _TradeScState extends State<TradeSc> {
  String userEmail = '';
  String selectedCoin1 = 'Select Coin';
  String selectedCoin2 = 'Select Coin';
  String coinSym = '';
  String coinSym2 = '';

  double firstCoin = 0, seconedCoin = 0;

  void _showSelect1() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            //color: Color.fromRGBO(11, 12, 54, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SelectCoin1(
              selectFirstCoin: selectFirstCoin,
            ),
          );
        });
  }

  void _showSelect2() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            //color: Color.fromRGBO(11, 12, 54, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SelectCoin2(
              selectSeconedCoin: selectSeconedCoin,
            ),
          );
        });
  }

  selectFirstCoin(String coinName, String coinSymbol) {
    setState(() {
      selectedCoin1 = coinName;
      coinSym = coinSymbol;
    });
  }

  selectSeconedCoin(String coinName, String coinSymbol2) {
    setState(() {
      selectedCoin2 = coinName;
      coinSym2 = coinSymbol2;
    });
  }

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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(11, 12, 54, 1), title: Text('Trade')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.grey,
                onChanged: (val) {
                  userEmail = val;
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.toString().contains("@")) {
                    return 'Please enter a Vaild Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'User Email you wish to trade with',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
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
            ElevatedButton(
                onPressed: () {
                  _showSelect1();
                },
                child: Text('Trading: $selectedCoin1')),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                onChanged: (val) {
                  firstCoin = double.parse(val);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'How Many Coins You Want to Trade ?',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
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
            ElevatedButton(
                onPressed: () {
                  _showSelect2();
                },
                child: Text('With: $selectedCoin2')),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                onChanged: (val) {
                  seconedCoin = double.parse(val);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'How Many Coins You Want to Get ?',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
              onPressed: () async {
                try {
                  await Database().sendTradeOffer(
                      selectedCoin1,
                      selectedCoin2,
                      firstCoin,
                      seconedCoin,
                      uid,
                      userEmail,
                      coinSym,
                      coinSym2);
                  Navigator.pop(context);
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              child: Text(
                'Send Trade Offer',
                style: TextStyle(fontSize: 16),
              ))),
    );
  }
}

class SelectCoin1 extends StatefulWidget {
  final selectFirstCoin;
  const SelectCoin1({Key? key, required this.selectFirstCoin})
      : super(key: key);

  @override
  State<SelectCoin1> createState() => _SelectCoin1State();
}

class _SelectCoin1State extends State<SelectCoin1> {
  late Future<BigDataModel> _futureCoins;
  late Repository repository;
  @override
  void initState() {
    repository = Repository();
    _futureCoins = repository.getCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BigDataModel>(
      future: _futureCoins,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var coinsData = snapshot.data!.dataModel;
            return CoinListForTrade(
              coins: coinsData,
              selectCoin: widget.selectFirstCoin,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class SelectCoin2 extends StatefulWidget {
  final selectSeconedCoin;
  const SelectCoin2({Key? key, required this.selectSeconedCoin})
      : super(key: key);

  @override
  State<SelectCoin2> createState() => _SelectCoin2State();
}

class _SelectCoin2State extends State<SelectCoin2> {
  late Future<BigDataModel> _futureCoins;
  late Repository repository;
  @override
  void initState() {
    repository = Repository();
    _futureCoins = repository.getCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BigDataModel>(
      future: _futureCoins,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var coinsData = snapshot.data!.dataModel;
            return CoinListForTrade(
              coins: coinsData,
              selectCoin: widget.selectSeconedCoin,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

//select coin
class CoinListForTrade extends StatefulWidget {
  final List<DataModel> coins;
  final selectCoin;
  const CoinListForTrade(
      {Key? key, required this.coins, required this.selectCoin})
      : super(key: key);

  @override
  State<CoinListForTrade> createState() => _CoinListForTradeState();
}

class _CoinListForTradeState extends State<CoinListForTrade> {
  var coinIconUrl =
      "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YMDcoinTrade(selectCoin: widget.selectCoin),
        Expanded(
          child: ListView.builder(
            itemExtent: 160,
            itemCount: widget.coins.length,
            itemBuilder: (context, index) {
              var coin = widget.coins[index];
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
                  widget.selectCoin(widget.coins[index].name,
                      '${(coinIconUrl + widget.coins[index].symbol).toLowerCase()}.png');
                  Navigator.pop(context);
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
    );
  }
}

class SwitchTrade extends StatefulWidget {
  const SwitchTrade({Key? key}) : super(key: key);

  @override
  State<SwitchTrade> createState() => _SwitchTradeState();
}

class _SwitchTradeState extends State<SwitchTrade>
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
        title: TabBar(
          controller: _tabController,
          tabs: [
            Text(
              'Sent',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Recieved',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        StreamTrades(),
        StreamRecieved(),
      ]),
    );
  }
}

class TradeOffers extends StatefulWidget {
  TradeOffers({Key? key}) : super(key: key);

  @override
  State<TradeOffers> createState() => _TradeOffersState();
}

class _TradeOffersState extends State<TradeOffers> {
  @override
  Widget build(BuildContext context) {
    final trade = Provider.of<List<Trade>>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: trade.length,
        itemBuilder: (context, i) {
          DateTime dateTime = trade[i].timestamp.toDate();

          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sent To: ${trade[i].recieverEmail}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          trade[i].symbol1,
                          height: 30,
                          width: 30,
                        ),
                        Text(
                          '${trade[i].coinName1} ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          trade[i].coinCount1.toString() + ' Coins',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 35,
                      color: Color.fromRGBO(11, 12, 54, 1),
                    ),
                    Row(
                      children: [
                        Image.network(
                          trade[i].symbol2,
                          height: 30,
                          width: 30,
                        ),
                        Text(
                          '${trade[i].coinName2} ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          trade[i].coinCount2.toString() + ' Coins',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Status: ${trade[i].status}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class TradeOffersRec extends StatefulWidget {
  TradeOffersRec({Key? key}) : super(key: key);

  @override
  State<TradeOffersRec> createState() => _TradeOffersRec();
}

class _TradeOffersRec extends State<TradeOffersRec> {
  bool checkAccept = true;
  checkAccepted(bool check) {
    if (check == true) {
      checkAccept = false;
    } else {
      checkAccept = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trade = Provider.of<List<Trade>>(context);
    bool loader = false;
    return Scaffold(
      body: ListView.builder(
        itemCount: trade.length,
        itemBuilder: (context, i) {
          DateTime dateTime = trade[i].timestamp.toDate();
          checkAccepted(trade[i].accepted);
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recieved From: ${trade[i].senderEmail}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          trade[i].symbol1,
                          height: 30,
                          width: 30,
                        ),
                        Text(
                          '${trade[i].coinName1} ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          trade[i].coinCount1.toString() + ' Coins',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 35,
                      color: Color.fromRGBO(11, 12, 54, 1),
                    ),
                    Row(
                      children: [
                        Image.network(
                          trade[i].symbol2,
                          height: 30,
                          width: 30,
                        ),
                        Text(
                          '${trade[i].coinName2} ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          trade[i].coinCount2.toString() + ' Coins',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Status: ${trade[i].status}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                loader
                    ? Loader2()
                    : Visibility(
                        visible: checkAccept,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Material(
                                color: Color.fromRGBO(11, 12, 54, 1),
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                child: MaterialButton(
                                  onPressed: () async {
                                    setState(() {
                                      loader = true;
                                    });
                                    try {
                                      await Database().tradeAccepted(
                                          trade[i].sender,
                                          trade[i].reciever,
                                          trade[i].tradeId,
                                          trade[i].coinName1,
                                          trade[i].coinName2,
                                          trade[i].coinCount1,
                                          trade[i].coinCount2,
                                          trade[i].symbol1,
                                          trade[i].symbol2);
                                      setState(() {
                                        loader = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        loader = false;
                                      });
                                      Fluttertoast.showToast(msg: e.toString());
                                    }
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Material(
                                color: Color.fromRGBO(11, 12, 54, 1),
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                child: MaterialButton(
                                  onPressed: () async {
                                    setState(() {
                                      loader = true;
                                    });
                                    await Database().declineTrade(
                                        trade[i].sender,
                                        trade[i].reciever,
                                        trade[i].tradeId);
                                    setState(() {
                                      loader = false;
                                    });
                                  },
                                  child: const Text(
                                    'Decline',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ]),
            ),
          );
        },
      ),
    );
  }
}
