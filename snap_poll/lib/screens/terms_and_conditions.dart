import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
//import 'package:firebase_signin/screens/home_screen.dart';
//import 'package:firebase_signin/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/screens/main_page.dart';
import '../global/colors.dart';
import '../global/size_config.dart';

class TermsAndConditions extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consent form to use data",
              style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.bold
                     )
                            ),
                        ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
          child:
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Purpose of Data Collection:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'In order to provide you with a seamless and personalized experience while using our application, we may collect and use certain data. The data collected will be used for the following purposes:\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'User Account Management:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'To create and manage your user account, including authentication, password recovery, and account preferences.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Service Improvement:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'To analyze user behavior, trends, and preferences, and to enhance and optimize the functionality, performance, and usability of our application.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Personalized Content:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'To provide you with tailored content, recommendations, and suggestions based on your usage patterns and preferences.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Bug Fixes and Troubleshooting:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'To identify and resolve any technical issues, bugs, or errors that may occur while using our application.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Data Collection:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'The data we collect may include, but is not limited to, the following:\n', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'Personal Information:\n', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'This may include your name, email address, and other information you provide during the account registration process.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Usage Data:\n', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'This includes information about how you interact with our application, such as the features you use, the duration of your time on question.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Data Security and Confidentiality:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'We take data security and confidentiality seriously. All data collected through our application will be treated in accordance with applicable data protection laws and stored securely. We implement appropriate technical and organizational measures to safeguard your data against unauthorized access, disclosure, alteration, or destruction.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Data Sharing:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'We do not sell or rent your personal information to third parties. However, in certain cases, we may share your data with trusted service providers who assist us in delivering and improving our application. These service providers are contractually obligated to handle your data securely and are prohibited from using it for any other purposes. Only your survey answers may share anonymously in purpose to obtain results.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Data Retention:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'We will retain your data only for as long as necessary to fulfill the purposes outlined in this consent form, or as required by law. Once your data is no longer required, it will be securely deleted or anonymized.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Voluntary Consent and Right to Withdraw:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: 'Your participation in using our application is entirely voluntary, and you have the right to withdraw your consent for the collection and use of your data at any time. You can exercise this right by discontinuing the use of our application. However, please note that withdrawing consent may limit or prevent you from accessing certain features or functionality.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'By proceeding to use our application, you acknowledge that:\n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    TextSpan(text: '1. You have read and understood the information provided in this consent form.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: '2. You have had the opportunity to ask questions and have received satisfactory answers.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: '3. You consent to the collection and use of your data as described in this consent form.\n', style: TextStyle(fontSize: 12),),
                    TextSpan(text: 'Please Click the checkbox on Signup Screen to Accept the Consent and continue using SnapPoll ',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  ],
                ),
              )
          )
              ),


    );
  }
}
