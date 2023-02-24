import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:evshare/sear.dart';
import 'package:evshare/widget/loading.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'EvServiceDetails.dart';
import 'EvShoowroomdetails.dart';
import 'evchager.dart';
import 'evdetails.dart';
import 'filter.dart';
import 'search/googlesearch.dart';
import 'login.dart';
import 'map EVShowroom.dart';
import 'map evcharger.dart';
import 'mapEVService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor markerIcon;

  late BitmapDescriptor markerIcon1;

  late BitmapDescriptor markerIcon2;

  late BitmapDescriptor markerIcon3;

  late BitmapDescriptor markerIcon4;

  var s;

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

  final LocalStorage storage1 = new LocalStorage('localstorage_app');
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final LocalStorage stor1 = new LocalStorage('localstorage_app');
  final LocalStorage stora1 = new LocalStorage('localstorage_app');
  static final CameraPosition _kgoogleplex =
      const CameraPosition(target: LatLng(19.1955645, 72.9630627), zoom: 14);
  final storage2 = new FlutterSecureStorage();
  Map<String, bool> values = {
    'RestRoom': false,
    'Parking': false,
    'Wifi': false,
    'Shopping': false,
    'Resturant': false,
  };
  var tmpArray = [];

  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });
    print(tmpArray);
  }

  var se;
  double su = 0;

  get MarkerStream => FirebaseFirestore.instance
      .collection('Marker')
      .
