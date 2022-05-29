import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_application/Screens/login_screen.dart';
import 'package:crypto_application/Screens/wallet_sc.dart';
import 'package:crypto_application/models/firebase%20models/coin_list.dart';
import 'package:crypto_application/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../data_base.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
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
        elevation: 5,
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
        title: Text(
          "",
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
      backgroundColor: Colors.white,
      body: StreamBuilder<UserData>(
          stream: Database().userData(uid),
          builder: (context, snapshot) {
            UserData? userData = snapshot.data;
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 28, color: Color.fromRGBO(11, 12, 54, 1)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Color.fromRGBO(11, 12, 54, 1),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Name: ${userData!.name}',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.mobile_friendly_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Phone: ${userData.phone}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.email_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Email: ${userData.email}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Color.fromRGBO(11, 12, 54, 1),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(11, 12, 54, 1),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          await Database().signOut();
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text('Logout',
                            style: TextStyle(
                              color: Colors.white,
                            )))
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class StreamOwnedCoins extends StatefulWidget {
  final String uid;
  StreamOwnedCoins({Key? key, required this.uid}) : super(key: key);

  @override
  State<StreamOwnedCoins> createState() => _StreamOwnedCoinsState();
}

class _StreamOwnedCoinsState extends State<StreamOwnedCoins> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CoinsFb>>.value(
      value: Database().streamCoins(widget.uid),
      initialData: [],
      child: OwnedCoins(),
    );
  }
}

class OwnedCoins extends StatefulWidget {
  const OwnedCoins({Key? key}) : super(key: key);

  @override
  State<OwnedCoins> createState() => _OwnedCoinsState();
}

class _OwnedCoinsState extends State<OwnedCoins> {
  @override
  Widget build(BuildContext context) {
    final coinsFb = Provider.of<List<CoinsFb>>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: coinsFb.length,
      itemBuilder: (context, i) {
        return Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 30.0,
                width: 30.0,
                child: CachedNetworkImage(
                  imageUrl: (coinsFb[i].coinSym),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      SvgPicture.asset('assets/icons/dollar.svg'),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              coinsFb[i].coinName,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '  ${coinsFb[i].coinCount.toString()} Coins',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '  ${coinsFb[i].coinValue} \$',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        );
      },
    );
  }
}
