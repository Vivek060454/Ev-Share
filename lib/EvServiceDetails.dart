import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evshare/sqldata/sqldata.dart';
import 'package:evshare/widget/Streeview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'RecentlyView/sqlrecentlyview.dart';

class EvServicedetails extends StatefulWidget {
  final product;

  final lati;
  final long;

  const EvServicedetails(this.product, this.lati, this.long, {Key? key})
      : super(key: key);

  @override
  State<EvServicedetails> createState() => _EvServicedetailsState();
}

class _EvServicedetailsState extends State<EvServicedetails> {
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final _formKey = GlobalKey<FormState>();
  var comment;
  var rating;
  final TextEditingController _ratingController = new TextEditingController();
  final TextEditingController _commentController = new TextEditingController();

  void dispose() {
    // _brandController.dispose();
    _ratingController.dispose();
    _commentController.dispose();

    super.dispose();
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

  double su = 0;

  clearText() {
    _ratingController.clear();
    _commentController.clear();
  }

  var rng = Random();

  Future<void> addUser() async {
    CollectionReference Marker =
        FirebaseFirestore.instance.collection('Marker');
    Marker.doc(widget.product['id'])
        .update({
          'dataa': FieldValue.arrayUnion([
            {
              "Rating": rating.toString(),
              'Comment': comment,
              'UserName': storagee2.getItem('name1').toString(),
              'datee': DateTime.now().toString().substring(0, 10)
            }
          ]),
          // {
          //   "Ratiang": FieldValue.arrayUnion([rating,comment]),
          //   'Commaent':FieldValue.arrayUnion([comment]),
          //   // 'UseraName':FieldValue.arrayUnion(['afgs']),
          //   // 'daaste':FieldValue.arrayUnion([DateTime.now()]),
          // }
        })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
    Navigator.pop(context);
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Draweer() ));
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Sellpanelupload()));
    // print('User added');
  }

  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _journals1 = [];

  bool _isLooading1 = true;

  // This function is used to fetch all data from the database
  void _refreshJournals1() async {
    final data = await SQLHelper1.getItems();
    setState(() {
      _journals1 = data;
      _isLooading1 = false;
    });
  }

  Future<void> _addItem1() async {
    await SQLHelper1.createItem(
        widget.product['Name'],
        widget.product['LocationName'],
        widget.product['Image'],
        widget.product['Description'],
        widget.product['lati'],
        widget.product['long'],
        widget.product['Connector'] ?? '',
        widget.product['Types'] ?? '',
        widget.product['Kwh'] ?? '',
        widget.product['Payment'] ?? '',
        widget.product['Hour'],
        widget.product['Parking'],
        widget.product['Phone'],
        widget.product['App'] ?? '',
        widget.product['Play'] ?? '',
        widget.product['Amni'].toString() ?? '',
        widget.product['Addrses'] ?? '',
        widget.product['Spec'] ?? '',
        widget.product['Brand'] ?? '',
        widget.product['Model'] ?? '',
        widget.product['Insta'],
        widget.product['Fb'],
        widget.product['web']);
    _refreshJournals1();
  }

  bool _isLooading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLooading = false;
    });
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon2 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon3 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon4 = BitmapDescriptor.defaultMarker;

  void addCustomIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/a.png",
    );
    markerIcon1 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker1.png",
    );
    markerIcon2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker2.png",
    );
    markerIcon3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker3.png",
    );
    markerIcon4 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker4.png",
    );
  }

  @override
  void initState() {
    addCustomIcon();
    initBannerAd();
    super.initState();
    _refreshJournals();
    _refreshJournals1();
    _addItem1(); // Loading the diary when the app starts
  }

  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      widget.product['Name'] = existingJournal['Name'];
      widget.product['LocationName'] = existingJournal['LocationName'];
      widget.product['Image'] = existingJournal['Image'];
      widget.product['Description'] = existingJournal['Description'];
      widget.product['lati'] = existingJournal['lati'];
      widget.product['long'] = existingJournal['long'];
      widget.product['Connector'] = existingJournal['Connector'];
      widget.product['Types'] = existingJournal['Types'];
      widget.product['Kwh'] = existingJournal['Kwh'];
      widget.product['Payment'] = existingJournal['Payment'];
      widget.product['Hour'] = existingJournal['Hour'];
      widget.product['Parking'] = existingJournal['Parking'];
      widget.product['Phone'] = existingJournal['Phone'];
      widget.product['App'] = existingJournal['App'];
      widget.product['Play'] = existingJournal['Play'];
      widget.product['Amni'] = existingJournal['Amni'];
      widget.product['Addrses'] = existingJournal['Addrses'];
      widget.product['Spec'] = existingJournal['Spec'];
      widget.product['Brand'] = existingJournal['Brand'];
      widget.product['Model'] = existingJournal['Model'];
      widget.product['Insta'] = existingJournal['Insta'];
      widget.product['Fb'] = existingJournal['Fb'];
      widget.product['web'] = existingJournal['web'];
    }
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        widget.product['Name'],
        widget.product['LocationName'],
        widget.product['Image'],
        widget.product['Description'],
        widget.product['lati'],
        widget.product['long'],
        widget.product['Connector'] ?? '',
        widget.product['Types'] ?? '',
        widget.product['Kwh'] ?? '',
        widget.product['Payment'] ?? '',
        widget.product['Hour'],
        widget.product['Parking'],
        widget.product['Phone'],
        widget.product['App'] ?? '',
        widget.product['Play'] ?? '',
        widget.product['Amni'].toString() ?? '',
        widget.product['Addrses'] ?? '',
        widget.product['Spec'] ?? '',
        widget.product['Brand'] ?? '',
        widget.product['Model'] ?? '',
        widget.product['Insta'],
        widget.product['Fb'],
        widget.product['web']);
    _refreshJournals();
  }

  bool outline = false;

  dataa() async {
    if (outline == false) {
      Fluttertoast.showToast(msg: 'Bookmark Removed');
      // _deleteItem(_journals['id']);
    } else {
      Fluttertoast.showToast(msg: 'Bookmark Added');
      await _addItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> _marker = [
      if (widget.product['Types'] == 'Fast ( Above 50kwh)') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon4,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],
      if (widget.product['Types'] == 'Midium (10 to 50kwh)') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon1,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],
      if (widget.product['Types'] == 'Slow (Below 10kwh)') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon2,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],
      if (widget.product['Name'] == 'EVService') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon3,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],
      if (widget.product['Name'] == 'EvShowroom') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ]
    ];
    if (widget.product['dataa'] == null) {
      su = 0.0;
    } else {
      for (var i = 0; i < widget.product['dataa'].length; i++) {
        var s = widget.product['dataa'].length;
        su += (double.parse(widget.product['dataa'][i]['Rating']) / s);
        print('asfgsgaerfgs$su');
      }
      ;
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            widget.product['Image'] == null
                ? Container(
                    height: 200,
                    width: 300,
                  )
                : Stack(children: [
                    Image.network(widget.product['Image'],
                        height: 230, width: 360, fit: BoxFit.fill),
                    widget.product['dataa'] == null
                        ? Container()
                        : Positioned(
                            bottom: 10,
                            left: 10,
                            child: RatingBar.builder(
                              initialRating:
                                  double.parse(su.toString().substring(0, 1)),
                              itemPadding: EdgeInsets.all(0),
                              itemSize: 15,
                              ignoreGestures: false,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey, //New
                                    blurRadius: 5.0,
                                  )
                                ],
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  if (widget.product['Fb'].toString() != '') {
                                    final mapDir =
                                        widget.product['Fb'].toString();
                                    if (await canLaunch(mapDir)) {
                                      launch(mapDir);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No link Found');
                                  }
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 15,
                                ),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey, //New
                                    blurRadius: 5.0,
                                  )
                                ],
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  if (widget.product['Insta'].toString() !=
                                      '') {
                                    final mapDir =
                                        widget.product['Insta'].toString();
                                    if (await canLaunch(mapDir)) {
                                      launch(mapDir);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No link Found');
                                  }
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.instagram,
                                  size: 15,
                                ),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey, //New
                                    blurRadius: 5.0,
                                  )
                                ],
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  if (widget.product['web'].toString() != '') {
                                    final mapDir =
                                        widget.product['web'].toString();
                                    if (await canLaunch(mapDir)) {
                                      launch(mapDir);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No link Found');
                                  }
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.earthAsia,
                                  size: 15,
                                ),
                              )),
                        ],
                      ),
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

            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.product['LocationName'],
                      textAlign: TextAlign.left,
                      style: GoogleFonts.signika(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(158, 63, 97, 100),
                        ),
                      )),
                )),

            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 1),
                ),
                columnWidths: {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(4),
                },

                //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),

                children: [
                  TableRow(children: [
                    InkWell(
                      onTap: () async {
                        final mapDir =
                            "https://www.google.com/maps/dir/?api=1&destination=${widget.product['lati']},${widget.product['long']}";
                        if (await canLaunch(mapDir)) {
                          launch(mapDir);
                        }
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.directions),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (Geolocator.distanceBetween(
                                              double.parse(
                                                  widget.lati.toString()),
                                              double.parse(
                                                  widget.long.toString()),
                                              double.parse(
                                                  widget.product['lati']),
                                              double.parse(
                                                  widget.product['long'])) /
                                          1000)
                                      .toString()
                                      .substring(0, 4) +
                                  'km',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                outline = !outline;
                              });
                              dataa();
                            },
                            icon: Icon(outline
                                ? Icons.bookmark
                                : Icons.bookmark_outline)),
                        Text('Save',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey))
                      ],
                    ),
                  ]),
                ],
              ),
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
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(6),
                  1: FlexColumnWidth(4),
                },

                //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),

                children: [
                  TableRow(children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(4),
                      },

                      //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),

                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.place),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.product['Addrses'],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.call),
                          ),
                          InkWell(
                            onTap: () {
                              FlutterPhoneDirectCaller.callNumber(
                                  widget.product['Phone']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.product['Phone'],
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.accessibility_rounded),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StreetView(
                                            widget.product['lati'],
                                            widget.product['long'])));
                              },
                              child: Text('Street View',
                                  style: GoogleFonts.robotoSlab(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          )
                        ]),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  child: InkWell(
                    onTap: () async {
                      final mapDir =
                          "https://www.google.com/maps/dir/?api=1&destination=${widget.product['lati']},${widget.product['long']}";
                      if (await canLaunch(mapDir)) {
                        launch(mapDir);
                      }
                    },
                    child: GoogleMap(
                      markers: Set<Marker>.of(_marker),
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(double.parse(widget.product['lati']),
                              double.parse(widget.product['long'])),
                          zoom: 14),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product['Description'],
                textAlign: TextAlign.left,
                style: GoogleFonts.robotoSlab(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Hours',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(widget.product['Hour'],
                          style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ))),
                ],
              ),
            ),

            Divider(
              height: 1,
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Specification',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.signika(
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.product['Specification'],
                      style: GoogleFonts.robotoSlab(
                        textStyle: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                )),
            Divider(
              height: 1,
            ),

            widget.product['dataa'] == null
                ? Container()
                : Divider(
                    height: 1,
                  ),
            widget.product['dataa'] == null
                ? Container()
                : Form(
                    key: _formKey,
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(6),
                        1: FlexColumnWidth(4),
                      },
                      //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Review',
                                style: GoogleFonts.signika(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          InkWell(
                              onTap: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          content: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: 1,
                                                  minRating: 1,
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating1) {
                                                    setState(() {
                                                      rating = rating1;
                                                    });
                                                  },
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _commentController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        Colors.grey.shade100,
                                                    filled: true,
                                                    hintText: 'Comment',
                                                    labelText: 'Comment*',
                                                    hintStyle: const TextStyle(
                                                        height: 2,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0)),
                                                  ),
                                                  // The validator receives the text that the user has entered.
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          comment =
                                                              _commentController
                                                                  .text;
                                                          //   rating=   _ratingController.text;
                                                          // _uploadImage();
                                                          addUser();
                                                          clearText();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Review Added");
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      }
                                                    },
                                                    child: Text('Add Review'))
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text('Add Review',
                                        style: GoogleFonts.signika(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue),
                                        )),
                                  ),
                                ),
                              )),
                        ]),
                      ],
                    ),
                  ),
            widget.product['dataa'] == null
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.product['dataa'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 19,
                          child: Text(
                            (widget.product['dataa'][index]['UserName'])
                                .toString()
                                .substring(0, 1),
                          ),
                        ),
                        title: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  (widget.product['dataa'][index]['UserName'])
                                      .toString(),
                                  style: GoogleFonts.signika(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                            Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      widget.product['dataa'][index]['Rating']),
                                  itemPadding: EdgeInsets.all(0),
                                  itemSize: 15,
                                  ignoreGestures: false,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                    (widget.product['dataa'][index]['datee'])
                                        .toString(),
                                    style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                (widget.product['dataa'][index]['Comment'])
                                    .toString(),
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                ))),
                      );
                    }),
            // Expanded(
            //   child: ListView.builder(
            //
            //
            //  shrinkWrap: true,
            //       itemCount:widget.product['dataa'].length,
            //       itemBuilder: (context,index){
            //         final pro=widget.product['dataa'][index];
            //         return Container(
            //           child: Column(
            //             children: [
            //               Text(pro['Comment'])
            //             ],
            //           ),
            //         );
            //       }),
            // )
          ],
        ),
      ),
    ));
  }
}
