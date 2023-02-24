import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var phone = "";
  var message1 = "";
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _messageController = new TextEditingController();

  sendi() async {
    final _auth = FirebaseAuth.instance;

    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = 'vivekp@evdock.app';
    String password = 'gckaicnfghpbbpdr';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Vivek Prajapati')
      ..recipients.add('vivekp@evdock.app')
      //..ccRecipients.addAll(['vivekprajapati080@mail.com'])
      //  ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Contact Us'
      // ..text='Order id,'+sum.toString()+_auth.currentUser!.uid.toString()
      //..text = product.map((product)=>product['brand'],).toList()
      //   ..text = product.map((product)=>product['model'],).toList()
      //  ..text = product.map((product)=>product['price'],).toList()
      //  ..text = sum.toString()
      ..text = "Name:       " +
          name +
          '\n' +
          'Phone:     ' +
          phone +
          '\n' +
          'Meassge:  ' +
          '\n' +
          '                ' +
          message1;

    // ..text = 'This is the plain text.\nThis is line 2 of the text part.';
//  ..html = "<h1>_pinController.text</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${e}: ${p.msg}');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  clearText() {
    _nameController.clear();
    _phoneController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact Us',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.aleo(textStyle: TextStyle(color: Colors.white))),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(1, 202, 0, 100),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter our name';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value == 0) {
                        return "Please enter your phone number";
                      }
                      if (value.length < 10 || value.length > 10) {
                        return "Please enter valid phone number";
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _messageController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: const TextStyle(
                          height: 2, fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter message";
                      }
                      if (value.length < 50) {
                        return "Please enter aleast 20 words ";
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(1, 202, 0, 100)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = _nameController.text;
                            phone = _phoneController.text;
                            message1 = _messageController.text;

                            clearText();
                            sendi();

                            Fluttertoast.showToast(
                                msg: "Message send succesfully");
                            // Navigator.of(context).pop(Sellpanelupload);
                          });
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
