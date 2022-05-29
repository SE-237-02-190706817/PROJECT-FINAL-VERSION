import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StaticVals {
  // static String jwt = "";
  // static String userName = '';
  // static String loggedInEmail = '';
  // static String userId = '';
  // static String profileImage = '';
  // static int userTypeId = 0;
  // static int userBranchId = 0;
  // static String firstName = "";
  // static String lastName = "";
  // static String firstNameAr = "";
  // static String lastNameAr = "";
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeBounce(
      color: Color(0XFFFA4248),
      size: 50.0,
    );
  }
}
