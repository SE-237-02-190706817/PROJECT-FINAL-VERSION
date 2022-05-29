import 'package:crypto_application/Screens/my_home_screen.dart';
import 'package:crypto_application/Screens/signup_screen.dart';
import 'package:crypto_application/widgets/loader2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'loginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _key,
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
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            title: Center(
                                child: Text(
                              'Welcome',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            )),
                            subtitle: Center(
                                child: Text(
                              "Login to get started and \n experience great deals",
                              style: TextStyle(
                                  color: Color.fromRGBO(11, 12, 54, 1)),
                            )),
                          ),
                        ),
                        loader
                            ? Loader2()
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Color.fromRGBO(11, 12, 54, 1)),
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
                                              left: 14.0,
                                              bottom: 6.0,
                                              top: 8.0),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        obscureText: true,
                                        cursorColor: Colors.grey,
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
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 14.0,
                                                    bottom: 6.0,
                                                    top: 8.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Don\'t have an account? ',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(11, 12, 54, 1)),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, SignUpScreen.id);
                                          },
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    11, 12, 54, 1),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
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
                                            await _auth
                                                .signInWithEmailAndPassword(
                                                    email: email,
                                                    password: password);
                                            setState(() {
                                              loader = false;
                                            });
                                            Navigator.pushNamed(
                                                context, MyHomeScreen.id);
                                          } catch (e) {
                                            setState(() {
                                              loader = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: e.toString());
                                          }
                                        },
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height: 42.0,
                                        child: const Text(
                                          'Login',
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
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
