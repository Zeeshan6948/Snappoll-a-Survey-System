import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
//import 'package:firebase_signin/screens/home_screen.dart';
//import 'package:firebase_signin/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/screens/main_page.dart';
import 'package:snap_poll/screens/terms_and_conditions.dart';

import '../global/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isChecked = false;
  static List<String> RolesList = <String>[
    'Owner',
    'Viewer',
    'Editor',
    'Controller'
  ];
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _DepartmentTextController = TextEditingController();
  TextEditingController _RoleTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  bool displayRoleList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColorsX.appBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: ColorsX.white),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/uni_logo.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 50,
                ),
                GlobalWidgets().reusableTextField("Enter UserName",
                    Icons.person_outline, false, _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                GlobalWidgets().reusableTextField("Enter Email Id",
                    Icons.email_outlined, false, _emailTextController),
                // const SizedBox(
                //   height: 20,
                // ),
                // GlobalWidgets().reusableTextField("Enter Department",
                //     Icons.apartment_outlined, false, _DepartmentTextController),
                // const SizedBox(
                //   height: 20,
                // ),
                // reusableDropDownField(
                //     displayRoleList,
                //     RolesList,
                //     context,
                //     "Select the Desired Role",
                //     Icons.person_4_outlined,
                //     _RoleTextController),
                const SizedBox(
                  height: 20,
                ),
                GlobalWidgets().reusableTextField("Enter Password",
                    Icons.lock_outlined, true, _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                consentForm(context),
                GlobalWidgets().firebaseUIButton(context, "Sign Up", () {
                  if (isChecked) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Created New Account");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()));
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text(
                            'The email address is already in use by another account'),
                      ));
                      //print("Error ${error.toString()}");
                    });
                  } else {
                    GlobalWidgets.showToast(
                        'Please accept the consent form to continue');
                  }
                })
              ],
            ),
          ))),
    );
  }

  Widget consentForm(context) {
    return Container(
      child: CheckboxListTile(
        title: const Text(" ", style: TextStyle(color: Colors.black87)),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
        secondary: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsAndConditions()));
          },
          child: const Text(
            " Accept consent form(Click here for details)",
            style:
                TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Container reusableDropDownField(bool displayList, List<String> m_list,
      context, String text, IconData icon, TextEditingController controller) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: ColorsX.uBdarkestBlue,
            borderRadius: BorderRadius.circular(25)),
        child: TextField(
          readOnly: true,
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  displayRoleList = !displayRoleList;
                });
              },
              child: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            labelText: text,
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: ColorsX.uBdarkestBlue,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
          ),
        ),
      ),
      displayList
          ? Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: ColorsX.uBlightestBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                    )
                  ]),
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  padding: const EdgeInsets.all(8),
                  itemCount: m_list.length,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.text = m_list[index];
                          });
                        },
                        child: ListTile(
                          title: Text(m_list[index]),
                        ));
                  })),
            )
          : SizedBox()
    ]));
  }
}