//where('Name',arrayContainsAny:stora1.getItem('name') ).
      snapshots();

  void initState() {
    initBannerAd();
    addCustomIcon();
    final _auth = FirebaseAuth.instance;
    //  print(storage1.getItem('name'));
    _getCurrentPosition();
    CollectionReference Marker =
        FirebaseFirestore.instance.collection('Marker');
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getnearbylocation() async {}

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

//
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ?
        //check if loading is true or false
        Loading()
        : StreamBuilder<QuerySnapshot>(
            stream: MarkerStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print("Something Went Wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              final List storedocs = [];
              snapshot.data!.docs.map((DocumentSnapshot document) async {
                Map a = document.data() as Map<String, dynamic>;
                storedocs.add(a);
                a['id'] = document.id;
              }).toList();
              //       var c;
              //       for (var i=0; i<storedocs.length;i++){
              //  var s=     Geolocator.distanceBetween( _currentPosition!.latitude,_currentPosition!.longitude,double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long']));
              // var a= s/1000;
              //  c = a.toString().substring(0, 4);
              //  print(c);
              //       }
              for (var i = 0; i < storedocs.length; i++) {
                // s=storedocs[i]['Name'];
                // var se=storedocs[i]['dataa'].length;
                // su +=( double.parse(storedocs[i]['dataa'][i]['Rating'])/se);
                // print('asfgsgaerfgs$su');
              }

              List<Marker> _marker = [
                for (var i = 0; i < storedocs.length; i++) ...[
                  if (storedocs[i]['Types'] == 'Fast ( Above 50kwh)') ...[
                    Marker(
                        markerId: MarkerId(storedocs[i]['id']),
                        position: LatLng(double.parse(storedocs[i]['lati']),
                            double.parse(storedocs[i]['long'])),
                        icon: markerIcon4,
                        infoWindow: InfoWindow(
                            title: storedocs[i]['LocationName'],
                            snippet: storedocs[i]['Name'],
                            onTap: () {
                              if (storedocs[i]['Name'] == 'EVCharging') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Evdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EVService') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvServicedetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EvShowroom') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvShowroomdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                            }),
                        onTap: () {}),
                  ],
                  if (storedocs[i]['Types'] == 'Midium (10 to 50kwh)') ...[
                    Marker(
                        markerId: MarkerId(storedocs[i]['id']),
                        position: LatLng(double.parse(storedocs[i]['lati']),
                            double.parse(storedocs[i]['long'])),
                        icon: markerIcon1,
                        infoWindow: InfoWindow(
                            title: storedocs[i]['LocationName'],
                            snippet: storedocs[i]['Name'],
                            onTap: () {
                              if (storedocs[i]['Name'] == 'EVCharging') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Evdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EVService') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvServicedetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EvShowroom') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvShowroomdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                            }),
                        onTap: () {}),
                  ],
                  if (storedocs[i]['Types'] == 'Slow (Below 10kwh)') ...[
                    Marker(
                        markerId: MarkerId(storedocs[i]['id']),
                        position: LatLng(double.parse(storedocs[i]['lati']),
                            double.parse(storedocs[i]['long'])),
                        icon: markerIcon2,
                        infoWindow: InfoWindow(
                            title: storedocs[i]['LocationName'],
                            snippet: storedocs[i]['Name'],
                            onTap: () {
                              if (storedocs[i]['Name'] == 'EVCharging') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Evdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EVService') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvServicedetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EvShowroom') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvShowroomdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                            }),
                        onTap: () {}),
                  ],
                  if (storedocs[i]['Name'] == 'EVService') ...[
                    Marker(
                        markerId: MarkerId(storedocs[i]['id']),
                        position: LatLng(double.parse(storedocs[i]['lati']),
                            double.parse(storedocs[i]['long'])),
                        icon: markerIcon3,
                        infoWindow: InfoWindow(
                            title: storedocs[i]['LocationName'],
                            snippet: storedocs[i]['Name'],
                            onTap: () {
                              if (storedocs[i]['Name'] == 'EVCharging') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Evdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EVService') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvServicedetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EvShowroom') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvShowroomdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                            }),
                        onTap: () {}),
                  ],
                  if (storedocs[i]['Name'] == 'EvShowroom') ...[
                    Marker(
                        markerId: MarkerId(storedocs[i]['id']),
                        position: LatLng(double.parse(storedocs[i]['lati']),
                            double.parse(storedocs[i]['long'])),
                        icon: markerIcon,
                        infoWindow: InfoWindow(
                            title: storedocs[i]['LocationName'],
                            snippet: storedocs[i]['Name'],
                            onTap: () {
                              if (storedocs[i]['Name'] == 'EVCharging') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Evdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EVService') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvServicedetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[i]['Name'] == 'EvShowroom') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvShowroomdetails(
                                            storedocs[i],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                            }),
                        onTap: () {}),
                  ],
                  // Marker(
                  //     markerId: MarkerId(storedocs[i]['id']),
                  //     position:  LatLng(double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long'])),
                  //     icon:BitmapDescriptor.defaultMarker,
                  //     infoWindow: InfoWindow(
                  //         title: storedocs[i]['LocationName'],
                  //         onTap: (){
                  //       if(storedocs[i]['Name']=='EVCharging'){
                  //
                  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Evdetails(storedocs[i],_currentPosition!.latitude,_currentPosition!.longitude)));
                  //       }
                  //       if(storedocs[i]['Name']=='EVService'){
                  //
                  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>EvServicedetails(storedocs[i],_currentPosition!.latitude,_currentPosition!.longitude)));
                  //       }
                  //       if(storedocs[i]['Name']=='EvShowroom'){
                  //
                  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>EvShowroomdetails(storedocs[i],_currentPosition!.latitude,_currentPosition!.longitude)));
                  //       }
                  //     }
                  //     ),
                  //     onTap: (){
                  //     }
                  // ),
                ]
              ];
              return snapshot.connectionState == ConnectionState.waiting ||
                      _currentPosition == null
                  ? //check if loading is true or false
                  Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text('Check internet connection or location')
                        ],
                      ),
                    )
                  : MaterialApp(
                      home: Scaffold(
                        appBar: AppBar(
                            title: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Ev Share '),
                                ],
                              ),
                            ),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Sear()));
                                  },
                                  icon: Icon(Icons.search)),
                              PopupMenuButton<int>(
                                icon: Icon(
                                  Icons.add_location_outlined,
                                  color: Colors.white,
                                ),
                                itemBuilder: (context) => [
                                  // popupmenu item 1
                                  PopupMenuItem(
                                    value: 1,
                                    // row has two child icon and text.
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapEVCharger()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.ev_station),
                                          SizedBox(
                                            // sized box with width 10
                                            width: 10,
                                          ),
                                          Text("Add EV Charger")
                                        ],
                                      ),
                                    ),
                                  ),
                                  // popupmenu item 2
                                  PopupMenuItem(
                                    value: 2,
                                    // row has two child icon and text
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapEVShowroom()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.car_crash_rounded),
                                          SizedBox(
                                            // sized box with width 10
                                            width: 10,
                                          ),
                                          Text("Add EV Showroom")
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    // row has two child icon and text
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapEVService()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.car_repair_outlined),
                                          SizedBox(
                                            // sized box with width 10
                                            width: 10,
                                          ),
                                          Text("Add EV Service")
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                offset: Offset(0, 100),
                                color: Colors.grey,
                                elevation: 2,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Filter()));
                                  },
                                  icon: Icon(Icons.tune))
                            ],
                            backgroundColor: Color.fromRGBO(1, 202, 0, 100)),
                        // drawer:   Drawer(
                        //   child: Container(
                        //     child: ListView(
                        //       //Important: Remove any padding from the ListView.
                        //       padding: EdgeInsets.zero,
                        //       children: <Widget>[
                        //         SizedBox(
                        //           height: 190,
                        //           child:UserAccountsDrawerHeader(
                        //             accountEmail:Text(stor1.getItem('email').toString()),
                        //             accountName: Text(storagee2.getItem('name1').toString()),
                        //             currentAccountPicture: CircleAvatar(
                        //                 backgroundColor: Colors.white,
                        //                 child:Text(storagee2.getItem('name1').toString()[0].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize:25,color: Color.fromRGBO(220, 95, 0, 1)))
                        //               // backgroundImage: AssetImage("assets/Tritan-bike.png",),
                        //             ),
                        //           ),
                        //         ),
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        body: Stack(
                          children: [
                            Positioned(
                              child: snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      _currentPosition == null
                                  ? //check if loading is true or false
                                  Center(
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          Text(
                                              'Check internet connection or location')
                                        ],
                                      ),
                                    )
                                  : GoogleMap(
                                      markers: Set<Marker>.of(_marker),
                                      onTap: (position) {
                                        //   _customInfoWindowController.);
                                      },
                                      onCameraMove: (position) {
                                        _customInfoWindowController
                                            .onCameraMove!();
                                      },
                                      mapType: MapType.normal,
                                      compassEnabled: true,
                                      myLocationEnabled: true,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                        _customInfoWindowController
                                            .googleMapController = controller;
                                      },
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              _currentPosition!.latitude,
                                              _currentPosition!.longitude),
                                          zoom: 14),
                                    ),
                            ),
                            CustomInfoWindow(
                              controller: _customInfoWindowController,
                              height: 100,
                              width: 100,
                            ),
                            // Positioned(
                            //     top: 15,
                            //     left: 15,
                            //     child: InkWell(
                            //         onTap:(){},
                            //         child: Container(
                            //
                            //           decoration: BoxDecoration(
                            //
                            //             borderRadius: BorderRadius.circular(10),
                            //             color: Colors.white
                            //
                            //
                            //           ),
                            //           child: Row(
                            //             children: [
                            //               IconButton(onPressed: (){
                            //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Googlesearch()));
                            //               }, icon: Icon(Icons.search)),
                            //               PopupMenuButton<int>(
                            //                 icon: Icon(Icons.add_location_outlined),
                            //                 itemBuilder: (context) => [
                            //                   // popupmenu item 1
                            //                   PopupMenuItem(
                            //                     value: 1,
                            //                     // row has two child icon and text.
                            //                     child: InkWell(
                            //                       onTap: (){
                            //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>MapEVCharger()));
                            //                       },
                            //                       child: Row(
                            //                         children: [
                            //                           Icon(Icons.ev_station),
                            //                           SizedBox(
                            //                             // sized box with width 10
                            //                             width: 10,
                            //                           ),
                            //                           Text("Add EV Charger")
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   // popupmenu item 2
                            //                   PopupMenuItem(
                            //                     value: 2,
                            //                     // row has two child icon and text
                            //                     child: InkWell(
                            //                       onTap: (){
                            //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>MapEVShowroom()));
                            //                       },
                            //                       child: Row(
                            //                         children: [
                            //                           Icon(Icons.car_crash_rounded),
                            //                           SizedBox(
                            //                             // sized box with width 10
                            //                             width: 10,
                            //                           ),
                            //                           Text("Add EV Showroom")
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   PopupMenuItem(
                            //                     value: 3,
                            //                     // row has two child icon and text
                            //                     child: InkWell(
                            //                       onTap: (){
                            //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>MapEVService()));
                            //                       },
                            //                       child: Row(
                            //                         children: [
                            //                           Icon(Icons.car_repair_outlined),
                            //                           SizedBox(
                            //                             // sized box with width 10
                            //                             width: 10,
                            //                           ),
                            //                           Text("Add EV Service")
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //                 offset: Offset(0, 100),
                            //                 color: Colors.grey,
                            //                 elevation:2,
                            //               ),
                            //               IconButton(onPressed: (){
                            //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Filter()));
                            //               }, icon: Icon(Icons.tune))
                            //             ],
                            //           ),
                            //         ))),
                            isAdLoaded
                                ? SizedBox(
                                    height: bannerAd.size.height.toDouble(),
                                    width: bannerAd.size.width.toDouble(),
                                    child: AdWidget(
                                      ad: bannerAd,
                                    ),
                                  )
                                : SizedBox(),
                            Positioned(
                              bottom: 115,
                              right: 10,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Googlesearch()));
                                },
                                icon: Icon(
                                  Icons.map,
                                  size: 40,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child:
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Container(
                                            // height: 100,
                                            //    width: 200,
                                            margin: const EdgeInsets.only(
                                                left: 12, right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          )
                                        : Container(
                                            height: 100,
                                            child: ListView.builder(
                                                itemCount: 1,
                                                // scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  s = storedocs[index]['Name'];
                                                  var se = storedocs[index]
                                                          ['dataa']
                                                      .length;
                                                  su += (double.parse(
                                                          storedocs[index]
                                                                      ['dataa']
                                                                  [index]
                                                              ['Rating']) /
                                                      se);
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (storedocs[index]
                                                                ['Name'] ==
                                                            'EVCharging') {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => Evdetails(
                                                                      storedocs[
                                                                          index],
                                                                      _currentPosition!
                                                                          .latitude,
                                                                      _currentPosition!
                                                                          .longitude)));
                                                        }
                                                        if (storedocs[index]
                                                                ['Name'] ==
                                                            'EVService') {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => EvServicedetails(
                                                                      storedocs[
                                                                          index],
                                                                      _currentPosition!
                                                                          .latitude,
                                                                      _currentPosition!
                                                                          .longitude)));
                                                        }
                                                        if (storedocs[index]
                                                                ['Name'] ==
                                                            'EvShowroom') {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => EvShowroomdetails(
                                                                      storedocs[
                                                                          index],
                                                                      _currentPosition!
                                                                          .latitude,
                                                                      _currentPosition!
                                                                          .longitude)));
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 100,
                                                        width: 320,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 12,
                                                            right: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                      storedocs[
                                                                              index]
                                                                          [
                                                                          'LocationName'],
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts
                                                                          .signika(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Color.fromRGBO(
                                                                                158,
                                                                                63,
                                                                                97,
                                                                                100)),
                                                                      ))),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Table(
                                                                  columnWidths: {
                                                                    0: FlexColumnWidth(
                                                                        4),
                                                                    1: FlexColumnWidth(
                                                                        4),
                                                                  },
                                                                  //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                                                                  children: [
                                                                    TableRow(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child:
                                                                                Text(
                                                                              (Geolocator.distanceBetween(_currentPosition!.latitude, _currentPosition!.longitude, double.parse(storedocs[index]['lati']), double.parse(storedocs[index]['long'])) / 1000).toString().substring(0, 4) + 'km',
                                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                RatingBar.builder(
                                                                              initialRating: double.parse(su.toString()),
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
                                                                        ]),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 0,
                                                                        bottom:
                                                                            0,
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                child: Table(
                                                                  columnWidths: {
                                                                    0: FlexColumnWidth(
                                                                        4),
                                                                    1: FlexColumnWidth(
                                                                        4),
                                                                  },
                                                                  //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                                                                  children: [
                                                                    TableRow(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child:
                                                                                Text(
                                                                              storedocs[index]['Name'],
                                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                Text(
                                                                              'Neraby',
                                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          )
                                // SingleChildScrollView(
                                //   scrollDirection: Axis.horizontal,
                                //   child:   Row(
                                //     children: [
                                //       for (var  i=0; i<storedocs.length;i++)...[
                                //
                                //         Padding(
                                //
                                //           padding: const EdgeInsets.all(8.0),
                                //
                                //           child: InkWell(
                                //
                                //             onTap: (){
                                //               //
                                //               // showModalBottomSheet(context: context,
                                //               //     isScrollControlled:true,
                                //               //     builder:(context,
                                //               //         )
                                //               //     {
                                //               //       return SingleChildScrollView(
                                //               //         scrollDirection: Axis.vertical,
                                //               //
                                //               //         child: Padding(
                                //               //           padding: const EdgeInsets.all(8.0),
                                //               //
                                //               //           child: Container(
                                //               //             decoration: BoxDecoration(
                                //               //               borderRadius: BorderRadius.only(
                                //               //                 topRight: Radius.circular(30),
                                //               //                 topLeft: Radius.circular(30),
                                //               //               ),
                                //               //               color: Colors.transparent,
                                //               //             ),
                                //               //             height: 600,
                                //               //
                                //               //             child: Container(decoration: BoxDecoration(
                                //               //               color: Theme.of(context).canvasColor,
                                //               //               borderRadius: const BorderRadius.only(topRight: Radius.circular(30),
                                //               //                 topLeft: Radius.circular(30),),
                                //               //
                                //               //             ),
                                //               //                 child:Column(
                                //               //                   children: [
                                //               //
                                //               //
                                //               //                     Padding(
                                //               //                       padding: const EdgeInsets.all(8.0),
                                //               //                       child: Icon(Icons.linear_scale),
                                //               //                     ),
                                //               //                     Padding(
                                //               //                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                //               //                       child: Table(
                                //               //                         columnWidths: {
                                //               //                           0: FlexColumnWidth(4),
                                //               //                           1: FlexColumnWidth(2),
                                //               //
                                //               //
                                //               //                         },
                                //               //
                                //               //                         children: [
                                //               //
                                //               //                           TableRow(
                                //               //                               children: [
                                //               //                                 Column(
                                //               //                                   children: [
                                //               //                                     Row(
                                //               //                                       children: [
                                //               //                                         InkWell(
                                //               //                                             onTap:(){
                                //               //                                         //      Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                //               //                                             },
                                //               //                                             child: Text('  View Detail',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black26),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                                //               //                                         Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))
                                //               //                                       ],
                                //               //                                     ),
                                //               //                                   ],
                                //               //                                 ),
                                //               //                                 Align(
                                //               //                                   alignment: Alignment.centerLeft,
                                //               //                                   child: Row(
                                //               //                                     children: [
                                //               //                                       InkWell(
                                //               //
                                //               //                                           onTap:() async {
                                //               //                                             final mapDir =
                                //               //                                                 "https://www.google.com/maps/dir/?api=1&destination=${storedocs[i]['lati']},${storedocs[i]['long']}";
                                //               //                                             if (await canLaunch(mapDir)) {
                                //               //                                               launch(mapDir);
                                //               //                                             }
                                //               //                                           },
                                //               //                                           child: Text('Direction',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black26),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                                //               //                                       Icon(Icons.directions,color: Color.fromRGBO(246, 99, 9, 100)),
                                //               //                                     ],
                                //               //                                   ),
                                //               //                                 ),
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                               ]
                                //               //                           ),
                                //               //
                                //               //                         ],
                                //               //                       ),
                                //               //                     ),
                                //               //
                                //               //                     Padding(
                                //               //                       padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                //               //                       child: SizedBox(
                                //               //                         height: 200,
                                //               //                         child: Container(
                                //               //                           color:   Colors.white,
                                //               //                           child: CarouselSlider(items: [
                                //               //                             Padding(
                                //               //                               padding: const EdgeInsets.all(8.0),
                                //               //                               child: Container(
                                //               //                                 decoration: BoxDecoration(
                                //               //                                     borderRadius: BorderRadius.all(Radius.circular(10)),
                                //               //                                     image: DecorationImage(
                                //               //
                                //               //                                         image: NetworkImage(storedocs[i]['image'] ),fit: BoxFit.fill
                                //               //                                     )
                                //               //                                 ),
                                //               //
                                //               //                               ),
                                //               //                             ), Padding(
                                //               //                               padding: const EdgeInsets.all(8.0),
                                //               //                               child: Container(
                                //               //                                 decoration: BoxDecoration(
                                //               //                                     borderRadius: BorderRadius.all(Radius.circular(10)),
                                //               //                                     image: DecorationImage(
                                //               //                                         image: NetworkImage(storedocs[i]['img1'] ),fit: BoxFit.fill
                                //               //                                     )
                                //               //                                 ),
                                //               //
                                //               //                               ),
                                //               //                             ), Padding(
                                //               //                               padding: const EdgeInsets.all(8.0),
                                //               //                               child: Container(
                                //               //                                 decoration: BoxDecoration(
                                //               //                                     borderRadius: BorderRadius.all(Radius.circular(10)),
                                //               //                                     image: DecorationImage(
                                //               //                                         image: NetworkImage(storedocs[i]['img2'] ),fit: BoxFit.fill
                                //               //                                     )
                                //               //                                 ),
                                //               //
                                //               //                               ),
                                //               //                             ),
                                //               //                           ], options: CarouselOptions(
                                //               //                               enlargeCenterPage: true,
                                //               //                               viewportFraction: 0.9,
                                //               //
                                //               //                               autoPlay: true,
                                //               //                               autoPlayInterval: const Duration(seconds: 5),
                                //               //                               height: 450
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                           )),
                                //               //                         ),
                                //               //                       ),
                                //               //                     ),
                                //               //                     Padding(
                                //               //                       padding: const EdgeInsets.all(8.0),
                                //               //                       child: Container(
                                //               //                         color:   Colors.white,
                                //               //                         child: Column(
                                //               //                           children: [
                                //               //
                                //               //                             Padding(
                                //               //                               padding: const  EdgeInsets.fromLTRB(8, 0, 8, 0),
                                //               //                               child:   storedocs[i]['title']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                //               //                               Text(storedocs[i]['title'],maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromRGBO(246, 99, 9, 100)),),
                                //               //                             ),
                                //               //                           ],
                                //               //                         ),
                                //               //                       ),
                                //               //                     ),
                                //               //                     SingleChildScrollView(
                                //               //                       scrollDirection: Axis.vertical,
                                //               //                       child: DefaultTabController(
                                //               //                           length: 3, // length of tabs
                                //               //                           initialIndex: 0,
                                //               //                           child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                                //               //                             Container(
                                //               //                               child: TabBar(
                                //               //                                 indicatorColor: Color.fromRGBO(246, 99, 9, 100),
                                //               //                                 labelColor: Color.fromRGBO(246, 99, 9, 100),
                                //               //                                 unselectedLabelColor: Colors.black,
                                //               //                                 tabs: [
                                //               //                                   Tab(text: 'Overview'),
                                //               //                                   Tab(text: 'Photos'),
                                //               //                                   Tab(text: 'Amentities'),
                                //               //                                   // Tab(text: 'Tab 4'),
                                //               //                                 ],
                                //               //                               ),
                                //               //                             ),
                                //               //                             Container(
                                //               //                                 height: 240, //height of TabBarView
                                //               //                                 decoration: BoxDecoration(
                                //               //                                     border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                                //               //                                 ),
                                //               //                                 child: TabBarView(children: <Widget>[
                                //               //                                   SingleChildScrollView(
                                //               //                                     scrollDirection: Axis.vertical,
                                //               //                                     child: Container(
                                //               //                                       child: Center(
                                //               //                                         child: Column(
                                //               //                                           children: [
                                //               //                                             Padding(
                                //               //                                               padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                //               //                                               child: Table(
                                //               //                                                 columnWidths: {
                                //               //                                                   0: FlexColumnWidth(1),
                                //               //                                                   1: FlexColumnWidth(3),
                                //               //
                                //               //                                                 },
                                //               //
                                //               //                                                 children: [
                                //               //
                                //               //                                                   TableRow(
                                //               //
                                //               //                                                       children: [
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //                                                               Row(
                                //               //                                                                 children: [
                                //               //
                                //               //                                                                   Icon(Icons.location_pin,color: Color.fromRGBO(246, 99, 9, 100))
                                //               //                                                                 ],
                                //               //                                                               ),
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //
                                //               //                                                               storedocs[i]['Addrese']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                //               //                                                               Text(storedocs[i]['Addrese'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                //               //
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                                                       ]
                                //               //                                                   ),
                                //               //                                                   TableRow(
                                //               //
                                //               //                                                       children: [
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //                                                               Row(
                                //               //                                                                 children: [
                                //               //
                                //               //                                                                   Icon(Icons.handshake,color: Color.fromRGBO(246, 99, 9, 100))
                                //               //                                                                 ],
                                //               //                                                               ),
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //
                                //               //                                                               storedocs[i]['trust_name']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                //               //                                                               Column(
                                //               //                                                                 children: [
                                //               //                                                                   Text(storedocs[i]['trust_name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                //               //                                                                 ],
                                //               //                                                               ),
                                //               //
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                                                       ]
                                //               //                                                   ),
                                //               //                                                   TableRow(
                                //               //
                                //               //                                                       children: [
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //                                                               Row(
                                //               //                                                                 children: [
                                //               //
                                //               //                                                                   Icon(Icons.call,color: Color.fromRGBO(246, 99, 9, 100))
                                //               //                                                                 ],
                                //               //                                                               ),
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //
                                //               //                                                               storedocs[i]['contact']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                //               //                                                               InkWell(
                                //               //                                                                   onTap:(){
                                //               //
                                //               //                                                                     FlutterPhoneDirectCaller.callNumber(storedocs[i]['contact']);
                                //               //                                                                   },
                                //               //                                                                   child: Column(
                                //               //                                                                     children: [
                                //               //                                                                       Text(storedocs[i]['contact'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                //               //                                                                     ],
                                //               //                                                                   )),
                                //               //
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                                                       ]
                                //               //                                                   ),
                                //               //                                                   TableRow(
                                //               //
                                //               //                                                       children: [
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //                                                               Row(
                                //               //                                                                 children: [
                                //               //
                                //               //                                                                   Icon(Icons.webhook_sharp,color: Color.fromRGBO(246, 99, 9, 100))
                                //               //                                                                 ],
                                //               //                                                               ),
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Column(
                                //               //                                                             children: [
                                //               //
                                //               //                                                               storedocs[i]['website']==''? Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                //               //                                                               InkWell  (
                                //               //                                                                   onTap:() async{
                                //               //
                                //               //
                                //               //                                                                     var uri = Uri.parse(storedocs[i]['website'].toString());
                                //               //                                                                     if (await canLaunchUrl(uri)){
                                //               //                                                                       await launchUrl(uri);
                                //               //                                                                     } else {
                                //               //                                                                       // can't launch url
                                //               //                                                                     }
                                //               //
                                //               //
                                //               //                                                                   },
                                //               //                                                                   child: Column(
                                //               //                                                                     children: [
                                //               //                                                                       Text(storedocs[i]['website'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blue),),
                                //               //                                                                     ],
                                //               //                                                                   )),
                                //               //
                                //               //                                                             ],
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                                                       ]
                                //               //                                                   ),
                                //               //
                                //               //
                                //               //                                                 ],
                                //               //                                               ),
                                //               //                                             ),
                                //               //                                           ],
                                //               //                                         ),
                                //               //                                       ),
                                //               //                                     ),
                                //               //                                   ),
                                //               //                                   SingleChildScrollView(
                                //               //                                     scrollDirection: Axis.vertical,
                                //               //                                     child: Container(
                                //               //                                       child: Center(
                                //               //                                         child: Column(
                                //               //                                           children: [
                                //               //                                             Padding(
                                //               //                                               padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                //               //                                               child: Table(
                                //               //                                                 columnWidths: {
                                //               //                                                   0: FlexColumnWidth(2),
                                //               //                                                   1: FlexColumnWidth(2),
                                //               //                                                   2: FlexColumnWidth(2),
                                //               //
                                //               //                                                 },
                                //               //
                                //               //                                                 children: [
                                //               //
                                //               //                                                   TableRow(
                                //               //                                                       children: [
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Container(
                                //               //                                                             color:   Colors.white,
                                //               //                                                             child:
                                //               //                                                             FadeInImage.assetNetwork(
                                //               //                                                                 placeholder: 'assets/tem.jpg',
                                //               //                                                                 image:  storedocs[i]['image'],width: 130,height: 70
                                //               //                                                             ),
                                //               //
                                //               //
                                //               //                                                             //  Image.network(storedocs[i]['image'],width: 130,height: 70)
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Container(
                                //               //                                                             color:   Colors.white,
                                //               //                                                             child:
                                //               //                                                             FadeInImage.assetNetwork(
                                //               //                                                                 placeholder: 'assets/tem.jpg',
                                //               //                                                                 image:  storedocs[i]['img1'],width: 130,height: 70
                                //               //                                                             ),
                                //               //                                                             // Image.network(storedocs[i]['img1'],width: 130,height: 70)
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //                                                         Padding(
                                //               //                                                           padding: const EdgeInsets.all(8.0),
                                //               //                                                           child: Container(
                                //               //                                                             color:   Colors.white,
                                //               //                                                             child:
                                //               //                                                             FadeInImage.assetNetwork(
                                //               //                                                                 placeholder: 'assets/tem.jpg',
                                //               //                                                                 image: storedocs[i]['img2'],width: 130,height: 70
                                //               //                                                             ),
                                //               //                                                             // Image.network(storedocs[i]['img2'],width: 130,height: 70)
                                //               //                                                           ),
                                //               //                                                         ),
                                //               //
                                //               //
                                //               //
                                //               //
                                //               //                                                       ]
                                //               //                                                   ),
                                //               //
                                //               //                                                 ],
                                //               //                                               ),
                                //               //                                             ),
                                //               //                                           ],
                                //               //                                         ),
                                //               //                                       ),
                                //               //                                     ),
                                //               //                                   ),
                                //               //                                   SingleChildScrollView(
                                //               //                                     scrollDirection: Axis.vertical,
                                //               //                                     child: Padding(
                                //               //                                       padding: const EdgeInsets.all(8.0),
                                //               //                                       child: Container(
                                //               //                                         child: Center(
                                //               //                                           child: Column(
                                //               //                                             children: [
                                //               //                                               Container(
                                //               //                                                 child: storedocs[i]['Ami1']==''?  null: Padding(
                                //               //                                                   padding: const EdgeInsets.all(8.0),
                                //               //                                                   child:  Container(
                                //               //
                                //               //                                                     color:   Colors.white,
                                //               //
                                //               //                                                     child: InkWell(
                                //               //                                                       onTap: (){
                                //               //                                                         //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                //               //                                                       },
                                //               //                                                       child:ListTile(
                                //               //                                                         title:
                                //               //                                                         Text(storedocs[i]['Ami1'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                //               //                                                         leading: ConstrainedBox(
                                //               //                                                             constraints: const BoxConstraints(
                                //               //                                                                 minWidth: 50,
                                //               //                                                                 minHeight: 80,
                                //               //                                                                 maxWidth: 55,
                                //               //                                                                 maxHeight: 85
                                //               //                                                             ),
                                //               //                                                             child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),
                                //               //
                                //               //                                                       ),
                                //               //                                                     ),
                                //               //                                                   ),
                                //               //                                                 ),
                                //               //                                               ),
                                //               //                                               Container(
                                //               //                                                 child: storedocs[i]['Ami2']==''?  null: Padding(
                                //               //                                                   padding: const EdgeInsets.all(8.0),
                                //               //                                                   child:  Container(
                                //               //
                                //               //                                                     color:   Colors.white,
                                //               //
                                //               //                                                     child: InkWell(
                                //               //                                                       onTap: (){
                                //               //                                                         //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                //               //                                                       },
                                //               //                                                       child:ListTile(
                                //               //                                                         title:
                                //               //                                                         Text(storedocs[i]['Ami2'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                //               //                                                         leading: ConstrainedBox(
                                //               //                                                             constraints: const BoxConstraints(
                                //               //                                                                 minWidth: 50,
                                //               //                                                                 minHeight: 80,
                                //               //                                                                 maxWidth: 55,
                                //               //                                                                 maxHeight: 85
                                //               //                                                             ),
                                //               //                                                             child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),
                                //               //
                                //               //                                                       ),
                                //               //                                                     ),
                                //               //                                                   ),
                                //               //                                                 ),
                                //               //                                               ),
                                //               //                                               Container(
                                //               //                                                 child: storedocs[i]['Ami3']==''?  null: Padding(
                                //               //                                                   padding: const EdgeInsets.all(8.0),
                                //               //                                                   child:  Container(
                                //               //
                                //               //                                                     color:   Colors.white,
                                //               //
                                //               //                                                     child: InkWell(
                                //               //                                                       onTap: (){
                                //               //                                                         //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                //               //                                                       },
                                //               //                                                       child:ListTile(
                                //               //                                                         title:
                                //               //                                                         Text(storedocs[i]['Ami3'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                //               //                                                         leading: ConstrainedBox(
                                //               //                                                             constraints: const BoxConstraints(
                                //               //                                                                 minWidth: 50,
                                //               //                                                                 minHeight: 80,
                                //               //                                                                 maxWidth: 55,
                                //               //                                                                 maxHeight: 85
                                //               //                                                             ),
                                //               //                                                             child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),
                                //               //
                                //               //                                                       ),
                                //               //                                                     ),
                                //               //                                                   ),
                                //               //                                                 ),
                                //               //                                               ),
                                //               //                                               Container(
                                //               //                                                 child: storedocs[i]['Ami4']==''?  null: Padding(
                                //               //                                                   padding: const EdgeInsets.all(8.0),
                                //               //                                                   child:  Container(
                                //               //
                                //               //                                                     color:   Colors.white,
                                //               //
                                //               //                                                     child: InkWell(
                                //               //                                                       onTap: (){
                                //               //                                                         //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                //               //                                                       },
                                //               //                                                       child:ListTile(
                                //               //                                                         title:
                                //               //                                                         Text(storedocs[i]['Ami4'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                //               //                                                         leading: ConstrainedBox(
                                //               //                                                             constraints: const BoxConstraints(
                                //               //                                                                 minWidth: 50,
                                //               //                                                                 minHeight: 80,
                                //               //                                                                 maxWidth: 55,
                                //               //                                                                 maxHeight: 85
                                //               //                                                             ),
                                //               //                                                             child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),
                                //               //
                                //               //                                                       ),
                                //               //                                                     ),
                                //               //                                                   ),
                                //               //                                                 ),
                                //               //                                               ),
                                //               //
                                //               //
                                //               //                                             ],
                                //               //                                           ),
                                //               //                                         ),
                                //               //                                       ),
                                //               //                                     ),
                                //               //                                   ),
                                //               //                                   // SingleChildScrollView(
                                //               //                                   //   scrollDirection: Axis.vertical,
                                //               //                                   //   child: Container(
                                //               //                                   //     child: Center(
                                //               //                                   //       child: Column(
                                //               //                                   //         children: [
                                //               //                                   //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                //               //                                   //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                //               //                                   //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                //               //                                   //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                //               //                                   //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                //               //                                   //         ],
                                //               //                                   //       ),
                                //               //                                   //     ),
                                //               //                                   //   ),
                                //               //                                   // ),
                                //               //                                 ])
                                //               //                             )
                                //               //                           ])
                                //               //                       ),
                                //               //                     ),
                                //               //                   ],
                                //               //                 )
                                //               //             ),
                                //               //           ),
                                //               //         ),
                                //               //       );
                                //               //     }
                                //               // );
                                //
                                //               // Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                //
                                //             },
                                //
                                //             child: Container(
                                //
                                //               height: 120,
                                //
                                //               width: 195,
                                //
                                //
                                //               decoration: BoxDecoration(
                                //
                                //                   borderRadius: BorderRadius.circular(10),
                                //
                                //                   color: Colors.white
                                //
                                //               ),
                                //
                                //               // child: Column(
                                //               //
                                //               //   children: [
                                //               //
                                //               //     Row(
                                //               //
                                //               //       children: [
                                //               //
                                //               //
                                //               //         Padding(
                                //               //
                                //               //           padding: const EdgeInsets.all(8.0),
                                //               //
                                //               //           child: snapshot.connectionState==ConnectionState.waiting ?    Container(
                                //               //             // height: 100,
                                //               //             width: 200,
                                //               //             margin: const EdgeInsets.only(left: 12, right: 12),
                                //               //             decoration: BoxDecoration(
                                //               //               color: Colors.white,
                                //               //               borderRadius: BorderRadius.circular(10),
                                //               //             ),
                                //               //             child: Center(
                                //               //               child: Column(
                                //               //                 children: [
                                //               //                   CircularProgressIndicator(),
                                //               //                   Text('Check internet connection or location')
                                //               //                 ],
                                //               //               ),
                                //               //             ),
                                //               //           )
                                //               //               :Image.network(storedocs[i]['image'],width: 115,height: 70,),
                                //               //
                                //               //         ),
                                //               //         Align(
                                //               //             alignment: Alignment.topLeft,
                                //               //             child: Text((Geolocator.distanceBetween( _currentPosition!.latitude,_currentPosition!.longitude,double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long']))/1000).toString().substring(0, 4)
                                //               //                 +'km',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black26),))
                                //               //
                                //               //       ],
                                //               //
                                //               //     ),
                                //               //
                                //               //     Padding(
                                //               //
                                //               //       padding: const EdgeInsets.only(left: 4,right:4),
                                //               //
                                //               //       child: Column(
                                //               //
                                //               //         children: [
                                //               //
                                //               //           Text(storedocs[i]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines:1 ,overflow:TextOverflow.ellipsis,),
                                //               //
                                //               //         ],
                                //               //
                                //               //       ),
                                //               //
                                //               //     )
                                //               //
                                //               //   ],
                                //               //
                                //               // ),
                                //             ),
                                //
                                //           ),
                                //
                                //         )
                                //
                                //       ]
                                //     ],
                                //
                                //
                                //
                                //   ),
                                //
                                // ),
                                )
//                   for (var i=0; i<storedocs.length;i++)...[
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
// children: [
//   Text(storedocs[i]['title'])
// ],
//
//                           // Positioned(
//                           //     left: 0,
//                           //     bottom: 2,
//                           //     child: Padding(
//                           //       padding: const EdgeInsets.all(13.0),
//                           //       child:   Container(
//                           //         height: 120,
//                           //         width: 168,
//                           //         decoration: BoxDecoration(
//                           //
//                           //             borderRadius: BorderRadius.circular(10),
//                           //
//                           //             color: Colors.white
//                           //
//                           //         ),
//                           //
//                           //         child: Column(
//                           //           children: [
//                           //             Row(
//                           //               children: [
//                           //                 Padding(
//                           //                   padding: const EdgeInsets.all(8.0),
//                           //                   child: Image.network(storedocs[i]['image'],width: 130,height: 70,),
//                           //                 ),
//                           //               ],
//                           //             ),
//                           //             Text(storedocs[i]['title']),
//                           //           ],
//                           //         ),
//                           //
//                           //       ),
//                           //     )),
//
//                       ),
//                     ),
//                   ]
                          ],
                        ),
                        // floatingActionButton: FloatingActionButton(
                        //   onPressed: () async {
                        //     _getCurrentPosition();
                        //
                        //   },
                        //   child: Icon(Icons.location_disabled_outlined),
                        // ),
                        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      ),
                    );
            });
  }
}
