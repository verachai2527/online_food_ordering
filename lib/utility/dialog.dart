import 'package:flutter/material.dart';
import 'package:online_food_ordering/utility/my_style.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: ListTile(
              leading: MyStyle().showLogo(),
              title: Text(
                title,
                style: MyStyle().darkStyle(),
              ),
              subtitle: Text(
                message,
                style: MyStyle().primaryStyle(),
              ),
            ),
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          ));
}
