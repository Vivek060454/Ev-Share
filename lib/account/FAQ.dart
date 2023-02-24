import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  var comment = '';
  final TextEditingController _commentController = new TextEditingController();

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
      ..text = "Name:       " +
          storagee2.getItem('name1').toString() +
          '\n' +
          'Meassge:  ' +
          '\n' +
          '                ' +
          comment;

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

  cleartext() {
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  BoxShadow(color: Colors.grey, offset: Offset(0, -3)),
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                      spreadRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              content: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Column(
                                  children: [
                                    Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller: _commentController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        decoration: InputDecoration(
                                          fillColor: Colors.grey.shade100,
                                          filled: true,
                                          hintText: 'Question',
                                          labelText: 'Question*',
                                          hintStyle: const TextStyle(
                                              height: 2,
                                              fontWeight: FontWeight.bold),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                        ),
                                        // The validator receives the text that the user has entered.
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              comment = _commentController.text;

                                              sendi();
                                              cleartext();
                                              Fluttertoast.showToast(
                                                  msg: "Review Added");
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        },
                                        child: Text('Add Question'))
                                  ],
                                ),
                              ),
                            ));
                  },
                  child: Text('Ask a Question',
                      style: GoogleFonts.signika(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  ButtonsTabBar(
                    backgroundColor: Color.fromRGBO(158, 63, 97, 100),
                    unselectedBackgroundColor: Colors.grey[300],
                    unselectedLabelStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.ev_station),
                        text: "EV Station",
                      ),
                      Tab(
                        icon: Icon(Icons.car_crash_rounded),
                        text: "EV Showroom",
                      ),
                      Tab(
                        icon: Icon(Icons.car_repair_outlined),
                        text: 'EV Service',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('How to add Ev Station?',
                                    style: GoogleFonts.signika(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                subtitle: Text(
                                    'In home page click on location marker and then click on Add Ev Station and fill the form.'),
                              ),
                              ListTile(
                                title: Text('How to check nearest location?',
                                    style: GoogleFonts.signika(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )),
                                subtitle: Text(
                                    'In home screen you can see a neartest location'),
                              )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('How to add Ev Showroom?',
                                    style: GoogleFonts.signika(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                subtitle: Text(
                                    'In home page click on location marker and then click on Ad Ev Showroom and fill the form.'),
                              ),
                              ListTile(
                                title: Text('How to check nearest location?',
                                    style: GoogleFonts.signika(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )),
                                subtitle: Text(
                                    'In home screen you can see a neartest location'),
                              )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('How to add Ev Services?',
                                    style: GoogleFonts.signika(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                subtitle: Text(
                                    'In home page click on location marker and then click on Add Ev Services and fill the form.'),
                              ),
                              ListTile(
                                title: Text('How to check nearest location?',
                                    style: GoogleFonts.signika(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )),
                                subtitle: Text(
                                    'In home screen you can see a neartest location'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
