import 'package:cloud_firestore/cloud_firestore.dart';

class Trade {
  String coinName1 = '',
      coinName2 = '',
      reciever = '',
      status = '',
      sender = '',
      symbol1 = '',
      symbol2 = '',
      recieverEmail = '',
      senderEmail = '';
  double coinCount1 = 0, coinCount2 = 0;
  late Timestamp timestamp;
  String tradeId = '';
  bool accepted = false;
  Trade(
      {required this.coinCount1,
      required this.coinCount2,
      required this.coinName1,
      required this.coinName2,
      required this.status,
      required this.timestamp,
      required this.reciever,
      required this.accepted,
      required this.sender,
      required this.symbol1,
      required this.symbol2,
      required this.recieverEmail,
      required this.tradeId,
      required this.senderEmail});
}
