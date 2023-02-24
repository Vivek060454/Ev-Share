import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:evshare/sqldata/bookmarkdata.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'EvServiceDetails.dart';
import 'EvShoowroomdetails.dart';
import 'Home.dart';
import 'Sellupload/Evproduct.dart';
import 'account/account.dart';
import 'evchager.dart';
import 'evdetails.dart';
import 'search/googlesearch.dart';
import 'login.dart';
import 'map EVShowroom.dart';
import 'map evcharger.dart';
import 'mapEVService.dart';

class Draweer extends StatefulWidget {
  @override
  _DraweerState createState() => _DraweerState();
}

class _DraweerState extends State<Draweer> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Bookmarkdata(),
    EvProduct(),
    Accounts()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.car_rental),
                label: 'Product',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_sharp),
                label: 'Me',
                backgroundColor: Colors.white),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Color.fromRGBO(1, 202, 0, 100),
          iconSize: 25,
          onTap: _onItemTapped,
          elevation: 0),
    );
  }
}
