import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';

import 'package:uuid/uuid.dart';

class Sellpanel extends StatefulWidget {
  const Sellpanel({super.key});

  @override
  SellpanelState createState() {
    return SellpanelState();
  }
}

class SellpanelState extends State<Sellpanel> {
  final _formKey = GlobalKey<FormState>();

  var brand = '';
  var model = '';
  var des = '';
  var sellingprice = '';
  var actualprice = '';
  var drivingrange = '';
  var charginghours = '';
  var safety = '';
  var transmission = '';
  var seatingcapacity = '';
  var batterycapcity = '';
  var drivingtilltey = '';
  var phone = '';
  var addrese = '';
  var addreseA = '';
  var addresec = '';
  var addresep = '';
  final itee = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"
  ];
  String? selectede = 'Maharashtra';

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final TextEditingController _brandController = new TextEditingController();
  final TextEditingController _modelController = new TextEditingController();
  final TextEditingController _desController = new TextEditingController();
  final TextEditingController _priceController = new TextEditingController();
  final TextEditingController _actualpriceController =
      new TextEditingController();
  final TextEditingController _drivingrangeController =
      new TextEditingController();
  final TextEditingController _charginghoursController =
      new TextEditingController();
  final TextEditingController _safetyController = new TextEditingController();
  final TextEditingController _transmissionController =
      new TextEditingController();
  final TextEditingController _seatingcapacityController =
      new TextEditingController();
  final TextEditingController _batterycapacityController =
      new TextEditingController();
  final TextEditingController _drivingtillyetKmController =
      new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _addresesController = new TextEditingController();
  final TextEditingController _addreseAController = new TextEditingController();
  final TextEditingController _addresecController = new TextEditingController();
  final TextEditingController _addresepController = new TextEditingController();
  final TextEditingController _pyController = new TextEditingController();
  final TextEditingController _prController = new TextEditingController();
  final _auth = FirebaseAuth.instance;

  static String? get uid => null;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _desController.dispose();
    _priceController.dispose();
    _actualpriceController.dispose();
    _drivingrangeController.dispose();
    _charginghoursController.dispose();
    _safetyController.dispose();
    _transmissionController.dispose();
    _seatingcapacityController.dispose();
    _batterycapacityController.dispose();
    _drivingtillyetKmController.dispose();
    _phoneController.dispose();
    _addresesController.dispose();
    _addreseAController.dispose();
    _addresecController.dispose();
    _addresepController.dispose();

    super.dispose();
  }

  Future<void> addUser() async {
    UploadTask? uploadTask;
    UploadTask? uploadTask1;
    UploadTask? uploadTask2;
    final path = 'Ev/${imageName}';
    final file = File(imagePath!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    var url = await snapshot.ref.getDownloadURL();
    final path1 = 'EV1/${imageName1}';
    final file1 = File(imagePath1!.path);
    final ref1 = FirebaseStorage.instance.ref().child(path1);
    uploadTask1 = ref1.putFile(file1);
    final snapshot1 = await uploadTask1;
    var url1 = await snapshot1.ref.getDownloadURL();
    final path2 = 'EV2/${imageName2}';
    final file2 = File(imagePath2!.path);
    final ref2 = FirebaseStorage.instance.ref().child(path2);
    uploadTask2 = ref2.putFile(file2);
    final snapshot2 = await uploadTask2;
    var url2 = await snapshot2.ref.getDownloadURL();
    var uuid = Uuid();
    final curUuid = uuid.v1();
    CollectionReference usersell = FirebaseFirestore.instance
        .collection('usersell')
        .doc(_auth.currentUser?.uid)
        .collection('product_sell');
    usersell
        .doc(curUuid)
        .set({
          'name': storagee2.getItem('name1').toString(),
          'brand': brand,
          'model': model,
          'image': url,
          'img1': url1,
          'img2': url2,
          'des': des,
          'sellingprice': sellingprice,
          'drving range': drivingrange,
          'charging hours': charginghours,
          'safety': safety,
          'transmission': transmission,
          'seatingcapacity': seatingcapacity,
          'batterycapacity': batterycapcity,
          'actualprice': actualprice,
          'drivingtilltel': drivingtilltey,
          'phone': phone,
          'addreseA': addreseA,
          'addresec': addresec,
          'state': selectede,
          'addresep': addresep,
        })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));

    CollectionReference productsell =
        FirebaseFirestore.instance.collection('productsell');
    productsell
        .doc(curUuid)
        .set({
          'name': storagee2.getItem('name1').toString(),
          'brand': brand,
          'model': model,
          'image': url,
          'img1': url1,
          'img2': url2,
          'des': des,
          'sellingprice': sellingprice,
          'drving range': drivingrange,
          'charging hours': charginghours,
          'safety': safety,
          'transmission': transmission,
          'seatingcapacity': seatingcapacity,
          'batterycapacity': batterycapcity,
          'actualprice': actualprice,
          'drivingtilltel': drivingtilltey,
          'phone': phone,
          'addreseA': addreseA,
          'addresec': addresec,
          'state': selectede,
          'addresep': addresep,
        })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
  }

  clearText() {
    _brandController.clear();
    _modelController.clear();
    _desController.clear();
    _priceController.clear();
    _actualpriceController.clear();
    _drivingrangeController.clear();
    _charginghoursController.clear();
    _safetyController.clear();
    _transmissionController.clear();
    _seatingcapacityController.clear();
    _batterycapacityController.clear();
    _drivingtillyetKmController.clear();
    _phoneController.clear();
    _addresesController.clear();
    _addreseAController.clear();
    _addresecController.clear();
    _addresepController.clear();
  }

  String imageName = '';
  XFile? imagePath;
  String imageName1 = '';
  XFile? imagePath1;
  String imageName2 = '';
  XFile? imagePath2;
  final ImagePicker _picker1 = ImagePicker();
  final ImagePicker _picker2 = ImagePicker();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Sell Your EV',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.aleo(textStyle: TextStyle(color: Colors.white)),
            ),
            //  title: const Text('Tritan Bikes'),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            //  backgroundColor: const Color.fromRGBO(100, 0, 0, 10),
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
                          'Personal Information*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _brandController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Brand Name',
                        hintText: 'Brand Name',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter brand name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _modelController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Model Name',
                        labelText: 'Model Name',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter model name';
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
                          'Upload Image of Bikes*',
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
                    child: Column(
                      children: [
                        imageName1 == ''
                            ? Container()
                            : Text(
                                '${imageName1}',
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
                    child: Column(
                      children: [
                        imageName2 == ''
                            ? Container()
                            : Text(
                                '${imageName2}',
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
                          'Description of EV*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
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
                        labelText: 'Write a breif information',
                        hintText:
                            'Write a breif information about your product.\n'
                            'Eg:Ev Vehicles years,Damages,sracth,etc',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description of Bikes';
                        }
                        if (value.length < 50) {
                          return 'Write atleast 50 letter';
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
                          'Ev Information*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _priceController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Selling price',
                        labelText: 'Selling price',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter selling rate';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _drivingrangeController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Driving Range',
                        labelText: 'Driving Range',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter selling rate';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _charginghoursController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Charging Hours',
                        labelText: 'Charging Hours',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter charging hours';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _safetyController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Safety',
                        labelText: 'Safety',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter safety';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _transmissionController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Transmission',
                        labelText: 'Transmission',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter transmission';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: _seatingcapacityController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Seating capacity',
                        labelText: 'Seating capacity',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please seating capacity';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _batterycapacityController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Battery Capacity',
                        labelText: 'Battery Capacity',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter battery capacity';
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
                          'Personal Information*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _actualpriceController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Purchase Rate',
                        labelText: 'Purchase Rate',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter purchse rata';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _drivingtillyetKmController,

                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Drving Till Yet In KM',
                        labelText: 'Drving Till Yet In KM',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter KM';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Phone Number',
                        labelText: 'Phone Number',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Phone number';
                        }
                        if (value.length < 10 || value.length > 10) {
                          return 'Phone number is not valid';
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
                          'Addresse*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _addreseAController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      maxLines: 1,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Area name',
                        labelText: 'Area name',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Plese enter area name ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _addresecController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'City',
                        labelText: 'City',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city name';
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
                          'Select State*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Container(
                        width: 360,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectede,
                              items: itee
                                  .map((ite) => DropdownMenuItem<String>(
                                        value: ite,
                                        child: Text(ite,
                                            style: TextStyle(fontSize: 20)),
                                      ))
                                  .toList(),
                              onChanged: (items) =>
                                  setState(() => selectede = items),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _addresepController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Pincode',
                        labelText: 'Pincode',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pincode';
                        }
                        // if (value.length == 6) {
                        //    return 'Enter valid Pincode';
                        // }
                        if (value.length > 6 || value.length < 6) {
                          return 'Enter valid Pincode';
                        }
                        return null;
                      },
                    ),
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
                            brand = _brandController.text;
                            model = _modelController.text;
                            des = _desController.text;
                            sellingprice = _priceController.text;
                            actualprice = _actualpriceController.text;
                            drivingrange = _drivingrangeController.text;
                            charginghours = _charginghoursController.text;
                            safety = _safetyController.text;
                            transmission = _transmissionController.text;
                            seatingcapacity = _safetyController.text;
                            batterycapcity = _batterycapacityController.text;
                            drivingtilltey = _drivingtillyetKmController.text;
                            phone = _phoneController.text;
                            addrese = _addresesController.text;
                            addreseA = _addreseAController.text;
                            addresec = _addresecController.text;
                            addresep = _addresepController.text;

                            addUser();
                            clearText();

                            Fluttertoast.showToast(msg: "Bikes Posted");
                            // Navigator.of(context).pop(Sellpanelupload);
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

  //String collectionName = 'Image';
  //final storageRef = FirebaseStorage.instance.ref();

// _uploadImage()async{
//   //final String collectionName = 'Image';
//
//
// //       final path='files/${imageName}';
// //       final file =File(imagePath!.path);
// //       final ref=FirebaseStorage.instance.ref().child(path);
// //       uploadTask =ref.putFile(file);
// //       final snapshot=await uploadTask!.whenComplete((){
// //
// //
// //       });
// // var url = await snapshot.ref.getDownloadURL();
// // FirebaseFirestore.instance.collection("")
//
//   //  print('Downloaded linl:$url');
// // return url;
//
//
//      // Reference ref =FirebaseStorage.instance.ref().child('Image');
//    //   await ref.putFile(File(imagePath!.path));
//    //  String url =await ref.getDownloadURL();
//    //   return url;
//
//
//
//
//
//     //final storage = FirebaseStorage.instance.ref();
//    // final Directory systemTempDir =Directory.systemTemp;
//   //  final byteData = await rootBundle.load(img);
//   //  final file =File(imagePath!.path);
//    // TaskSnapshot snapshot =await storage
//       //  .child(collectionName).putFile(File(imagePath!.path));
//
//    // if(snapshot.state==TaskState.success){
//      // final String url=await snapshot.ref.getDownloadURL();
//      // return url;
//     }
//
  //String uploadFileName =DateTime.now().millisecondsSinceEpoch.toString()+'.jpg';
  // TaskSnapshot snapshot =await

  // Reference reference= storageRef.child(collectionName).child(uploadFileName);
  // UploadTask uploadTask =reference.putFile(File(imagePath!.path));

//url=await reference.getDownloadURL().toString();

  //  _showMessage(String msg){
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   content:Text(msg),
  //   duration:const Duration(seconds:3),
  // ));
  // }
  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
    final XFile? image1 = await _picker1.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath1 = image1;
        imageName1 = image1!.name.toString();
      });
    }
    final XFile? image2 = await _picker2.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath2 = image2;
        imageName2 = image2!.name.toString();
      });
    }
  }
}
