import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evshare/Sellupload/sellpanel.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Sellpanelupload extends StatefulWidget {
  const Sellpanelupload({Key? key}) : super(key: key);

  @override
  State<Sellpanelupload> createState() => _SellpaneluploadState();
}

class _SellpaneluploadState extends State<Sellpanelupload> {
  late User? user;
  late final Stream<QuerySnapshot> productsellStream;
  late CollectionReference productsell;

  get _firebaseAuth => null;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    productsellStream = FirebaseFirestore.instance
        .collection('usersell')
        .doc(user?.uid)
        .collection("product_sell")
        .snapshots();
    productsell = FirebaseFirestore.instance.collection('product_sell');
    super.initState();
  }

  Future deleteUser(id) {
    FirebaseFirestore.instance
        .collection("usersell")
        .doc(user?.uid)
        .collection("product_sell")
        .doc(id)
        .delete()
        .then((value) => print('Product Deleted'))
        .catchError((error) => print('failed to delete Product:$error'));
    ;
    return FirebaseFirestore.instance
        .collection("productsell")
        .doc(id)
        .delete()
        .then((value) => print('Product Deleted'))
        .catchError((error) => print('failed to delete Product:$error'));

    //print("User Deleted $id");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: productsellStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();

          return Scaffold(
            appBar: AppBar(
                title: Text(
                  'Sell Your Ev',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aleo(
                      textStyle: TextStyle(color: Colors.white)),
                ),
                actions: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(158, 63, 97, 100)),
                        ),
                        onPressed: () {
                          if (storedocs.length == 2) {
                            Fluttertoast.showToast(
                                msg: "You can sell upto two bikes");
                          }
                          if (storedocs.length < 2) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Sellpanel()));
                          }
                        },
                        child: Text('Upload EV'),
                      ))
                ],

                //  title: const Text('Tritan Bikes'),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                //  backgroundColor: const Color.fromRGBO(100, 0, 0, 10),
                backgroundColor: Color.fromRGBO(1, 202, 0, 100)),
            body: Column(children: [
              // Padding(
              //   padding: const EdgeInsets.all(13.0),
              //   child: SizedBox(
              //     height: 50,
              //     width: 150,
              //     child: FloatingActionButton.extended(
              //       backgroundColor:Color.fromARGB(255, 43, 72, 101),
              //
              //       shape: BeveledRectangleBorder(
              //           borderRadius: BorderRadius.circular(5)),
              //       onPressed: () {
              //         if (storedocs.length==2){
              //           Fluttertoast.showToast(msg: "You can sell upto two bikes");
              //         }
              //         if(storedocs.length<2) {
              //           Navigator.pushReplacement(context,
              //               MaterialPageRoute(
              //                   builder: (context) => Sellpanel()));
              //         }},
              //
              //     //  icon: Icon(Icons.directions_bike),
              //       label: Text('Upload EV'),
              //
              //     ),
              //   ),
              // ),
              // Divider(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              //       child: Text('Uploaded Ev', style: GoogleFonts.signika(textStyle: TextStyle(
              //           fontSize: 25, fontWeight: FontWeight.w500,color: Color.fromARGB(255,0 , 18, 50) )),),
              //     ),
              //   ],
              // ),
              storedocs.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Click on "Upload Ev"!\n         for selling Ev',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: storedocs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            storedocs[index]['image'] ?? "ss",
                          ),
                          title: Text(
                            storedocs[index]['brand'] ?? "ss",
                            style: GoogleFonts.reemKufi(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 15, 52, 96)),
                            ),
                          ),
                          subtitle: Text(
                            storedocs[index]['model'],
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                print(storedocs[index]['id']);
                                setState(() {});
                                deleteUser(storedocs[index]['id']);
                              },
                              icon: Icon(
                                Icons.delete,
                              )),
                        );
                      })
              // if(storedocs.isEmpty)
              //   Text('You have not uploaded any bikes !\n         Upload your first bike'
              //     ,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,),),
              //
              // for (var i = 0; i < storedocs.length; i++) ...[
              //   Expanded(
              //     child: Container(
              //       //color: Colors.white,
              //
              //       child: Stack(
              //         children: <Widget>[
              //           Positioned(
              //               left: 1,
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(10),
              //                   border: Border.all(color: Color.fromARGB(255,0 , 18, 50),),
              //                   // boxShadow: [
              //                   //   BoxShadow(
              //                   //       color: Color.fromRGBO(0, 0, 100, 0),
              //                   //       offset: Offset(3, 3)),
              //                   //   BoxShadow(
              //                   //       color: Color.fromRGBO(0, 0, 100, 0),
              //                   //       offset: Offset(3, 3),
              //                   //       blurRadius: 2,
              //                   //       spreadRadius: 1)
              //                   // ],
              //                 ),
              //                 constraints:
              //                 BoxConstraints(minWidth: 320, minHeight: 168),
              //               )),
              //           Positioned(
              //
              //             top: 5,
              //             left: 1,
              //             child: Image.network( storedocs[i]['image'] ?? "ss",
              //               width: 100, height: 100,),
              //           ),
              //           Positioned(
              //               top: 1,
              //               left: 130,
              //               child:
              //               Text(storedocs[i]['brand'] ?? "ss",style: GoogleFonts.reemKufi(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 25,color: Color.fromARGB(255, 15, 52, 96) ),)
              //
              //               ),
              //           Positioned(
              //               top: 32,
              //               left: 130,
              //               child: Text(
              //                 storedocs[i]['model'],
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.w500, fontSize: 20),
              //               )),
              //           Positioned(
              //               top: 65,
              //               left: 130,
              //               child: Container(
              //                 height: 80,
              //                 width: 190,
              //                 child: Text(
              //                   storedocs[i]['des'],
              //                   maxLines: 3,
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.w400, fontSize: 20),
              //                 ),
              //               )),
              //           Positioned(
              //               top: 140,
              //               left: 13,
              //               child: Container(
              //                 height: 80,
              //                 width: 190,
              //                 child: Text('Rs'+
              //                     storedocs[i]['actualprice']+'/-',
              //
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.w500, fontSize: 15),
              //                 ),
              //               )),
              //           Positioned(
              //               top: 5,
              //               left: 310,
              //               child: IconButton(
              //                   onPressed: () {
              //                     print(storedocs[i]['id']);
              //                     setState(() {});
              //                     deleteUser(storedocs[i]['id']);
              //                   },
              //                   icon: Icon(
              //
              //                     Icons.delete,
              //                     color: Color.fromARGB(255, 43, 72, 101),
              //                     size: 60,
              //                   ))),
              //         ],
              //       ),
              //     ),
              //   )
              // ],
            ]),
          );
        });
  }
}
