// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../utility/my_style.dart';
import '../widgets/myNavigationBar.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  double screenHeight = 0, screenWidth = 0;
  String displayName = "";
  String email = "";
  String dob = "";
  String phone = "";
  File? file;
  String urlPicture = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDetail();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to the Cheely Llama"),
      ),
      // drawer: Drawer(
      //   child: SignOut(),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            MyStyle().buildBackground(screenWidth, screenHeight),
            Positioned(
              top: screenHeight * 0.02,
              left: screenWidth * 0.05,
              child: Text("Profile Detail",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyStyle().darkColor,
                      fontSize: 30)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        profilePic(),
                        // buildProfilePicture(),
                        Text(displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyStyle().primaryColor,
                              fontSize: 25,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.25 * screenWidth),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('email: $email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                height: 2,
                                backgroundColor: Colors.white)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('DOB: $dob',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                height: 2,
                                backgroundColor: Colors.white)),
                      ),
                      // ignore: prefer_const_constructors
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Phone: $phone',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                height: 2,
                                backgroundColor: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/editProfile', (route) => false);
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: myBottomNavigationBar(context, 2),
    );
  }

  Row buildProfilePicture() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // IconButton(
        //   onPressed: () => chooseImage(ImageSource.camera),
        //   icon: Icon(Icons.add_a_photo),
        //   color: MyStyle().darkColor,
        // ),

        // IconButton(
        //   onPressed: () => chooseImage(ImageSource.gallery),
        //   icon: Icon(Icons.add_photo_alternate),
        //   color: MyStyle().darkColor,
        // ),
      ],
    );
  }

  Future showDetail() async {
    WidgetsFlutterBinding.ensureInitialized();
/////connect firebase
    await Firebase.initializeApp(
            // options: firebaseOptions(),
            )
        .then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event != null) {
          //Login
          print('Login');
          String uid = event.uid;
          await FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .snapshots()
              .listen((event) {
            UserModel userModel = UserModel.fromMap(event.data());
            setState(() {
              displayName = userModel.name;
              email = userModel.email;
              urlPicture = userModel.imagePath;
              dob = userModel.dateOfBirth.toLocal().toString().split(' ')[0];
              phone = userModel.phone;
            });
          });
        } else {
          //Logout
        }
      });
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 250, maxHeight: 250);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Container profilePic() => Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        width: screenWidth * 0.6,
        child:
            file == null ? MyStyle().profilePic(urlPicture) : Image.file(file!),
      );
}
