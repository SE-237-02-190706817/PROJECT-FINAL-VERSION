import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_application/models/credit_card.dart';
import 'package:crypto_application/models/firebase%20models/coin_list.dart';
import 'package:crypto_application/models/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'models/user.dart';

class Database {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  FbUser? _userFromFirebase(User? user) {
    return user != null ? FbUser(uid: user.uid) : null;
  }

  //user stream
  Stream<FbUser?> get user {
    return auth.authStateChanges().map(_userFromFirebase);
  }

  //create user data
  createUserData(String name, email, phone, password) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String uid = value.user!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'wallet': 0.0,
        'reg_date': FieldValue.serverTimestamp()
      });
    });
  }

  //buying coins
  buyCoins(String coinName, double coins, String userId, double total,
      String coinSym, double value) async {
    //double walletBalance = 0;
    var coinIconUrl =
        "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/";

    final checkCoin = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('coins')
        .doc(coinName)
        .get();

    try {
      if (checkCoin.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .update({
          'coinName': coinName,
          'coins': FieldValue.increment(coins),
          'value': FieldValue.increment(value),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .set({
          'coinName': coinName,
          'coins': coins,
          'value': value,
          'coinSym': '${(coinIconUrl + coinSym).toLowerCase()}.png',
        });
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'wallet': FieldValue.increment(-total)});
      Fluttertoast.showToast(msg: 'You have Successfully Bought The Coins !!');
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'An Error has occured');
    }
  }

