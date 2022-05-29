import 'package:crypto_application/data_base.dart';
import 'package:crypto_application/models/credit_card.dart';
import 'package:crypto_application/widgets/loader2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TopUpWallet extends StatefulWidget {
  final String uid;
  TopUpWallet({Key? key, required this.uid}) : super(key: key);
  static String id = 'top_up';

  @override
  State<TopUpWallet> createState() => _TopUpWalletState();
}

class _TopUpWalletState extends State<TopUpWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
        title: Text('Top Up'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewCard(uid: widget.uid)));
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: StreamProvider<List<CreditCard>>.value(
        value: Database().streamCreditCards(widget.uid),
        initialData: [],
        child: SelectCreditCard(
          uid: widget.uid,
        ),
      ),
    );
  }
}

class SelectCreditCard extends StatefulWidget {
  final String uid;
  const SelectCreditCard({Key? key, required this.uid}) : super(key: key);

  @override
  State<SelectCreditCard> createState() => _SelectCreditCardState();
}

class _SelectCreditCardState extends State<SelectCreditCard> {
  void _topUp(String uid, String cardHolder, String cardNum) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // color: Color.fromRGBO(11, 12, 54, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: AddBalanceToUrWallet(
                cardHolder: cardHolder, cardNum: cardNum, uid: uid),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final creditCardinf = Provider.of<List<CreditCard>>(context);
    return ListView.builder(
        itemCount: creditCardinf.length,
        itemBuilder: ((context, i) {
          if (creditCardinf.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Card(
              child: Column(
                children: [
                  CreditCardWidget(
                    isHolderNameVisible: true,
                    cardNumber: creditCardinf[i].cardNumber,
                    expiryDate: creditCardinf[i].expirydate,
                    cardHolderName: creditCardinf[i].cardHolder,
                    cvvCode: creditCardinf[i].cvv,
                    showBackView: false,
                    onCreditCardWidgetChange: (creditCardBrand) {},
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              await Database().removeCreditCard(
                                  widget.uid, creditCardinf[i].id);
                              Fluttertoast.showToast(
                                  msg: 'Card Has Been Removed!');
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                            }
                          },
                          child: Text('Remove')),
                      ElevatedButton(
                          onPressed: () {
                            _topUp(widget.uid, creditCardinf[i].cardHolder,
                                creditCardinf[i].cardNumber);
                          },
                          child: Text('Use This Card')),
                    ],
                  )
                ],
              ),
            );
          }
        }));
  }
}

class AddBalanceToUrWallet extends StatefulWidget {
  final String uid, cardHolder, cardNum;
  AddBalanceToUrWallet(
      {Key? key,
      required this.cardHolder,
      required this.cardNum,
      required this.uid})
      : super(key: key);

  @override
  State<AddBalanceToUrWallet> createState() => _AddBalanceToUrWalletState();
}

class _AddBalanceToUrWalletState extends State<AddBalanceToUrWallet> {
  double amount = 0;
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Card Number: ${widget.cardNum}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Card Holder: ${widget.cardHolder}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
            keyboardType: TextInputType.number,
            cursorColor: Colors.grey,
            maxLength: 9,
            onChanged: (val) {
              setState(() {
                amount = double.parse(val);
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
                hintText: 'Amount in \$',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
          height: 30,
        ),
        loader
            ? Loader2()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                        await Database().topUpWallet(widget.uid, amount);
                        Fluttertoast.showToast(
                            msg: '$amount \$ has been added to your account');
                        setState(() {
                          loader = true;
                        });
                        Navigator.pop(context);
                      } catch (e) {
                        setState(() {
                          loader = true;
                        });
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    minWidth: MediaQuery.of(context).size.width / 1.5,
                    height: 42.0,
                    child: const Text(
                      'Top Up',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      ////////
                    ),
                  ),
                ),
              ),
      ]),
    );
  }
}

class AddNewCard extends StatefulWidget {
  final String uid;
  AddNewCard({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  String cardNumber = '', expiryDate = '', cardHolderName = '', cvvCode = '';
  bool isCvvFocused = false;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            isHolderNameVisible: true,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            onCreditCardWidgetChange: (creditCardBrand) {},
          ),
          SizedBox(
            height: 10,
          ),
          CreditCardForm(
              formKey: _key, // Required
              onCreditCardModelChange: onCreditCardModelChange, // Required
              themeColor: Colors.red,
              obscureCvv: true,
              obscureNumber: false,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              cardNumberDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expired Date',
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Holder',
              ),
              cardHolderName: cardHolderName,
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              expiryDate: expiryDate),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(11, 12, 54, 1),
        child: TextButton(
          child: Text(
            'Add Card',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () async {
            try {
              await Database().saveCreditCard(
                  widget.uid, cardNumber, expiryDate, cvvCode, cardHolderName);
              Fluttertoast.showToast(msg: 'Your Card has been Save');
              Navigator.pop(context);
            } catch (e) {
              Fluttertoast.showToast(msg: e.toString());
            }
          },
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
