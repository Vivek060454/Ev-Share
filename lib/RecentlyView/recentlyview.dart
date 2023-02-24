import 'package:evshare/RecentlyView/sqlrecentlyview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../EvServiceDetails.dart';
import '../EvShoowroomdetails.dart';
import '../evdetails.dart';

class RecentlyViewdata extends StatefulWidget {
  const RecentlyViewdata({Key? key}) : super(key: key);

  @override
  State<RecentlyViewdata> createState() => _RecentlyViewdataState();
}

class _RecentlyViewdataState extends State<RecentlyViewdata> {
  List<Map<String, dynamic>> _journals1 = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals1() async {
    final data = await SQLHelper1.getItems();
    setState(() {
      _journals1 = data;
      _isLoading = false;
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

  void _deleteItem(int id) async {
    await SQLHelper1.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a bookmark!'),
    ));
    _refreshJournals1();
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
  void initState() {
    _getCurrentPosition();
    super.initState();
    _refreshJournals1(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition?.latitude == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Recently View'),
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _journals1.length == 0
                    ? Center(child: Text('You have not viewed any Ev details'))
                    : ListView.builder(
                        itemCount: _journals1.length,
                        itemBuilder: (context, index) {
                          String marker = '';
                          if (_journals1[index]['Types'] ==
                              'Slow (Below 10kwh)') {
                            marker = "assets/Marker2.png";
                          }
                          if (_journals1[index]['Types'] ==
                              'Fast ( Above 50kwh)') {
                            marker = "assets/Marker4.png";
                          }
                          if (_journals1[index]['Types'] ==
                              'Midium (10 to 50kwh)') {
                            marker = "assets/Marker1.png";
                          }
                          if (_journals1[index]['Name'] == 'EvShowroom') {
                            marker = "assets/a.png";
                          }
                          if (_journals1[index]['Name'] == 'EVService') {
                            marker = "assets/Marker3.png";
                          }
                          return Card(
                            margin: const EdgeInsets.all(15),
                            child: ListTile(
                              leading: Image.asset(marker.toString()),
                              title: Text(_journals1[index]['LocationName']),

                              subtitle: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _journals1[index]['Addrses'],
                                          maxLines: 2,
                                        )),
                                    _currentPosition!.latitude == null
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.topLeft,
                                            child:
                                                _currentPosition!.longitude ==
                                                        null
                                                    ? Container()
                                                    : Text(
                                                        (Geolocator.distanceBetween(
                                                                        _currentPosition!
                                                                            .latitude,
                                                                        _currentPosition!
                                                                            .longitude,
                                                                        double.parse(_journals1[index]
                                                                            [
                                                                            'lati']),
                                                                        double.parse(_journals1[index]
                                                                            [
                                                                            'long'])) /
                                                                    1000)
                                                                .toString()
                                                                .substring(
                                                                    0, 4) +
                                                            'km',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey),
                                                      ),
                                          ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (_journals1[index]['Name'] == 'EVCharging') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Evdetails(
                                              _journals1[index],
                                              _currentPosition!.latitude,
                                              _currentPosition!.longitude)));
                                }
                                if (_journals1[index]['Name'] == 'EVService') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EvServicedetails(
                                                  _journals1[index],
                                                  _currentPosition!.latitude,
                                                  _currentPosition!
                                                      .longitude)));
                                }
                                if (_journals1[index]['Name'] == 'EvShowroom') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EvShowroomdetails(
                                                  _journals1[index],
                                                  _currentPosition!.latitude,
                                                  _currentPosition!
                                                      .longitude)));
                                }
                              },
                              // trailing: IconButton(
                              //     icon: const Icon(Icons.delete),
                              //     onPressed: () =>
                              //         setState(() {
                              //           _deleteItem(_journals1[index]['id']);
                              //         })
                              //
                              // )
                            ),
                          );
                        }),
          );
  }
}