//selling coins
  sellCoins(
    String coinName,
    num coins,
    String userId,
    double total,
    double coinVal,
  ) async {
    num coinCount = 0;

    double newValue = 0;
    final checkCoin = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('coins')
        .doc(coinName)
        .get();

    try {
      if (checkCoin.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .update({
          'coinName': coinName,
          'coins': FieldValue.increment(-coins),
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({'wallet': FieldValue.increment(total)});
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .get()
            .then((value) {
          coinCount = value.data()!['coins'];
          newValue = coinCount * coinVal;
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .update({
          'value': newValue,
        });
        if (coinCount == 0) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('coins')
              .doc(coinName)
              .delete();
        } else {
          print('ok');
        }
        Fluttertoast.showToast(msg: 'Sold !!');
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'An Error has occured');
    }
  }

  List<CoinsFb> _coinsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CoinsFb(
        coinName: doc.data()['coinName'],
        coinCount: doc.data()['coins'],
        coinSym: doc.data()['coinSym'],
        coinValue: doc.data()['value'],
      );
    }).toList();
  }

  Stream<List<CoinsFb>> streamCoins(String uid) {
    return users.doc(uid).collection('coins').snapshots().map(_coinsList);
  }

  CoinsFb _coinData(DocumentSnapshot snapshot) {
    return CoinsFb(
      coinCount: snapshot.data()!['coins'],
      coinName: snapshot.data()!['coinName'],
      coinSym: snapshot.data()!['coinSym'],
      coinValue: snapshot.data()!['value'],
    );
  }

  Stream<CoinsFb> coinData(String uid, String coinName) {
    return users
        .doc(uid)
        .collection('coins')
        .doc(coinName)
        .snapshots()
        .map(_coinData);
  }

  UserData _userData(DocumentSnapshot snapshot) {
    return UserData(
      name: snapshot.data()!['name'],
      phone: snapshot.data()!['phone'],
      email: snapshot.data()!['email'],
      wallet: snapshot.data()!['wallet'].toDouble(),
    );
  }

  Stream<UserData> userData(String uid) {
    return users.doc(uid).snapshots().map(_userData);
  }

  signOut() async {
    await auth.signOut();
  }

  //save credit card
  saveCreditCard(String uid, String cardNum, String expDate, String cvv,
      String cardHolder) async {
    await users.doc(uid).collection('Credit Cards').add({
      'card_num': cardNum,
      'exp_date': expDate,
      'cvv': cvv,
      'card_holder': cardHolder,
    });
  }

  List<CreditCard> _creditCardList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CreditCard(
          cardHolder: doc.data()['card_holder'],
          cardNumber: doc.data()['card_num'],
          cvv: doc.data()['cvv'],
          expirydate: doc.data()['exp_date'],
          id: doc.id);
    }).toList();
  }

  Stream<List<CreditCard>> streamCreditCards(String uid) {
    return users
        .doc(uid)
        .collection('Credit Cards')
        .snapshots()
        .map(_creditCardList);
  }

  //top up wallet
  topUpWallet(String uid, double amount) async {
    await users.doc(uid).update({'wallet': FieldValue.increment(amount)});
  }

  //remove card
  removeCreditCard(String uid, String cardId) async {
    await users.doc(uid).collection('Credit Cards').doc(cardId).delete();
  }

  //send trade offer
  sendTradeOffer(
    String coinName1,
    String coinName2,
    double coinCount1,
    double coinCount2,
    String userId,
    String tradeEmail,
    String coinSymbol,
    String coinSymbol2,
  ) async {
    double checkCoin = 0;
    String secondUser = '';
    String tradeId = '';
    String senderEmail = '';
    try {
      await users.doc(userId).get().then((value) {
        senderEmail = value.data()!['email'];
      });
      await users
          .doc(userId)
          .collection('coins')
          .doc(coinName1)
          .get()
          .then((value) {
        checkCoin = value.data()!['coins'].toDouble();
      });
      final getSeconedUser =
          await users.where('email', isEqualTo: tradeEmail).get();
      getSeconedUser.docs.forEach((element) {
        secondUser = element.id;
        print('seconed user Id: $secondUser');
      });
      if (checkCoin < coinCount1) {
        Fluttertoast.showToast(msg: 'You dont Have Enough Coins');
      } else {
        await users.doc(userId).collection('Trades').add({
          'reciever': secondUser,
          'reciver_email': tradeEmail,
          'coin1': coinName1,
          'coinCoun1': coinCount1,
          'coin2': coinName2,
          'coinCount2': coinCount2,
          'status': 'Pending',
          'time_stamp': FieldValue.serverTimestamp(),
          'coin_sym': coinSymbol,
          'coin_sym2': coinSymbol2,
          'sender': userId,
          'accepted': false,
          'sender_email': senderEmail
        }).then((value) {
          tradeId = value.id;
        });
        await users
            .doc(userId)
            .collection('Trades')
            .doc(tradeId)
            .update({'tradeID': tradeId});
        if (getSeconedUser.docs.isEmpty) {
          Fluttertoast.showToast(msg: 'Wrong User Email');
        } else {
          await users.doc(secondUser).collection('Trades').add({
            'reciever': secondUser,
            'coin1': coinName1,
            'coinCoun1': coinCount1,
            'coin2': coinName2,
            'coinCount2': coinCount2,
            'status': 'Pending',
            'coin_sym': coinSymbol,
            'coin_sym2': coinSymbol2,
            'time_stamp': FieldValue.serverTimestamp(),
            'sender': userId,
            'accepted': false,
            'reciver_email': tradeEmail,
            'tradeID': tradeId,
            'sender_email': senderEmail
          });
        }

        Fluttertoast.showToast(
            msg: 'Trade Offer to $tradeEmail has been sent!');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //stream trades
  List<Trade> _tradesList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Trade(
        coinCount1: doc.data()['coinCoun1'].toDouble(),
        coinCount2: doc.data()['coinCount2'].toDouble(),
        coinName1: doc.data()['coin1'],
        coinName2: doc.data()['coin2'],
        status: doc.data()['status'],
        timestamp: doc.data()['time_stamp'],
        reciever: doc.data()['reciever'],
        sender: doc.data()['sender'],
        symbol1: doc.data()['coin_sym'],
        symbol2: doc.data()['coin_sym2'],
        accepted: doc.data()['accepted'],
        recieverEmail: doc.data()['reciver_email'],
        tradeId: doc.data()['tradeID'],
        senderEmail: doc.data()['sender_email'],
      );
    }).toList();
  }

  Stream<List<Trade>> streamTrade(String uid) {
    return users
        .doc(uid)
        .collection('Trades')
        .where('sender', isEqualTo: uid)
        .where('accepted', isEqualTo: false)
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map(_tradesList);
  }

  Stream<List<Trade>> streamTradeRec(String uid) {
    return users
        .doc(uid)
        .collection('Trades')
        .where('reciever', isEqualTo: uid)
        .orderBy('time_stamp', descending: true)
        .snapshots()
        .map(_tradesList);
  }

  //buying coins YMD
  buyCoinsYMD(String coinName, double coins, String userId, double total,
      String coinSym, double value) async {
    //double walletBalance = 0;

    final checkCoin = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('coins')
        .doc(coinName)
        .get();

    try {
      if (checkCoin.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .update({
          'coinName': coinName,
          'coins': FieldValue.increment(coins),
          'value': FieldValue.increment(value),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('coins')
            .doc(coinName)
            .set({
          'coinName': coinName,
          'coins': coins,
          'value': value,
          'coinSym': coinSym,
        });
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'wallet': FieldValue.increment(-total)});
      Fluttertoast.showToast(msg: 'You have Successfully Bought The Coins !!');
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'An Error has occured');
    }
  }

  //tradeAccepted
  tradeAccepted(
      String senderId,
      String recieverId,
      String tradeId,
      String coin1,
      String coin2,
      double coinCoun1,
      double coinCount2,
      coinSym1,
      coinSym2) async {
    try {
      final checkFirstCoin =
          await users.doc(recieverId).collection('coins').doc(coin2).get();
      final checkSeconedCoin =
          await users.doc(senderId).collection('coins').doc(coin1).get();

      if (checkFirstCoin.exists == false) {
        Fluttertoast.showToast(msg: 'You Dont Have $coin2 !');
      } else if (checkSeconedCoin.exists == false) {
        Fluttertoast.showToast(msg: 'The Other User Doesnt Have $coin1 !');
      } else {
        //coin2 is for sender
        double coin1oldValue = 0;
        double coin1oldCount = 0;
        double coin1SingleValue = 0;
        double coin1NewCount = 0;
        await users
            .doc(senderId)
            .collection('coins')
            .doc(coin1)
            .get()
            .then((value) {
          coin1oldValue = value.data()!['value'].toDouble();
          coin1oldCount = value.data()!['coins'].toDouble();
        });
        await users
            .doc(senderId)
            .collection('coins')
            .doc(coin1)
            .get()
            .then((value) {
          coin1NewCount = value.data()!['coins'].toDouble();
        });
        //decrement sender coins and value
        coin1SingleValue = coin1oldValue / coin1oldCount;
        await users.doc(senderId).collection('coins').doc(coin1).update({
          'coins': FieldValue.increment(-coinCoun1),
          'value': coin1SingleValue * coin1NewCount,
        });

        //coin1 is for reciever
        double coin2oldValue = 0;
        double coin2oldCount = 0;
        double coin2SingleValue = 0;
        double coin2NewCount = 0;
        await users
            .doc(recieverId)
            .collection('coins')
            .doc(coin2)
            .get()
            .then((value) {
          coin2oldValue = value.data()!['value'].toDouble();
          coin2oldCount = value.data()!['coins'].toDouble();
        });
        await users
            .doc(recieverId)
            .collection('coins')
            .doc(coin2)
            .get()
            .then((value) {
          coin2NewCount = value.data()!['coins'].toDouble();
        });
        //decrement reciever coins and value
        coin2SingleValue = coin2oldValue / coin2oldCount;
        await users.doc(recieverId).collection('coins').doc(coin2).update({
          'coins': FieldValue.increment(-coinCount2),
          'value': coin2SingleValue * coin2NewCount,
        });

        //add coins for sender
        final checkCoinForSender =
            await users.doc(senderId).collection('coins').doc(coin2).get();
        if (checkCoinForSender.exists) {
          await users.doc(senderId).collection('coins').doc(coin2).update({
            'coins': FieldValue.increment(coinCount2),
            'value': FieldValue.increment(coin2SingleValue * coinCount2)
          });
        } else {
          await users.doc(senderId).collection('coins').doc(coin2).set({
            'coins': coinCount2,
            'value': coin2SingleValue * coinCount2,
            'coinName': coin2,
            'coinSym': coinSym2
          });
        }
        //add coins for reciever
        final checkCoinForReciever =
            await users.doc(recieverId).collection('coins').doc(coin1).get();
        if (checkCoinForReciever.exists) {
          await users.doc(recieverId).collection('coins').doc(coin1).update({
            'coins': FieldValue.increment(coinCoun1),
            'value': FieldValue.increment(coin1SingleValue * coinCoun1)
          });
        } else {
          await users.doc(recieverId).collection('coins').doc(coin1).set({
            'coins': coinCoun1,
            'value': coin1SingleValue * coinCoun1,
            'coinName': coin1,
            'coinSym': coinSym1
          });
        }

        //update trade page for reciever
        String recieverTradeNo = '';
        await users
            .doc(recieverId)
            .collection('Trades')
            .where('tradeID', isEqualTo: tradeId)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            recieverTradeNo = element.id;
          });
        });
        await users
            .doc(recieverId)
            .collection('Trades')
            .doc(recieverTradeNo)
            .update({
          'status': 'Accepted',
          'accepted': true,
        });
        Fluttertoast.showToast(msg: 'Trade is Successfull');
      }
    } catch (e) {
      print(e.toString());

      Fluttertoast.showToast(msg: 'database function:${e.toString()}');
    }
  }

  //decline trade
  declineTrade(String senderId, recieverId, tradeId) async {
    String senderTradeId = '';
    String recieverTradeId = '';
    try {
      await users
          .doc(senderId)
          .collection('Trades')
          .where('tradeID', isEqualTo: tradeId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          senderTradeId = element.id;
        });
      });
      await users
          .doc(recieverId)
          .collection('Trades')
          .where('tradeID', isEqualTo: tradeId)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          recieverTradeId = element.id;
        });
      });
      await users
          .doc(senderId)
          .collection('Trades')
          .doc(senderTradeId)
          .update({'status': 'Declined', 'accepted': true});

      await users
          .doc(recieverId)
          .collection('Trades')
          .doc(recieverTradeId)
          .update({'status': 'Declined', 'accepted': true});
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
