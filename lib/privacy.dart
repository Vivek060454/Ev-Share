import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',
            textAlign: TextAlign.center,
            style: GoogleFonts.aleo(textStyle: TextStyle(color: Colors.white))),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 0, 18, 50),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              Text(
                'PRIVACY.POLICY',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Ev Share built the EV Share app as a Free app. This SERVICE is provided by Ev Share at no cost and is intended for use as is.This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at EV Share unless otherwise defined in this Privacy Policy.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Information Collection and Use',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Ev Stataion. The information that I request will be retained on your device and is not collected by me in any way.The app does use third-party services that may collect information used to identify you.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Link to the privacy policy of third-party service providers used by the app',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Google Play Services',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                'AdMob',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                'Google Analytics for Firebase',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                'Firebase Crashlytics',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Log Data',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cookies',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your devices internal memory.This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cookies',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'I may employ third-party companies and individuals due to the following reasons:',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'To facilitate our Service;',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                'To provide the Service on our behalf;',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                'To perform Service-related services; or',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                'To assist us in analyzing how our Service is used.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Security',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Links to Other Sites',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Children’s Privacy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Changes to This Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of 2023-02-16',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at evdockin@gmail.com.',
                overflow: TextOverflow.ellipsis,
                maxLines: 25,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
