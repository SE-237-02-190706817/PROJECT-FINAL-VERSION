import 'package:flutter/material.dart';

class Loader2 extends StatefulWidget {
  const Loader2({Key? key}) : super(key: key);

  @override
  State<Loader2> createState() => _Loader2State();
}

class _Loader2State extends State<Loader2> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Please Wait....',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 15),
          Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          )
        ]),
      ),
    );
  }
}
