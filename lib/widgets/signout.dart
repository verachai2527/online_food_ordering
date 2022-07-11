import 'package:flutter/material.dart';

class SignOut extends StatelessWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
      ),
    );
  }
}
