import 'dart:async';
import 'dart:io';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:file_picker/file_picker.dart';

import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'map.dart';

class EVCharger extends StatefulWidget {
  final lati;
  final long;

  const EVCharger(this.lati, this.long, {Key? key}) : super(key: key);

  @override
  EVChargerState createState() {
    return EVChargerState();
  }
}

class EVChargerState extends State<EVCharger> {
  final _formKey = GlobalKey<FormState>();
  var locationname = "";
  var streetaddrese = "";
  var des = "";
  var lat = "";
  var lon = "";
  var connector = "";
  var type = "";
  var hour = "";
  var pupr = "";
  var payment = "";
  var phone = "";
  var gst = "";
  var amni = "";
  var parking = "";
  var image = "";
  var app = "";
  var play = "";
  var kwh = "";
  var typese = "";
  var insta = "";
  var fb = "";
  var web = "";

  final brands = [
    'Firefox',
    '91',
    'Unirox',
    'Rellyz',
    'Giant',
    'Trek',
  ];

  String? brand = 'Firefox';

  final pris = [
    '0-10k',
    '10k-20k',
    '20k-30k',
    '30k-40k',
    '40k-50k',
    '50k-60k',
    '60k-70k',
    '70k-80k',
    '80k-90k',
    '90k-100k',
    '100k-nk'
  ];

  @override
  void initState() {
    print(widget.long.toString());
    print(widget.lati.toString());
    // TODO: implement initState
    super.initState();
  }

  String? pri = '0-10k';

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

// final TextEditingController _brandController = new TextEditingController();
  final TextEditingController _locationnameController =
      new TextEditingController();
  final TextEditingController _streetaddreseController =
      new TextEditingController();
  final TextEditingController _desController = new TextEditingController();
  final TextEditingController _connectorController =
      new TextEditingController();
  final TextEditingController _typetroller = new TextEditingController();
  final TextEditingController _hourController = new TextEditingController();
  final TextEditingController _puprController = new TextEditingController();
  final TextEditingController _paymentController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _gstController = new TextEditingController();
  final TextEditingController _latiController = new TextEditingController();
  final TextEditingController _longController = new TextEditingController();
  final TextEditingController _amniController = new TextEditingController();
  final TextEditingController _parkingController = new TextEditingController();
  final TextEditingController _imageController = new TextEditingController();
  final TextEditingController _appController = new TextEditingController();
  final TextEditingController _playController = new TextEditingController();
  final TextEditingController _kwhController = new TextEditingController();
  final TextEditingController _typesController = new TextEditingController();
  final TextEditingController _instaController = new TextEditingController();
  final TextEditingController _fbController = new TextEditingController();
  final TextEditingController _webController = new TextEditingController();

  final typees = [
    'Wall',
    'Wall(BS1363)',
    'CCS/SAE',
    'CHAdeMO',
    'J-1772',
    'Type 2',
    'Type 3',
    'Three Phase',
    'Caravan Mains Sacket',
    'GB/T 2'
  ];

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

    // Printing all selected items on Terminal screen.
    print(tmpArray);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    //tmpArray.clear();
  }

  final chargers = [
    'Fast ( Above 50kwh)',
    'Midium (10 to 50kwh)',
    'Slow (Below 10kwh)'
  ];

  var charger = null;
  var typee = null;

  final _auth = FirebaseAuth.instance;

  static String? get uid => null;

  @override
  void dispose() {
    // _brandController.dispose();
    _locationnameController.dispose();
    _streetaddreseController.dispose();
    _desController.dispose();
    _connectorController.dispose();
    _typetroller.dispose();
    _hourController.dispose();
    _puprController.dispose();
    _paymentController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    _latiController.dispose();
    _longController.dispose();
    _amniController.dispose();
    _parkingController.dispose();
    _imageController.dispose();
    _appController.dispose();
    _playController.dispose();
    _kwhController.dispose();
    _typesController.dispose();
    _instaController.dispose();
    _fbController.dispose();
    _webController.dispose();
    super.dispose();
  }

  Future<void> addUser() async {
    if (tmpArray == null) {
      Fluttertoast.showToast(msg: "Select Amni");
    } else {
      UploadTask? uploadTask;

      final path = 'Image/${imageName}';
      final file = File(imagePath!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      var url = await snapshot.ref.getDownloadURL();

      CollectionReference Marker =
          FirebaseFirestore.instance.collection('Marker');
      Marker.doc()
          .set({
            "Name": 'EVCharging',
            'LocationName': locationname,
            'Addrses': streetaddrese,
            'Image': url,
            'Description': des,
            'lati': widget.lati.toString(),
            'long': widget.long.toString(),
            'Connector': typee,
            'Types': charger,
            'Kwh': kwh,
            'Payment': payment,
            'Hour': hour,
            'Parking': parking,
            'Phone': phone,
            'App': app,
            'Play': play,
            'Amni': tmpArray,
            'Insta': insta,
            'Fb': fb,
            'web': web,
            'dataa': FieldValue.arrayUnion([
              {
                "Rating": '2',
                'Comment': 'Excellent',
                'UserName': 'EV',
                'datee': DateTime.now().toString().substring(0, 10)
              }
            ]),
            //
            // 'Addrese':addrese,'Ami1':ami1,  'Ami2':ami2,'Ami3':ami3,'Ami4':ami4, 'ide':'',
            // 'contact':contact,'lati':lat,'long':lon,'title':title,'trust_name':trustname,'website':web,
            //
          })
          .then((valure) => print('Product Added'))
          .catchError((error) => print('failed to add Product:$error'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Draweer()));
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Sellpanelupload()));
      // print('User added');
    }
  }

