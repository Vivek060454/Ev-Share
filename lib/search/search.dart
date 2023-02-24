import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller1 = TextEditingController();
  final LocalStorage fromlocation = new LocalStorage('localstorage_app');
  var uuid = Uuid();
  String _session = '123456';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    _controller1.addListener(() {
      onChang();
    });
    // TODO: implement initState
    super.initState();
  }

  void onChang() {
    if (_session == null) {
      setState(() {
        _session = uuid.v4();
      });
    }
    getSuggesion(_controller1.text);
  }

  void getSuggesion(String input) async {
    String KPlace_API_KEY = 'AIzaSyBTbiefudQLHoX7LI1lfI5uc4f3MuWstPI';

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&$KPlace_API_KEY&sessiontoken=$_session';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print(data);
    if (response.statusCode == 200) {
      print(response.body.toString());
      setState(() {
        _placeList = jsonDecode(response.body.toString())['prediction'];
      });
    } else {
      throw Exception('failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _controller1,
          decoration: InputDecoration(hintText: 'Search'),
        ),
        actions: [Icon(Icons.search)],
      ),
      body: ListView.builder(
          itemCount: _placeList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_placeList[index]['description']),
              onTap: () {},
            );
          }),
    );
  }
}
