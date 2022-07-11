import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

BottomNavigationBar myBottomNavigationBar(BuildContext context, int index) {
  return BottomNavigationBar(
    currentIndex: index,
    unselectedItemColor: Colors.green,
    selectedItemColor: Colors.green.shade900,
    onTap: (value) async {
      if (value != index) {
        switch (value) {
          case 0:
            Navigator.pushNamed(context, '/food_list');
            break;
          case 1:
            Navigator.pushNamed(context, '/food_favorite');
            break;
          case 2:
            Navigator.pushNamed(context, '/profileDetail');
            break;
          case 3:
            Navigator.pushNamed(context, '/location');
            break;
          case 4:
            createConfirmDialog(context);

            break;
          default:
        }
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorite',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.location_city),
        label: 'Location',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.exit_to_app,
        ),
        label: 'Sign Out',
      ),
    ],
  );
}

Future<void> createConfirmDialog(BuildContext context) async {
  showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Please Confirm'),
          content: const Text('Are you sure to Sign out?'),
          actions: [
            // The "Yes" button
            CupertinoDialogAction(
              onPressed: () async {
                await Firebase.initializeApp().then((value) async {
                  await FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/authen', (route) => false));
                });
              },
              child: const Text('Yes'),
              isDefaultAction: true,
              isDestructiveAction: true,
            ),
            // The "No" button
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
              isDefaultAction: false,
              isDestructiveAction: false,
            )
          ],
        );
      });
}
