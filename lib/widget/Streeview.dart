import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';

class StreetView extends StatefulWidget {
  final lati;
  final long;

  const StreetView(this.lati, this.long, {Key? key}) : super(key: key);

  @override
  State<StreetView> createState() => _StreetViewState();
}

class _StreetViewState extends State<StreetView> {
  StreetViewController? streetViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterGoogleStreetView(
          initPos: LatLng(double.parse(widget.lati), double.parse(widget.long)),
          initSource: StreetViewSource.outdoor,
          initBearing: 30,
          onStreetViewCreated: (StreetViewController controller) async {
            streetViewController = controller;
          }),
    );
  }
}
