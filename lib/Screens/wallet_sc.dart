import 'package:crypto_application/Screens/top_up_wallet.dart';
import 'package:crypto_application/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data_base.dart';
import 'third_scree.dart';

class Wallet extends StatefulWidget {
  Wallet({Key? key}) : super(key: key);
  static String id = 'wallet';

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
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
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
        title: Text('Wallet'),
      ),
      body: ListView(
        children: [
          StreamBuilder<UserData>(
              stream: Database().userData(uid),
              builder: (context, snapshot) {
                UserData? userData = snapshot.data;
                if (snapshot.hasData) {
                  return Card(
                    color: Color.fromRGBO(11, 12, 54, 1),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Wallet Balance',
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              '${userData!.wallet} \$',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          Divider(
            color: Color.fromRGBO(11, 12, 54, 1),
          ),
          Text(
            'Owned Crypto Currencies',
            style:
                TextStyle(fontSize: 24, color: Color.fromRGBO(11, 12, 54, 1)),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            color: Color.fromRGBO(11, 12, 54, 1),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamOwnedCoins(
                uid: uid,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(11, 12, 54, 1),
        child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TopUpWallet(uid: uid)));
            },
            child: Text('Top up',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ))),
      ),
    );
  }
}
