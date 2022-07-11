import 'package:flutter/material.dart';
import 'package:online_food_ordering/states/authen.dart';
import 'package:online_food_ordering/states/create_account.dart';
import 'package:online_food_ordering/states/edit_profile.dart';
import 'package:online_food_ordering/states/food_cart.dart';
import 'package:online_food_ordering/states/food_favorite.dart';
import 'package:online_food_ordering/states/food_list.dart';
import 'package:online_food_ordering/states/location.dart';
import 'package:online_food_ordering/states/profile_detail.dart';

import 'package:online_food_ordering/states/forget_password.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/profileDetail': (BuildContext context) => ProfileDetail(),
  '/location': (BuildContext context) => Location(),
  '/editProfile': (BuildContext context) => EditProfile(),
  '/food_list': (BuildContext context) => FoodList(),
  '/food_cart': (BuildContext context) => FoodCart(),
  '/food_favorite': (BuildContext context) => FoodFavorite(),
  '/forget_password': (BuildContext context) => ForgetPassword(),
};
