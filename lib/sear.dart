import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'EvServiceDetails.dart';
import 'EvShoowroomdetails.dart';
import 'evdetails.dart';

class Sear extends StatefulWidget {
  @override
  _SearState createState() => _SearState();
}

class _SearState extends State<Sear> {
  String name = "";

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

  @override
  void initState() {
    _getCurrentPosition();
    FirebaseFirestore.instance.collection('Marker');
    // TODO: implement initState
    super.initState();
  }

  String? _currentAddress;

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

  @override
  Widget build(BuildContext context) {
    return _currentPosition?.latitude == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: (name != "" && name != null)
                  ? FirebaseFirestore.instance
                      .collection('Marker')
                      .where("LocationName", isGreaterThanOrEqualTo: name)
                      .snapshots()
                  : FirebaseFirestore.instance.collection("Marker").snapshots(),
              builder: (context, snapshot) {
                final List storedocs = [];
                snapshot.data?.docs.map((DocumentSnapshot document) async {
                  Map a = document.data() as Map<String, dynamic>;
                  storedocs.add(a);
                  a['id'] = document.id;
                }).toList();

                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(storedocs[index]['LocationName']),
                            subtitle: Text(storedocs[index]['Name']),
                            onTap: () {
                              if (storedocs[index]['Name'] == 'EVCharging') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Evdetails(
                                            storedocs[index],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[index]['Name'] == 'EVService') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvServicedetails(
                                            storedocs[index],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                              if (storedocs[index]['Name'] == 'EvShowroom') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvShowroomdetails(
                                            storedocs[index],
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude)));
                              }
                            },
                          );
                        },
                      );
              },
            ),
          );
  }
}
