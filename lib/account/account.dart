import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localstorage/localstorage.dart';

import '../RecentlyView/recentlyview.dart';
import '../Sellupload/Sellupload.dart';
import '../contact.dart';
import '../login.dart';
import '../map EVShowroom.dart';
import '../map evcharger.dart';
import '../mapEVService.dart';
import '../privacy.dart';
import '../terms and condition.dart';
import 'FAQ.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = 'ca-app-pub-3940256099942544/6300978111';
  final LocalStorage stor1 = new LocalStorage('localstorage_app');
  final storage2 = new FlutterSecureStorage();

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: AdRequest());
    bannerAd.load();
  }

  @override
  void initState() {
    initBannerAd();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Color.fromRGBO(1, 202, 0, 100)
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 100,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(1, 202, 0, 100),
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              await storage2.delete(key: 'uid');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: Text('Sign Out'),
          )
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(4)},
                children: [
                  TableRow(children: [
                    CircleAvatar(
                        backgroundColor: Color.fromRGBO(158, 63, 97, 100),
                        radius: 38,
                        child: Text(
                            storagee2
                                .getItem('name1')
                                .toString()[0]
                                .toUpperCase(),
                            style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 38, fontWeight: FontWeight.bold),
                            ))
                        // backgroundImage: AssetImage("assets/Tritan-bike.png",),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(storagee2.getItem('name1').toString(),
                                  style: GoogleFonts.signika(
                                    textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ))
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(stor1.getItem('email').toString(),
                                  style: GoogleFonts.signika(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ))
                          ),
                        ],
                      ),
                    )
                  ])
                ],
              ),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              leading: Icon(Icons.ev_station),
              title: Text('Add Ev Station'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapEVCharger()));
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.car_crash_rounded),
              title: Text('Add Ev Showroom'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapEVShowroom()));
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.car_repair_outlined),
              title: Text('Add Ev Service'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapEVService()));
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.sell),
              title: Text('Sell your Ev'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Sellpanelupload()));
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.remove_red_eye_outlined),
              title: Text('Recently Viewed'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecentlyViewdata()));
              },
            ),
            Divider(
              height: 1,
            ),
            isAdLoaded
                ? SizedBox(
                    height: bannerAd.size.height.toDouble(),
                    width: bannerAd.size.width.toDouble(),
                    child: AdWidget(
                      ad: bannerAd,
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip,
              ),
              title: const Text(
                "Terms & Condition",
              ),
              onTap: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Terms()));
                // Navigator.popAndPushNamed(context, 'login');
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.policy,
              ),
              title: const Text(
                "Privacy Policy",
              ),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Privacy()));
                //  Navigator.popAndPushNamed(context, 'login');
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.contacts_rounded,
              ),
              title: const Text("Contact Us"),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUs()));
                //  Navigator.popAndPushNamed(context, 'login');
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outlined,
              ),
              title: const Text(
                "About Us",
              ),
              onTap: () async {
                // Navigator.push(context, MaterialPageRoute(
                //     builder: (context) =>Aboutus()));
                //  Navigator.popAndPushNamed(context, 'login');
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.question_answer_outlined,
              ),
              title: const Text(
                "FAQ",
              ),
              onTap: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FAQ()));
                //  Navigator.popAndPushNamed(context, 'login');
              },
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
