import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_food_ordering/models/cart_model.dart';
import 'package:online_food_ordering/services/payment_service.dart';
import 'package:online_food_ordering/utility/CustomTextStyle.dart';
import 'package:online_food_ordering/utility/ProductTypeManagement.dart';
import 'package:online_food_ordering/utility/Utils.dart';
import 'package:online_food_ordering/utility/my_style.dart';
import 'package:uiblock/uiblock.dart';

class FoodCart extends StatefulWidget {
  const FoodCart({Key? key}) : super(key: key);
  @override
  State<FoodCart> createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  List<CartModel> cartModels = [];
  double screenHeight = 0, screenWidth = 0;
  double totalPrice = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
    readAllData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: createAppBar(context),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(children: [
          MyStyle().buildBackground(screenWidth, screenHeight),
          Builder(
            builder: (context) {
              return ListView(
                children: <Widget>[
                  createHeader(),
                  createSubTitle(),
                  createCartList(),
                  footer(context)
                ],
              );
            },
          ),
        ]),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(color: Colors.grey, fontSize: 17),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "\$$totalPrice",
                  style: CustomTextStyle.textFormFieldBlack.copyWith(
                      color: Colors.greenAccent.shade700, fontSize: 20),
                ),
              ),
            ],
          ),
          Utils.getSizedBox(height: 8),
          RaisedButton(
            onPressed: totalPrice != 0
                ? () {
                    if (totalPrice != 0) {
                      oneTimePayment();
                    } else {}
                  }
                : null,
            disabledElevation: 1,
            disabledTextColor: Colors.blueGrey,
            disabledColor: Colors.black12,
            color: Colors.green,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Checkout",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
          Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  Future<void> oneTimePayment() async {
    String dollar = totalPrice.toString().split('.')[0];
    String cent = totalPrice.toString().split('.')[1];
    if (cent.length < 2) {
      cent = cent + "0";
    }
    UIBlock.block(context);
    var response = await StripeService.payWithNewCard(
        amount: dollar + cent, currency: 'NZD');
    if (response.success == true) {
      paymentSuccess();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message.toString()),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    UIBlock.unblock(context);
  }

  AppBar createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // title: Text(productModel.name),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          // Navigator.pushNamed(context, '/food_list');
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.black87,
        ),
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 20, color: Colors.black),
      ),
      margin: const EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    var totle = 0;
    for (CartModel cart in cartModels) {
      totle += cart.quantity;
    }
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total(" + totle.toString() + ") Items",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 15, color: Colors.grey),
      ),
      margin: const EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createCartListItem(position);
      },
      itemCount: cartModels.length,
    );
  }

  Future<void> removeItem(int index) async {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove this item?'),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () async {
                  final carts = await FirebaseFirestore.instance
                      .collection('Cart')
                      .doc(cartModels[index].cartID)
                      .get();
                  await FirebaseFirestore.instance
                      .runTransaction((Transaction myTransaction) async {
                    myTransaction.delete(carts.reference);
                  });

                  setState(() {
                    cartModels.removeAt(index);
                    double newTotlePrice = 0;
                    for (CartModel cart in cartModels) {
                      newTotlePrice += cart.totalPrice;
                    }
                    totalPrice = newTotlePrice;
                  });
                  Navigator.of(context).pop();
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

  Future<void> increaseItem(int index) async {
    final carts = await FirebaseFirestore.instance
        .collection('Cart')
        .doc(cartModels[index].cartID)
        .get();

    CartModel cartModel = CartModel.fromMap(carts.data()!);
    cartModel.quantity = cartModel.quantity + 1;
    cartModel.totalPrice = cartModel.price * cartModel.quantity;
    Map<String, dynamic> data = cartModel.toMap();
    await carts.reference.update(data);
    setState(() {
      cartModels[index].quantity = cartModel.quantity;
      cartModels[index].totalPrice = cartModel.totalPrice;
      double newTotlePrice = 0;
      for (CartModel cart in cartModels) {
        newTotlePrice += cart.totalPrice;
        totalPrice = newTotlePrice;
      }
    });
  }

  Future<void> decreaseItem(int index) async {
    final carts = await FirebaseFirestore.instance
        .collection('Cart')
        .doc(cartModels[index].cartID)
        .get();
    CartModel cartModel = CartModel.fromMap(carts.data()!);
    cartModel.quantity = cartModel.quantity - 1;
    cartModel.totalPrice = cartModel.price * cartModel.quantity;
    Map<String, dynamic> data = cartModel.toMap();
    await carts.reference.update(data);
    setState(() {
      cartModels[index].quantity = cartModel.quantity;
      cartModels[index].totalPrice = cartModel.totalPrice;
      double newTotlePrice = 0;
      for (CartModel cart in cartModels) {
        newTotlePrice += cart.totalPrice;
        totalPrice = newTotlePrice;
      }
    });
  }

  Future<void> paymentSuccess() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final carts = await FirebaseFirestore.instance
        .collection('Cart')
        .where('UserID', isEqualTo: user!.uid)
        .where('PaymentStatus', isEqualTo: 0)
        .get();
    List<DocumentSnapshot> snapshots = carts.docs;
    for (var snapshot in snapshots) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

      CartModel cartModel = CartModel.fromMap(data);
      cartModel.paymentStatus = 100;
      cartModel.paymentDate = DateTime.now();
      await snapshot.reference.update(cartModel.toMap());
    }
    setState(() {
      totalPrice = 0;
      cartModels.clear();
    });
  }

  Future<void> readAllData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final carts = await FirebaseFirestore.instance
        .collection('Cart')
        .where('UserID', isEqualTo: user!.uid)
        .where('PaymentStatus', isEqualTo: 0)
        .get();
    List<DocumentSnapshot> snapshots = carts.docs;
    // print('!!!snapshots=>' + snapshots.length.toString());
    for (var snapshot in snapshots) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

      CartModel cartModel = CartModel.fromMap(data);
      cartModel.cartID = snapshot.id;
      totalPrice += cartModel.totalPrice;
      setState(() {
        cartModels.add(cartModel);
      });
    }
  }

  createCartListItem(int index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              showImage(index),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      showProductName(index),
                      Utils.getSizedBox(height: 6),
                      Text(
                        ProductTypeManagement()
                            .showTypeString(cartModels[index].productType),
                        style: CustomTextStyle.textFormFieldRegular
                            .copyWith(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "\$" + cartModels[index].price.toString(),
                              style: CustomTextStyle.textFormFieldBlack
                                  .copyWith(color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      decreaseItem(index);
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      size: 24,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      cartModels[index].quantity.toString(),
                                      style:
                                          CustomTextStyle.textFormFieldSemiBold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      increaseItem(index);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.grey.shade700,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              removeItem(index);
            },
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10, top: 8),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.redAccent),
            ),
          ),
        )
      ],
    );
  }

  Container showProductName(int index) {
    return Container(
      padding: EdgeInsets.only(right: 8, top: 4),
      child: Text(
        cartModels[index].name,
        maxLines: 2,
        softWrap: true,
        style: CustomTextStyle.textFormFieldSemiBold.copyWith(fontSize: 14),
      ),
    );
  }

  Container showImage(int index) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: Colors.blue.shade200,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(cartModels[index].imagePath))),
    );
  }
}
