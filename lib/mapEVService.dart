import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'EvService.dart';

class MapEVService extends StatefulWidget {
  const MapEVService({Key? key}) : super(key: key);

  @override
  State<MapEVService> createState() => _MapEVServiceState();
}

class _MapEVServiceState extends State<MapEVService> {
  var lati;
  var long;
  Completer<GoogleMapController> _controller = Completer();

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

  void initState() {
    initBannerAd();

    _getCurrentPosition();
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      // _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
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

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move marker to select location'),
        backgroundColor: Color.fromRGBO(1, 202, 0, 100),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(158, 63, 97, 100)),
                ),
                onPressed: () {
                  if (lati == null || long == null) {
                    Fluttertoast.showToast(
                        msg: "Drag Market to select location");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EVService(lati, long)));
                  }
                },
                child: Text('Next')),
          )
        ],
      ),
      body: _currentPosition == null
          ? //check if loading is true or false
          Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Check internet connection or location')
                ],
              ),
            )
          : Stack(children: [
              GoogleMap(
                markers: Set<Marker>.of(
                  <Marker>[
                    Marker(
                        onTap: () {
                          print('Tapped');
                        },
                        draggable: true,
                        markerId: MarkerId('Marker'),
                        position: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        onDragEnd: ((newPosition) {
                          lati = newPosition.latitude;
                          long = newPosition.longitude;
                          print(newPosition.latitude);
                          print(newPosition.longitude);
                        }))
                  ],
                ),
                onTap: (position) {
                  //   _customInfoWindowController.);
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
                mapType: MapType.normal,
                compassEnabled: true,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  _customInfoWindowController.googleMapController = controller;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    zoom: 14),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: isAdLoaded
                    ? SizedBox(
                        height: bannerAd.size.height.toDouble(),
                        width: bannerAd.size.width.toDouble(),
                        child: AdWidget(
                          ad: bannerAd,
                        ),
                      )
                    : SizedBox(),
              ),
            ]),
    );
  }
}
