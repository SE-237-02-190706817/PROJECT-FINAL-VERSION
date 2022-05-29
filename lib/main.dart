import 'package:colours/colours.dart';
import 'package:crypto_application/Screens/login_screen.dart';
import 'package:crypto_application/Screens/my_home_screen.dart';
import 'package:crypto_application/Screens/signup_screen.dart';
import 'package:crypto_application/Screens/trade_Screen.dart';
import 'package:crypto_application/Screens/wallet_sc.dart';
import 'package:crypto_application/data_base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';

//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
//import 'Localizaion/localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
// static void setLocale(BuildContext context, Locale locale) {
//   _MyAppState? state = context.findRootAncestorStateOfType<_MyAppState>();
//   state!.setLocale(locale);
// }
}

class _MyAppState extends State<MyApp> {
  // late Locale _locale = Locale('ar', 'JO');
  //
  // void setLocale(Locale locale) {
  //   setState(() {
  //     _locale = locale;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FbUser?>.value(
      value: Database().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(11, 12, 54, 1),
          primarySwatch: Colours.purple,
          fontFamily: 'SourceSansPro',
        ),

        // locale: _locale,
        //  supportedLocales: [
        //    Locale('ar', 'JO'),
        //    Locale('en', 'US'),
        //  ],
        //  localizationsDelegates: [
        //    GlobalMaterialLocalizations.delegate,
        //    GlobalWidgetsLocalizations.delegate,
        //    GlobalCupertinoLocalizations.delegate,
        //    AppLocalization.delegate,
        //  ],
        //  localeResolutionCallback: (deviceLocale, supportedLocales) {
        //    for (var locale in supportedLocales) {
        //      if (locale.languageCode == deviceLocale!.languageCode &&
        //          locale.countryCode == deviceLocale.countryCode) {
        //        return locale;
        //      }
        //    }
        //    return supportedLocales.first;
        //  },
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => const LoginScreen(),
          MyHomeScreen.id: (context) => const MyHomeScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          TradeSc.id: (context) => TradeSc(),
          Wallet.id: (context) => Wallet(),
        },
      ),
    );
  }
}

class Palette {
  static const Color primary = Color(0x0B0C36);
}
