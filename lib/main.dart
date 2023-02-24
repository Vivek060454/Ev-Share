import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'login.dart';
import 'map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.white,
        errorColor: Colors.red,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Color.fromRGBO(1, 202, 0, 100),
            ),
        primaryColor: Color.fromRGBO(1, 202, 0, 100),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future<bool> checkLogin() async {
    String? value = await storage.read(key: "uid");
    if (value == null) {
      return false;
    }
    return true;
  }

  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FutureBuilder(
                    future: checkLogin(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data == false) {
                        return Login();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Draweer();
                    },
                  ))),
// if (_auth==null)
//             {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder:
//                     (context) =>  Login(),
//
//                 )
//             );}
// else{
//   Navigator.pushReplacement(context,
//       MaterialPageRoute(builder:
//       (context) =>  Draweer()));
// }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 100,
        top: 100,
        right: 100,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            image: AssetImage(
                'assets/WhatsApp Image 2023-01-28 at 10.58.18 AM (2).png'),
            fit: BoxFit.cover,
          )),
    );
  }
}
