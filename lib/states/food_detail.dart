import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_food_ordering/controller/product_controller.dart';
import 'package:online_food_ordering/models/favorite_model.dart';
import 'package:online_food_ordering/models/product_model.dart';
import 'package:online_food_ordering/utility/ProductTypeManagement.dart';
import 'package:online_food_ordering/utility/my_style.dart';
import 'package:online_food_ordering/widgets/myNavigationBar.dart';
import 'package:hexcolor/hexcolor.dart';

class FoodDetail extends StatefulWidget {
  final ProductModel productModel;
  FoodDetail({Key? key, required this.productModel}) : super(key: key);

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  final ProductController productController = Get.put(ProductController());

  double screenHeight = 0, screenWidth = 0;
  bool favoriteFlag = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFavoriteFlag();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: createAppBar(context),
      body: SafeArea(
        child: Stack(children: [
          MyStyle().buildBackground(screenWidth, screenHeight),
          Column(
            children: [
              showImage(),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 10, right: 14, left: 14),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 248, 248, 248),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            showType(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                showName(),
                                showPrice(),
                              ],
                            ),
                            const SizedBox(height: 15),
                            showDetail(),
                            const SizedBox(height: 15),
                            // Text(
                            //   'Similar This',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            // SizedBox(
                            //   height: 110,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: smProducts.length,
                            //     itemBuilder: (context, index) => Container(
                            //       margin: const EdgeInsets.only(right: 6),
                            //       width: 110,
                            //       height: 110,
                            //       decoration: BoxDecoration(
                            //         color: AppColors.kSmProductBgColor,
                            //         borderRadius: BorderRadius.circular(20),
                            //       ),
                            //       child: Center(
                            //         child: Image(
                            //           height: 70,
                            //           image: AssetImage(smProducts[index].image),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              'All takeaway items have to be picked up at the cafe.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: HexColor('dcdde2'),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showFavoriteButton(),
            SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () {
                  productController.addToCart(widget.productModel);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(
                    () => productController.isAddLoading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            '+ Add to Cart',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/food_cart');
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black87,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  InkWell showFavoriteButton() {
    return InkWell(
      onTap: () {
        updateFavorite();
      },
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor('dcdde2')),
        ),
        child: Icon(
          favoriteFlag ? Icons.favorite_sharp : Icons.favorite_outline,
          size: 30,
          color: favoriteFlag ? Colors.pink : Colors.grey,
        ),
      ),
    );
  }

  Future<void> updateFavorite() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (favoriteFlag) {
      final favorites = await FirebaseFirestore.instance
          .collection('Favorite')
          .where('UserID', isEqualTo: user!.uid)
          .where('ProductID', isEqualTo: widget.productModel.documentID)
          .get();
      // .snapshots()
      // .listen((event) async {
      for (var event in favorites.docs) {
        await FirebaseFirestore.instance
            .runTransaction((Transaction myTransaction) async {
          await myTransaction.delete(event.reference);
        });
      }
      // });

      setState(() {
        favoriteFlag = false;
      });
    } else {
      FavoriteModel favorite = FavoriteModel(
          userID: user!.uid, productID: widget.productModel.documentID);
      Map<String, dynamic> data = favorite.toMap();
      await FirebaseFirestore.instance
          .collection('Favorite')
          .add(data)
          .then((value) {
        // print("Insert Favorite Success");
      });
      setState(() {
        favoriteFlag = true;
      });
    }
    // await FirebaseFirestore.instance.terminate();
    // await FirebaseFirestore.instance.clearPersistence();
  }

  Future<Null> checkFavoriteFlag() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    await FirebaseFirestore.instance
        .collection('Favorite')
        .where('UserID', isEqualTo: user!.uid)
        .where('ProductID', isEqualTo: widget.productModel.documentID)
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) {
        // print("Item doesn't exist in the db=>$event");
      } else {
        // print("Item exists in the db=>$event");
        setState(() {
          favoriteFlag = true;
        });
      }
    });

    setState(() {
      favoriteFlag = false;
    });
  }

  Widget showImage() {
    return Container(
      height: screenHeight * .5,
      padding: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      child: Image.network(
        widget.productModel.imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null ? child : LinearProgressIndicator();
        },
      ),
    );
  }

  Widget showDetail() {
    String detail = widget.productModel.detail;
    // if (detail.length > 60) {
    //   detail = detail.substring(0, 59);
    //   detail = '$detail...';
    // } else {}
    return Text(
      detail,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }

  Widget showName() {
    return Text(
      widget.productModel.name,
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: MyStyle().darkColor,
      ),
    );
  }

  Widget showPrice() {
    return Text(
      '\$' + widget.productModel.price.toString(),
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget showType() {
    int type = widget.productModel.type;

    return Text(
      ProductTypeManagement().showTypeString(type),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
