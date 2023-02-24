import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

import 'map.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final LocalStorage storage1 = new LocalStorage('localstorage_app');
  final LocalStorage stora1 = new LocalStorage('localstorage_app');
  Map<String, bool> values = {
    'EVCharging': false,
    'EVService': false,
    'EvShowroom': false,
  };
  Map<String, bool> values1 = {
    'RestRoom': false,
    'Parking': false,
    'Wifi': false,
    'Shopping': false,
    'Resturant': false,
  };

  @override
  void initState() {
    storage1.clear();
    // TODO: implement initState
    super.initState();
  }

  var tmpArray = [];

  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });
    if (tmpArray == null) {
      Fluttertoast.showToast(msg: 'Select atleast one types');
    } else {
      storage1.setItem('name', tmpArray);
      print(tmpArray);
    }
  }

  var tmpArray1 = [];

  getCheckboxItems1() {
    values1.forEach((key, value1) {
      if (value1 == true) {
        tmpArray1.add(key);
      }
    });
    stora1.setItem('name', tmpArray1);
    print(tmpArray1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Filter'),
          backgroundColor: Color.fromRGBO(1, 202, 0, 100)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    'Select Types',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.signika(
                        textStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(158, 63, 97, 100))),
                  ),
                ),
              ),
            ),

            ListView(
              shrinkWrap: true,
              children: values.keys.map((String key) {
                return CheckboxListTile(
                  title: new Text(key),
                  value: values[key],
                  activeColor: Color.fromRGBO(1, 202, 0, 100),
                  onChanged: (value) {
                    setState(() {
                      values[key] = value!;
                    });
                  },
                );
              }).toList(),
            ),
            // Divider(
            //   height: 1,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Align(alignment:Alignment.topLeft,child:  Padding(
            //     padding: const EdgeInsets.only(left: 10,),
            //     child: Text('Select Aminities',maxLines:5,overflow:TextOverflow.ellipsis,style: GoogleFonts.signika(textStyle: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color:  Color.fromRGBO(158,63,97,100))),),
            //   ),),
            // ),
            // ListView(
            //   shrinkWrap: true,
            //   children: values1.keys.map((String key) {
            //     return CheckboxListTile(
            //       title: new Text(key),
            //       value: values1[key],
            //       activeColor:Color.fromRGBO(1,202,0,100) ,
            //       onChanged: ( value) {
            //         setState(() {
            //           values1[key] = value!;
            //         });
            //       },
            //     );
            //   }).toList(),
            // ),

            ElevatedButton(
                onPressed: () {
                  getCheckboxItems();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Draweer()));
                },
                child: Text('Apply'))
          ],
        ),
      ),
    );
  }
}
