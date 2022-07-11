import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:online_food_ordering/models/user_model.dart';
import 'package:online_food_ordering/utility/dialog.dart';
import 'package:online_food_ordering/utility/my_style.dart';
import 'package:online_food_ordering/utility/web_firebase_connection.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _passwordController = new TextEditingController();
  double screenHeight = 0, screenWidth = 0;
  bool redEye = true;
  String displayName = "", email = "", password = "", confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: MyStyle().primaryColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MyStyle().buildBackground(screenWidth, screenHeight),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildUser(),
                    buildEmail(),
                    buildPassword(),
                    buildConfirmPassword(),
                    buildCreateAccountButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCreateAccountButton() {
    return Container(
      width: screenWidth * 0.55,
      height: screenHeight * 0.053,
      margin: EdgeInsets.only(top: 30),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: MyStyle().darkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            if ((displayName.isEmpty) ||
                (email.isEmpty) ||
                (password.isEmpty) ||
                (confirmPassword.isEmpty)) {
              normalDialog(
                  context, 'Warning Message', 'Please input all fields');
            } else {
              if (password != confirmPassword) {
                normalDialog(context, 'Warning Message',
                    'Password and Confirm Password are not matching');
              } else {
                if (validatePassword(password)) {
                  uploadNewAccountInformation();
                } else {}
              }
            }
          },
          child: Text('Create Account')),
    );
  }

  Future<Null> uploadNewAccountInformation() async {
    /////connect firebase
    await Firebase.initializeApp(
            // options: firebaseOptions(),
            )
        .then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value1) async {
        await value1.user!.updateDisplayName(displayName).then((value2) async {
          // print('Display Name success update');
          String uid = value1.user!.uid;
          UserModel userModel = UserModel(
              name: displayName,
              email: email,
              phone: "-",
              imagePath: "",
              dateOfBirth: DateTime.now());
          Map<String, dynamic> data = userModel.toMap();
          await FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .set(data)
              .then((value) {
            print("Insert data Success");
            Navigator.pushNamedAndRemoveUntil(
                context, '/profileDetail', (route) => false);
          });

          // await normalDialog(context, 'Message', 'Create Account Successed')
          //     .then((value) => Navigator.pushNamed(context, '/authen'));
        });
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));
    });
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => displayName = value.trim(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Display Name',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.mail,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Email',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: Column(
        children: [
          TextField(
            controller: _passwordController,
            onChanged: (value) => password = value.trim(),
            obscureText: redEye,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      redEye = !redEye;
                    });
                  },
                  icon: Icon(
                    redEye
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye_sharp,
                    color: MyStyle().darkColor,
                  )),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyStyle().darkColor,
              ),
              labelStyle: MyStyle().darkStyle(),
              labelText: 'Password',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: MyStyle().darkColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: MyStyle().lightColor)),
            ),
          ),
          new SizedBox(
            height: 5,
          ),
          FlutterPwValidator(
            controller: _passwordController,
            minLength: 6,
            uppercaseCharCount: 1,
            numericCharCount: 1,
            specialCharCount: 1,
            width: 400,
            height: 120,
            onSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Password is valid"),
                  duration: Duration(milliseconds: 3000)));
            },
          ),
        ],
      ),
    );
  }

  bool validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password is empty"),
        duration: Duration(milliseconds: 3000),
      ));
      return false;
    } else {
      if (!regex.hasMatch(value)) {
        print("Invalid Password");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Password"),
          duration: Duration(milliseconds: 3000),
        ));
        return false;
      } else {
        return true;
      }
    }
  }

  Container buildConfirmPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => confirmPassword = value.trim(),
        obscureText: redEye,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  redEye = !redEye;
                });
              },
              icon: Icon(
                redEye
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye_sharp,
                color: MyStyle().darkColor,
              )),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Confirm Password',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container buildLogo() => Container(
        width: screenWidth * 0.3,
        child: MyStyle().showLogo(),
      );
}
