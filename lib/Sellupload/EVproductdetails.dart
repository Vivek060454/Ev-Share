import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class Det extends StatefulWidget {
  final produc;

  const Det(this.produc, {Key? key}) : super(key: key);

  @override
  State<Det> createState() => _DetState();
}

class _DetState extends State<Det> {
  int cart = 0;

  void initState() {
    initBannerAd();
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('usersell')
        .doc(_auth.currentUser?.uid)
        .collection('addcart')
        .get()
        .then((myDocuments) {
      cart = myDocuments.docs.length;
      print(myDocuments.docs.length);
    });
    CollectionReference Bikes = FirebaseFirestore.instance.collection('Bikes');
    super.initState();
  }

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = 'ca-app-pub-3940256099942544/6300978111';

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

  // static String? get _auth=> null;

  Future<void> addcat() async {
    var uuid = Uuid();
    final curUuid = uuid.v1();
    final _auth = FirebaseAuth.instance;
    print(_auth.currentUser?.uid);
    CollectionReference usersell = FirebaseFirestore.instance
        .collection('usersell')
        .doc(_auth.currentUser?.uid)
        .collection('addcart');
    usersell
        .doc(curUuid)
        .set({
          'brand': widget.produc.get('brand') + '   (' + type + ')',
          'model': widget.produc.get('model'),
          'price': widget.produc.get('price'),
          'image': widget.produc.get('image'),
          "email": _auth.currentUser?.email
        })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
  }

  Future<void> order() async {
    var uuid = Uuid();
    final curUuid = uuid.v1();
    final _auth = FirebaseAuth.instance;
    print(_auth.currentUser?.uid);

    CollectionReference usersell = FirebaseFirestore.instance
        .collection('usersell')
        .doc(_auth.currentUser?.uid)
        .collection('order');
    usersell
        .doc(curUuid)
        .set({
          'brand': widget.produc.get('brand'),
          'model': widget.produc.get('brand'),
          'price': widget.produc.get('brand'),
          'image': widget.produc.get('image'),
          "email": _auth.currentUser?.email
        })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));

    CollectionReference productsell = FirebaseFirestore.instance
        .collection('order')
        .doc(_auth.currentUser?.uid)
        .collection('order');
    productsell
        .doc(curUuid)
        .set({
          'brand': widget.produc.get('brand'),
          'model': widget.produc.get('model'),
          'price': widget.produc.get('price'),
          "email": _auth.currentUser?.email,
          'image': widget.produc.get('image'),
        })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
    // print('User added');
  }

  final types = [
    'S(5-5.5inch)',
    'M(5.3-5.9inch)',
    'L(5.10-6.2inch)',
    'XL(6.1-6.5inch)'
  ];
  String type = 'S(5-5.5inch)';

