import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utility/my_style.dart';
import '../widgets/myNavigationBar.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  double screenHeight = 0, screenWidth = 0;
  String displayName = "";
  String email = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLong();
  }

  Future<Null> findLatLong() async {
    bool locationService;
    LocationPermission locationPermission;
    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('service location open');
    } else {
      print('service location close');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: createAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            MyStyle().buildBackground(screenWidth, screenHeight),
            Positioned(
              top: screenHeight * 0.02,
              left: screenWidth * 0.05,
              child: Text("Location",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyStyle().darkColor,
                      fontSize: 30)),
            ),
            Column(
              children: [
                addressDetail(),
                openingHours(),
                buildMap(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: myBottomNavigationBar(context, 3),
    );
  }

  Container buildMap() => Container(
        width: screenWidth * 0.9,
        height: 250,
        child: GoogleMap(
            initialCameraPosition: CameraPosition(
          target: LatLng(-46.401764941893546, 168.35716483300604),
          zoom: 16,
        )),
      );

  Padding addressDetail() {
    return Padding(
      padding: EdgeInsets.only(left: 0.07 * screenWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Text("Address:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Padding(
            padding: EdgeInsets.only(left: 0.09 * screenWidth),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('email: 216 Queens Drive, Queens Park, ',
                      style: TextStyle(
                          fontSize: 17,
                          height: 2,
                          backgroundColor: Colors.white)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Invercargill 9812',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 17,
                          height: 2,
                          backgroundColor: Colors.white)),
                ),
                Row(
                  children: [
                    Icon(Icons.facebook_sharp),
                    Text(': thecheekyllama',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 17,
                            height: 2,
                            backgroundColor: Colors.white)),
                  ],
                ),
                // ignore: prefer_const_constructors
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // title: Text(productModel.name),
      automaticallyImplyLeading: false,
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

  Padding openingHours() {
    return Padding(
      padding: EdgeInsets.only(left: 0.07 * screenWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Opening Hours:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Padding(
            padding: EdgeInsets.only(left: 0.09 * screenWidth),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sunday to Thursday: 8.30 am - 5.00 pm',
                      style: TextStyle(
                          fontSize: 17,
                          height: 2,
                          backgroundColor: Colors.white)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Friday to Saturday: 8.30 am - 8.00 pm',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 17,
                          height: 2,
                          backgroundColor: Colors.white)),
                ),
                // ignore: prefer_const_constructors
              ],
            ),
          ),
        ],
      ),
    );
  }
}
