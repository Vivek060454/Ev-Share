import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'EVproductdetails.dart';

class EvProduct extends StatefulWidget {
  @override
  State<EvProduct> createState() => _EvProductState();
}

class _EvProductState extends State<EvProduct> {
  late InterstitialAd interstitialAd;
  bool isAdLoaded = false;
  var ide = 'ca-app-pub-3940256099942544/1033173712';

  initIntersititialAd() {
    InterstitialAd.load(
        adUnitId: ide,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interstitialAd = ad;
          setState(() {
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: ((errpr) {
          interstitialAd.dispose();
        })));
  }

  get productsellStream =>
      FirebaseFirestore.instance.collection('productsell').snapshots();

  Future deleteUser(id) {
    var user;
    FirebaseFirestore.instance
        .collection("productselll")
        .doc(id)
        .delete()
        .then((value) => print('Product Deleted'))
        .catchError((error) => print('failed to delete Product:$error'));
    ;
    return FirebaseFirestore.instance
        .collection("productsell")
        .doc(id)
        .delete()
        .then((value) => print('Product Deleted'))
        .catchError((error) => print('failed to delete Product:$error'));

    //print("User Deleted $id");
  }

  void initState() {
    initIntersititialAd();
    final _auth = FirebaseAuth.instance;
    CollectionReference productsell =
        FirebaseFirestore.instance.collection('productsell');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: productsellStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  'Preown EV',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aleo(
                      textStyle: TextStyle(color: Colors.white)),
                ),
                //  title: const Text('Tritan Bikes'),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                //  backgroundColor: const Color.fromRGBO(100, 0, 0, 10),
                backgroundColor: Color.fromRGBO(1, 202, 0, 100)),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: snapshot.data!.docs.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: const Text(
                            'No Product Available!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final produc = snapshot.data!.docs[index];
                            return Container(
                              //color: Colors.white,
                              margin: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              constraints: const BoxConstraints(
                                  minWidth: 160, minHeight: 220),
                              // border: Border.all(color: const  Color.fromARGB(255,95 , 111, 148)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              // width: 100,
                              //  height: 150,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Det(produc)));
                                },
                                onLongPress: () {
                                  if (isAdLoaded == true) {
                                    interstitialAd.show();
                                    interstitialAd.fullScreenContentCallback =
                                        FullScreenContentCallback(
                                      onAdDismissedFullScreenContent: (ad) {
                                        ad.dispose();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Det(produc)));
                                      },
                                      onAdFailedToShowFullScreenContent:
                                          (ad, error) {
                                        ad.dispose();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Det(produc)));
                                      },
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 1,
                                      left: 2,
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/gi.gif',
                                        image: produc["image"],
                                        width: 110,
                                        height: 110,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Positioned(
                                        bottom: 32,
                                        left: 5,
                                        child: Text(produc["brand"],
                                            style: GoogleFonts.reemKufi(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Color.fromRGBO(
                                                      158, 63, 97, 100)),
                                            ))),
                                    Positioned(
                                        left: 5,
                                        bottom: 16,
                                        child: Text(
                                          produc["model"].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        )),
                                    Positioned(
                                        left: 5,
                                        bottom: 1,
                                        child: Text(
                                          'Rs' + produc['sellingprice'] + '/-',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
              ],
            ),
          );
        });
  }
}
