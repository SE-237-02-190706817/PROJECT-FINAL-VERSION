import 'package:crypto_application/data_base.dart';
import 'package:crypto_application/models/firebase%20models/coin_list.dart';
import 'package:crypto_application/widgets/loader2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StreamUserCoins extends StatefulWidget {
  final num coinVal;
  final String coinName;
  StreamUserCoins({Key? key, required this.coinVal, required this.coinName})
      : super(key: key);

  @override
  State<StreamUserCoins> createState() => _StreamUserCoinsState();
}

class _StreamUserCoinsState extends State<StreamUserCoins> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  @override
  void initState() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    super.initState();
  }

  double coinToSell = 0;
  double total = 0;
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoinsFb>(
        stream: Database().coinData(uid, widget.coinName),
        builder: (context, snapshot) {
          CoinsFb? coinsFb = snapshot.data;
          if (snapshot.hasData) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              color: Color.fromRGBO(11, 12, 54, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Text(
                            'You Have  ',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            '${coinsFb!.coinCount}  ',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            coinsFb.coinName,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Value:  ',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            '${widget.coinVal} USD',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          style:
                              TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey,
                          onChanged: (val) {
                            setState(() {
                              coinToSell = double.parse(val);
                              total = coinToSell * widget.coinVal;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Value';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'How Many Coins?',
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
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
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
                      SizedBox(
                        height: 100,
                      ),
                      loader
                          ? Loader2()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 5,
                              ),
                              onPressed: () async {
                                setState(() {
                                  loader = true;
                                });
                                final User? user = auth.currentUser;
                                final uid = user!.uid;
                                await Database().sellCoins(
                                    widget.coinName,
                                    coinToSell,
                                    uid,
                                    total,
                                    widget.coinVal.toDouble());
                                setState(() {
                                  loader = false;
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sell',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(11, 12, 54, 1)),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text('You dont own this Coin',
                style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)));
          }
        });
  }
}
