import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:online_food_ordering/utility/my_style.dart';

import '../utility/dialog.dart';
import '../utility/web_firebase_connection.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double screenHeight = 0, screenWidth = 0;
  bool redEye = true;
  String email = '', password = '';
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // floatingActionButton: buildCreateAccount(),
      body: SafeArea(
        child: Stack(
          children: [
            MyStyle().buildBackground(screenWidth, screenHeight),
            // Positioned(
            //   top: screenHeight * 0.03,
            //   left: screenWidth * 0.2,
            //   child: buildLogo(),
            // ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildLogo(),
                    buildUser(),
                    buildPassword(),
                    // buildForgetPassword(),
                    buildSignInEmail(),
                    buildCreateAccount(),

                    // buildSignInGoogle(),
                    // buildSignInFacebook(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 50,
          // height: screenHeight * 0.0001,
        ),
        Text(
          'Don\'t have account?',
          style: MyStyle().brownStyle(),
        ),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/createAccount'),
            child: const Text('Create New Account'))
      ],
    );
  }

  Row buildForgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 180,
          // height: 50,
          // height: screenHeight * 0.0001,
        ),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/forget_password'),
            child: const Text('Forget Password?'))
      ],
    );
  }

  Container buildSignInEmail() => Container(
          // margin: const EdgeInsets.only(top: 3),
          child: SignInButton(
        Buttons.Email,
        onPressed: () {
          if ((email.isEmpty) || (password.isEmpty)) {
            normalDialog(
                context, 'Warning Message', 'Please input email and password');
          } else {
            checkAuthentication();
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ));
  Future<void> checkAuthentication() async {
    /////connect firebase
    await Firebase.initializeApp(
            // options: firebaseOptions(),
            )
        .then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, '/food_list', (route) => false);
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));
      // print('Login Fail');
    });
  }

  Container buildSignInGoogle() => Container(
      margin: const EdgeInsets.only(top: 8),
      child: SignInButton(
        Buttons.GoogleDark,
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ));
  Container buildSignInFacebook() => Container(
      margin: const EdgeInsets.only(top: 8),
      child: SignInButton(
        Buttons.FacebookNew,
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ));
  Container buildUser() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.perm_identity,
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
      margin: const EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
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
    );
  }

  Container buildLogo() => Container(
        width: screenWidth * 0.6,
        child: MyStyle().showLogo(),
      );
}