//   sendi(produc) async {
//     final _auth = FirebaseAuth.instance;
//     var uuid = Uuid();
//     final curUuid = uuid.v1();
//     // Note that using a username and password for gmail only works if
//     // you have two-factor authentication enabled and created an App password.
//     // Search for "gmail app password 2fa"
//     // The alternative is to use oauth.
//     String username = 'vivekp@evdock.app';
//     String password = 'ibttscdrcgydlsik';
//
//     final smtpServer = gmail(username, password);
//     // Use the SmtpServer class to configure an SMTP server:
//     // final smtpServer = SmtpServer('smtp.domain.com');
//     // See the named arguments of SmtpServer for further configuration
//     // options.
//
//     // Create our message.
//     final message = Message()
//       ..from = Address(username, 'Vivek Prajapati')
//       ..recipients.add('vivekp@evdock.app')
//     // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//     //  ..bccRecipients.add(Address('bccAddress@example.com'))
//       ..subject = 'Contact Us'
//     // ..text='Order id,'+sum.toString()+_auth.currentUser!.uid.toString()
//     //..text = product.map((product)=>product['brand'],).toList()
//     //   ..text = product.map((product)=>product['model'],).toList()
//     //  ..text = product.map((product)=>product['price'],).toList()
//     //  ..text = sum.toString()
//       ..text ="Email:       "+_auth.currentUser!.email.toString()+'\n'+
//           'Phone:     '+_auth.currentUser!.phoneNumber.toString()+'Details:'+'\n'+produc.map((product)=>product['brand'],).toString()+"\n"+
//
//           produc.map((product)=>product['model'],).toString();
//
//
//
//     // ..text = 'This is the plain text.\nThis is line 2 of the text part.';
// //  ..html = "<h1>_pinController.text</h1>\n<p>Hey! Here's some HTML content</p>";
//
//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//     } on MailerException catch (e) {
//       print('Message not sent.');
//       for (var p in e.problems) {
//         print('Problem: ${e}: ${p.msg}');
//       }
//     }
//
//
//   }

  @override
  //const Detailee({Key? key}) : super(key: key);
  // late String s1image;
  //
  // late String image;
  //
  // late String simage;
  //
  // late String brand;
  //
  // late  String description;
  //
  //  var spc1;
  //
  //  late var sellername;
  //
  // late  String city;
  //
  // late var spc2;
  //
  // late int phone;
  //
  // late  String title;
  //
  // late var price;
  //
  // late var spc3;

  @override
  Widget build(BuildContext context) {
    // final Detailee=ProductC(id: widget.productl.id, phone: widget.productl.phone, brand: widget.product.brand, sellername: widget.product.sellername ,
    //     image: widget.productl.image, simage: widget.product.simage, s1image: widget.productl.s1image, spc1: widget.product.spc1, spc2: widget.product.spc2,
    //     spc3: widget.productl.spc3, city: widget.productl.city, title: widget.product.title, price: widget.product.price, description: widget.product.description) ;
    return Scaffold(
//       appBar: AppBar(
//         title:   Text('Product Details', textAlign: TextAlign.center,
//             style:GoogleFonts.aleo(textStyle: TextStyle(color: Colors.white))),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//
//         backgroundColor: Color.fromRGBO(1,202,0,100),
//         actions: [
//           //ca(),
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
// //             child: Badge(
// //               badgeContent: Text(cart.toString(),),
// // //borderRadius: BorderRadius.circular(10,),
// // //borderSide: BorderSide(color: Colors.black),
// //               elevation: 0,
// //               //  badgeColor: Colors.white,
// //               child: InkWell(
// //                 onTap: (){
// //                   Navigator.push(context, MaterialPageRoute(
// //                       builder: (context) => Addcart()));
// //                 },
// //                 child: Icon(Icons.shopping_cart_outlined,color: Colors.white,size: 30,),),
// //             ),
// //           ),
//
//         ],
//         //backgroundColor: Color.fromRGBO(100, 0,0 , 10),
//       ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Stack(children: [
                Container(
                  child: CarouselSlider(
                      items: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.produc.get('image')),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(widget.produc.get('img1')),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(widget.produc.get('img2')),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          height: 240)),
                ),
                Positioned(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 8, right: 8, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, //New
                          blurRadius: 15.0,
                        )
                      ],
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  ),
                ))
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.grey,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(158, 63, 97, 100),
                      offset: Offset(0, -3)),
                  BoxShadow(
                      color: Color.fromRGBO(158, 63, 97, 100),
                      offset: Offset(3, 3),
                      blurRadius: 5,
                      spreadRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  Text(widget.produc.get('brand'),
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.notoSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  Text(
                    widget.produc.get('model'),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.produc.get('des'),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Rs ' + widget.produc.get('sellingprice') + '/-',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                    ],
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          'Specification:-',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(158, 63, 97, 100))),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(4),
                        //  2: FlexColumnWidth(4),
                      },
                      border: TableBorder(
                          verticalInside: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 0, 18, 50),
                              style: BorderStyle.solid)),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Column(
                              children: [
                                Text(
                                  'Driving Range',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 0, left: 13, right: 13),
                            child: Text(
                                widget.produc.get('drving range') + ' KM',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Charging Hours',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(widget.produc.get('charging hours'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Safety',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(widget.produc.get('safety'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Transmission',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(widget.produc.get('transmission'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Seating Capacity',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                                widget.produc.get('seatingcapacity') +
                                    ' Seater',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Battery Capacity',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(widget.produc.get('batterycapacity'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          'Seller Details:-',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(158, 63, 97, 100))),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(4),
                        //  2: FlexColumnWidth(4),
                      },
                      border: TableBorder(
                          verticalInside: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 0, 18, 50),
                              style: BorderStyle.solid)),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Name',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(widget.produc.get('name'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Actual Purcahse Price',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                                'Rs ' + widget.produc.get('actualprice') + '/-',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Drive Till Yet',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                                widget.produc.get('drivingtilltel') + ' KM',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                            child: Text(
                              'Addrese',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                                widget.produc.get('addreseA') +
                                    ', ' +
                                    widget.produc.get('addresec') +
                                    ', ' +
                                    widget.produc.get('state') +
                                    ' - ' +
                                    widget.produc.get('addresep'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          )
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: FloatingActionButton(
                              backgroundColor:
                                  const Color.fromRGBO(1, 202, 0, 100),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              onPressed: () {
                                FlutterPhoneDirectCaller.callNumber(
                                    widget.produc.get('phone'));
                              },
                              child: Text(
                                'Contact Seller',
                              )),
                        ),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: FloatingActionButton(
                            backgroundColor:
                                const Color.fromRGBO(1, 202, 0, 100),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            onPressed: () async {
                              String phonen = widget.produc.get('phone');

                              Uri url = Uri.parse('https://wa.me/$phonen');

                              if (!await launchUrl(url)) {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text('Message Seller'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
