import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_food_ordering/models/favorite_model.dart';
import 'package:online_food_ordering/models/product_model.dart';
import 'package:online_food_ordering/states/food_detail.dart';
import 'package:online_food_ordering/utility/MySearchDelegate.dart';
import 'package:online_food_ordering/utility/ProductTypeManagement.dart';
import 'package:online_food_ordering/utility/my_style.dart';
import 'package:online_food_ordering/widgets/myNavigationBar.dart';

class FoodFavorite extends StatefulWidget {
  const FoodFavorite({Key? key}) : super(key: key);

  @override
  State<FoodFavorite> createState() => _FoodFavoriteState();
}

class _FoodFavoriteState extends State<FoodFavorite> {
  double screenHeight = 0, screenWidth = 0;
  List<ProductModel> productModels = [];
  List<ProductModel> productDrinkModels = [];
  List<ProductModel> productSweetModels = [];
  List<ProductModel> productFoodModels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   checkFavoriteAllFlag(productModels);
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: createAppBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              MyStyle().buildBackground(screenWidth, screenHeight),
              TabBarView(
                children: [
                  ListView.builder(
                      itemCount: productDrinkModels.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        return showListView(index, 10);
                      }),
                  ListView.builder(
                      itemCount: productSweetModels.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        return showListView(index, 20);
                      }),
                  ListView.builder(
                      itemCount: productFoodModels.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        return showListView(index, 30);
                      }),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: myBottomNavigationBar(context, 1),
      ),
    );
  }

  AppBar createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(121, 248, 247, 247),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () {
              showSearch(
                      context: context,
                      delegate: MySearchDelegate(productModels))
                  .then((value) => checkFavoriteAllFlag(productModels));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black87,
              size: 34,
            )),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/food_cart');
          },
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.black,
            size: 35,
          ),
        ),
      ],
      bottom: createTabBar(),
      title: Text('Favorite List', style: MyStyle().darkStyle()),
    );
  }

  TabBar createTabBar() {
    return TabBar(
      labelColor: Color.fromARGB(255, 93, 92, 92),
      indicatorColor: MyStyle().primaryColor,
      tabs: [
        Tab(
          text: 'Drinks',
        ),
        Tab(
          text: 'Sweet',
        ),
        Tab(
          text: 'Food',
        ),
      ],
    );
  }

  InkWell showFavoriteButton(ProductModel _product) {
    return InkWell(
      onTap: () {
        updateFavorite(_product);
      },
      child: Container(
        width: 25,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor('dcdde2')),
        ),
        child: Icon(
          _product.favoriteFlag ? Icons.favorite_sharp : Icons.favorite_outline,
          size: 20,
          color: _product.favoriteFlag ? Colors.pink : Colors.grey,
        ),
      ),
    );
  }

  Future<void> updateFavorite(ProductModel _product) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    // print('favoriteFlag=>' + productModels[index].favoriteFlag.toString());
    if (_product.favoriteFlag) {
      final favorites = await FirebaseFirestore.instance
          .collection('Favorite')
          .where('UserID', isEqualTo: user!.uid)
          .where('ProductID', isEqualTo: _product.documentID)
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
        _product.favoriteFlag = false;
      });
    } else {
      FavoriteModel favorite =
          FavoriteModel(userID: user!.uid, productID: _product.documentID);
      Map<String, dynamic> data = favorite.toMap();
      await FirebaseFirestore.instance
          .collection('Favorite')
          .add(data)
          .then((value) {
        // print("Insert Favorite Success");
      });
      setState(() {
        _product.favoriteFlag = true;
      });
    }
    // await FirebaseFirestore.instance.terminate();
    // await FirebaseFirestore.instance.clearPersistence();
  }

  Widget showName(ProductModel _product) {
    return Text(
      _product.name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: MyStyle().darkColor,
      ),
    );
  }

  Widget showPrice(ProductModel _product) {
    return Text(
      '\$' + _product.price.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }

  Widget showType(ProductModel _product) {
    int type = _product.type;

    return Text(
      ProductTypeManagement().showTypeString(type),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: MyStyle().primaryColor,
      ),
    );
  }

  Widget showDetail(ProductModel _product) {
    String detail = _product.detail;
    if (detail.length > 50) {
      detail = detail.substring(0, 49);
      detail = '$detail...';
    } else {}
    return Text(
      detail,
      style: TextStyle(
        fontSize: 15, color: Color.fromARGB(255, 48, 48, 54),
        // fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget showImage(ProductModel _product) {
    return Container(
      height: 130,
      width: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_product.imagePath),
        ),
      ),
    );
  }

  Future<void> readAllData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final products = await FirebaseFirestore.instance
        .collection('Product')
        .orderBy('Type')
        .get();
    List<DocumentSnapshot> snapshots = products.docs;

    final favorites = await FirebaseFirestore.instance
        .collection('Favorite')
        .where('UserID', isEqualTo: user!.uid)
        .get();
    for (var favorite in favorites.docs) {
      Map<String, dynamic> dataFavorite = favorite.data();
      FavoriteModel favoriteModel = FavoriteModel.fromMap(dataFavorite);
      for (var snapshot in snapshots) {
        print('favoriteModel.productID=>' + favoriteModel.productID);

        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
        ProductModel productModel = ProductModel.fromMap(data);

        productModel.documentID = snapshot.id;
        productModel.favoriteFlag = true;
        print('productModel.documentID=>' + productModel.documentID);
        if (productModel.documentID == favoriteModel.productID) {
          // await checkFavoriteFlag(productModel);
          setState(() {
            productModels.add(productModel);
            switch (productModel.type) {
              case 10:
                productDrinkModels.add(productModel);
                break;
              case 20:
                productSweetModels.add(productModel);
                break;
              case 30:
                productFoodModels.add(productModel);
                break;
              default:
            }
          });
        }
      }
    }
  }

  Future<ProductModel> checkFavoriteFlag(ProductModel productModel) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final products = await FirebaseFirestore.instance
        .collection('Favorite')
        .where('UserID', isEqualTo: user!.uid)
        .where('ProductID', isEqualTo: productModel.documentID)
        .get();
    // .snapshots();
    // .listen((event) async {
    if (products.docs.isEmpty) {
      // print("Item doesn't exist in the db=>$products");
    } else {
      // print("Item exists in the db=>$products");
      productModel.favoriteFlag = true;
    }
    // });
    return productModel;
  }

  Future<Null> checkFavoriteAllFlag(List<ProductModel> productModels) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final favorites = await FirebaseFirestore.instance
        .collection('Favorite')
        .where('UserID', isEqualTo: user!.uid)
        .get();
    for (var productModel in productModels) {
      productModel.favoriteFlag = false;
    }
    setState(() {
      productModels;
    });
    if (favorites.docs.isNotEmpty) {
      // print('favorite not empty');
      for (var favorite in favorites.docs) {
        for (var productModel in productModels) {
          FavoriteModel favoriteModel = FavoriteModel.fromMap(favorite.data());
          print(favoriteModel.productID == productModel.documentID);
          if (favoriteModel.productID == productModel.documentID) {
            setState(() {
              productModel.favoriteFlag = true;
            });
            break;
          }
        }
      }
    } else {
      // print('favorite empty');
    }
  }

  Widget showListView(int index, int type) {
    ProductModel product;
    switch (type) {
      case 10:
        product = productDrinkModels[index];
        break;
      case 20:
        product = productSweetModels[index];
        break;
      case 30:
        product = productFoodModels[index];
        break;
      default:
        product = productModels[index];
    }
    return Card(
      elevation: 5,
      child: Container(
        height: 130,
        child: Row(
          children: [
            showImage(product),
            Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        showName(product),
                        const SizedBox(width: 20),
                        showFavoriteButton(product),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 3),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: showPrice(product),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: showType(product),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                      child: Container(
                        width: 260,
                        child: showDetail(product),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetail(productModel: product),
                  ),
                ).then((value) {
                  // setState(() {
                  checkFavoriteAllFlag(productModels);
                  // });
                });
              },
              child: Container(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(Icons.keyboard_arrow_right,
                    color: MyStyle().darkColor, size: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
