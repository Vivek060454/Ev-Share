import 'package:evshare/search/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Googlesearch extends StatefulWidget {
  const Googlesearch({Key? key}) : super(key: key);

  @override
  State<Googlesearch> createState() => _GooglesearchState();
}

class _GooglesearchState extends State<Googlesearch> {
  final TextEditingController _toController = new TextEditingController();
  final TextEditingController _fromController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Route'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 15, left: 13, right: 13),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.grey,
                ),
                boxShadow: [
                  // BoxShadow(
                  //     color:  Colors.grey,
                  //     offset: Offset(0,- 3)),
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                      spreadRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(4),
                      },
                      //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                      children: [
                        TableRow(children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search()));
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, left: 5, right: 5),
                                child: Text('From:')),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _fromController,
                                textInputAction: TextInputAction.none,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  hintText: 'Location Name',
                                  hintStyle: const TextStyle(
                                      height: 2, fontWeight: FontWeight.bold),
                                ),
                                // The validator receives the text that the user has entered.
                              ),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 5, right: 5),
                              child: Text('To:')),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _toController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                hintText: 'Location Name',
                                hintStyle: const TextStyle(
                                    height: 2, fontWeight: FontWeight.bold),
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
