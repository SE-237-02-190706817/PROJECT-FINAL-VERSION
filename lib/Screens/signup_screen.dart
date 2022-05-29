import 'package:crypto_application/data_base.dart';
import 'package:crypto_application/widgets/loader2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'my_home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String id = 'SignupScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = '';
  String name = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //  backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(11, 12, 54, 1),
        centerTitle: true,
        title: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/images/crypto.png',
                  height: 150,
                  width: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.grey,
                  onChanged: (val) {
                    email = val;
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
                      hintText: 'Email',
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
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.grey,
                  onChanged: (val) {
                    name = val;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
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
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.grey,
                  onChanged: (val) {
                    phone = val;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Phone Number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone',
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
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    obscureText: true,
                    cursorColor: Colors.grey,
                    style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                    onChanged: (val) {
                      password = val;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Vaild Password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
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
                  )),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    style: TextStyle(color: Color.fromRGBO(11, 12, 54, 1)),
                    obscureText: true,
                    cursorColor: Colors.grey,
                    onChanged: (val) {
                      confirmPassword = val;
                    },
                    validator: (v) =>
                        v == password ? null : "Password not match",
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
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
                  )),
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
                              await Database()
                                  .createUserData(name, email, phone, password);
                              setState(() {
                                loader = false;
                              });
                              Navigator.pushNamed(context, MyHomeScreen.id);
                            } catch (e) {
                              setState(() {
                                loader = false;
                              });
                              Fluttertoast.showToast(msg: e.toString());
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width / 1.5,
                          height: 42.0,
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),

                            ////////
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
