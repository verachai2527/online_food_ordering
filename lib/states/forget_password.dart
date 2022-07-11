// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_food_ordering/utility/dialog.dart';
import 'package:online_food_ordering/utility/my_style.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  double screenHeight = 0, screenWidth = 0;
  bool redEye = true;
  String email = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
                    buildEmail(),
                    buildResetPasswordButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildResetPasswordButton() {
    return Container(
      width: screenWidth * 0.55,
      height: screenHeight * 0.053,
      margin: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: MyStyle().darkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            if ((email.isEmpty)) {
              normalDialog(context, 'Warning Message', 'Please input email');
            } else {
              changePassword();
            }
          },
          child: Text('Reset Password')),
    );
  }

  Future<void> changePassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value1) async {
      Navigator.of(context).pop();
    }).catchError(
            (onError) => normalDialog(context, onError.code, onError.message));
  }

  Container buildEmail() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
}
