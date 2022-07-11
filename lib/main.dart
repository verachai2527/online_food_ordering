import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_food_ordering/router.dart';
import 'package:online_food_ordering/utility/web_firebase_connection.dart';

String initRoute = '/authen';
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
          // options: firebaseOptions(),
          )
      .then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        //Check Login
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .snapshots()
            .listen((event) {
          // UserModel userModel = UserModel.fromMap(event.data());
          initRoute = '/food_list';
          runApp(MyApp());
        });
      } else {
        //Logout
        runApp(MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initRoute,
    );
  }
}