//FirebaseFirestore firestoreRef =FirebaseFirestore.instance;
//FirebaseStorage storageRef =FirebaseStorage.instance;

  clearText() {
    _locationnameController.clear();
    _streetaddreseController.clear();
    _desController.clear();
    _connectorController.clear();
    _typetroller.clear();
    _hourController.clear();
    _puprController.clear();
    _paymentController.clear();
    _phoneController.clear();
    _gstController.clear();
    // _latiController.clear();
    // _longController.clear();
    _amniController.clear();
    _parkingController.clear();
    _imageController.clear();
    _appController.clear();
    _playController.clear();
    _kwhController.clear();
    _typesController.clear();
    _instaController.clear();
    _fbController.clear();
    _webController.clear();
  }

  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
            title: Text('EvCharger'),
            backgroundColor: Color.fromRGBO(1, 202, 0, 100)),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Location Name*',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _locationnameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Location Name',
                        labelText: 'Location Name*',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
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
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Street Addrese*',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _streetaddreseController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        labelText: 'Enter Addreses*',
                        filled: true,
                        hintText: 'Write Addreses',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter addrese';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Upload Image *',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        imageName == ''
                            ? Container()
                            : Text(
                                '${imageName}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        imagePicker();
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _desController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Write description',
                        labelText: 'Write description',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Charger Details*',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    //    height: 68,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Container(
                        //   width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Connector',
                                  style: TextStyle(fontSize: 15)),
                              value: typee,
                              items: typees
                                  .map((ite) => DropdownMenuItem<String>(
                                        value: ite,
                                        child: Text(ite,
                                            style: TextStyle(fontSize: 15)),
                                      ))
                                  .toList(),
                              onChanged: (items) =>
                                  setState(() => typee = items),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 'Wall','Wall(BS1363)','CCS/SAE','CHAdeMO','J-1772','Type 2','Type 3','Three Phase',
                  // 'Caravan Mains Sacket','GB/T 2'

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Types',
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                            value: charger,
                            items: chargers
                                .map((ite) => DropdownMenuItem<String>(
                                      value: ite,
                                      child: Text(ite,
                                          style: TextStyle(
                                            fontSize: 15,
                                          )),
                                    ))
                                .toList(),
                            onChanged: (items) =>
                                setState(() => charger = items),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _kwhController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'KWH*',
                        hintText: 'KWH',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter kwh';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _paymentController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Enter payment if not write N/A',
                        labelText: 'Payment*',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter payment if not enter N/A';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _hourController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Hour',
                        labelText: 'Hour*',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter hour';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _parkingController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Parking Levelc(Road,Parking etc)',
                        labelText: 'Parking Level*',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter parking';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Contact details*',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _phoneController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Phone number*',
                        hintText: 'Phone number',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                      // The validator receives the text that the user has entered.
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Application Link',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _appController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Appstore url',
                        labelText: 'Appstore url',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),

                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _playController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Playstore url',
                        labelText: 'Playstore url',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Social Link',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _instaController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Instagram url',
                        labelText: 'Instagram url',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),

                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _fbController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Facebook url',
                        labelText: 'Facebook url',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _webController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Website url',
                        labelText: 'Website url',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Select Aminities*',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),

                  ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: values.keys.map((String key) {
                      return CheckboxListTile(
                        title: new Text(
                          key,
                        ),
                        value: values[key],
                        onChanged: (value) {
                          setState(() {
                            values[key] = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(1, 202, 0, 100),
                        ),
                      ),
//color: Color.fromRGBO(100, 0, 0, 10),

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            locationname = _locationnameController.text;
                            streetaddrese = _streetaddreseController.text;
                            des = _desController.text;
                            connector = _connectorController.text;
                            type = _typetroller.text;
                            hour = _hourController.text;
                            pupr = _puprController.text;
                            payment = _paymentController.text;
                            phone = _phoneController.text;
                            gst = _gstController.text;
                            lat = _latiController.text;
                            lon = _longController.text;
                            amni = _amniController.text;
                            parking = _parkingController.text;
                            image = _imageController.text;
                            app = _appController.text;
                            play = _playController.text;
                            kwh = _kwhController.text;
                            typese = _typesController.text;
                            insta = _instaController.text;
                            fb = _fbController.text;
                            web = _webController.text;

                            // _uploadImage();
                            getCheckboxItems();
                            addUser();
                            clearText();

                            Fluttertoast.showToast(msg: "Posted");
                            //Navigator.of(context).pop();
                          });
                        }
                      },
                      child: Text("Post"),
                    ),
                  ),
                ]),
          ),
        ));
  }

  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }
}
