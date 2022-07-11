import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_food_ordering/models/cart_model.dart';
import 'package:online_food_ordering/models/product_model.dart';

class ProductController extends GetxController {
  var isAddLoading = false.obs;

  Future<void> addToCart(ProductModel productModel) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final carts = await FirebaseFirestore.instance
        .collection('Cart')
        .where('UserID', isEqualTo: user!.uid)
        .where('ProductID', isEqualTo: productModel.documentID)
        .where('PaymentStatus', isEqualTo: 0)
        .get();
    if (carts.docs.isEmpty) {
      CartModel cartModel = CartModel(
          userID: user.uid,
          productID: productModel.documentID,
          name: productModel.name,
          imagePath: productModel.imagePath,
          price: productModel.price,
          quantity: 1,
          totalPrice: productModel.price,
          paymentStatus: 0,
          productType: productModel.type,
          paymentDate: DateTime.now());
      Map<String, dynamic> data = cartModel.toMap();
      await FirebaseFirestore.instance
          .collection('Cart')
          .add(data)
          .then((value) {
        // print("Insert Cart Success");
      });
    } else {
      CartModel cartModel = CartModel.fromMap(carts.docs[0].data());
      cartModel.quantity = cartModel.quantity + 1;
      cartModel.totalPrice = cartModel.price * cartModel.quantity;
      Map<String, dynamic> data = cartModel.toMap();
      await carts.docs[0].reference.update(data);
      // print("Update Cart Success");
    }
    isAddLoading.value = true;
    update();
    Timer(const Duration(seconds: 2), () {
      isAddLoading.value = false;
      update();
    });
  }
}
