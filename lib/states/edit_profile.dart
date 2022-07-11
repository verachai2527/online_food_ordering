import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_food_ordering/models/user_model.dart';
import 'package:online_food_ordering/utility/CustomTextStyle.dart';
import 'package:online_food_ordering/utility/dialog.dart';
import 'package:online_food_ordering/utility/my_style.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DateTime selectedDate = DateTime.now();
  double screenHeight = 0, screenWidth = 0;
  String displayName = "";
  String email = "";
  String phone = "";
  DateTime dob = DateTime.now();
  String urlPicture = "";
  File? file;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDetail();
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
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Positioned(
                  //   top: screenHeight * 0.02,
                  //   left: screenWidth * 0.05,
                  //   child: Text("Profile Detail",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: MyStyle().darkColor,
                  //           fontSize: 30)),
                  // ),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          profilePic(),
                          buildEditProfilePicture(),
                          buildDisplayNameInputField(),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      buildDOBInputField(),
                      bildPhoneInputField(),
                      editButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDisplayNameInputField() {
    return Container(
      width: screenWidth * 0.6,
      margin: EdgeInsets.only(top: 16),
      child: TextField(
        controller: displayNameController,
        onChanged: (value) => displayName = value.trim(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Display Name',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container bildPhoneInputField() {
    return Container(
      width: screenWidth * 0.6,
      margin: EdgeInsets.only(top: 16),
      child: TextField(
        controller: phoneController,
        onChanged: (value) => phone = value.trim(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.perm_phone_msg_outlined,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Phone',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container buildDOBInputField() {
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.only(left: 60),
        child: Row(
          children: [
            Container(
              width: 250,
              child: TextField(
                controller: TextEditingController(
                    text: dob.toLocal().toString().split(' ')[0]),
                onChanged: (value) => dob = DateTime.parse(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.perm_contact_calendar_outlined,
                    color: MyStyle().darkColor,
                  ),
                  labelStyle: MyStyle().darkStyle(),
                  labelText: 'Date of Birth',
                  hintText: 'YYYY-MM-DD',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: MyStyle().darkColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: MyStyle().lightColor)),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.edit_calendar_outlined),
              color: MyStyle().darkColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dob,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        // dob = selectedDate.toLocal().toString().split(' ')[0];
        dob = selectedDate;
      });
  }

  Container buildEmailInputField() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: emailController,
          onChanged: (value) => email = value.trim(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.mail,
              color: MyStyle().darkColor,
            ),
            labelStyle: MyStyle().darkStyle(),
            labelText: 'Email',
            hintText: 'example@example.com',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyStyle().lightColor)),
          ),
        ),
      ),
    );
  }

  Row buildEditProfilePicture() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(Icons.add_a_photo),
          color: MyStyle().darkColor,
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
          color: MyStyle().darkColor,
        ),
      ],
    );
  }

  Future<void> showDetail() async {
    WidgetsFlutterBinding.ensureInitialized();
/////connect firebase
    await Firebase.initializeApp(
            // options: firebaseOptions(),
            )
        .then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event != null) {
          //Login
          print('Login');
          String uid = event.uid;
          await FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .snapshots()
              .listen((event) {
            UserModel userModel = UserModel.fromMap(event.data());
            displayNameController.text = userModel.name;
            emailController.text = userModel.email;
            dobController.text =
                userModel.dateOfBirth.toLocal().toString().split(' ')[0];
            phoneController.text = userModel.phone;
            setState(() {
              displayName = userModel.name;
              email = userModel.email;
              dob = userModel.dateOfBirth;
              phone = userModel.phone;
              urlPicture = userModel.imagePath;
            });
          });
        } else {
          //Logout
        }
      });
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 250, maxHeight: 250);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Container profilePic() => Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        width: screenWidth * 0.6,
        child: file == null
            ? MyStyle().profilePic(urlPicture)
            : CircleAvatar(
                maxRadius: 120,
                backgroundImage: Image.file(file!).image,
              ),
      );
  Widget editButton() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 14),
          child: RaisedButton(
            onPressed: () {
              if ((displayName.isEmpty) || (email.isEmpty) || (phone.isEmpty)
                  // ||(dob.isEmpty)
                  ) {
                normalDialog(
                    context, 'Warning Message', 'Please input all fields');
              } else {
                uploadProfilePic();
              }
            },
            color: Colors.green,
            padding:
                const EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Save",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Future<void> uploadProfilePic() async {
    if (file != null) {
      Random random = Random();
      int random_number = random.nextInt(100000);
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference storageReference =
          firebaseStorage.ref().child('ProfilePic/$random_number.jpg');
      UploadTask uploadTask = storageReference.putFile(file!);
      var imageURL = await (await uploadTask).ref.getDownloadURL();
      urlPicture = imageURL.toString();
      // print('this.urlPicture' + this.urlPicture);
    }
    updateProfile();
  }

  AppBar createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // title: Text(productModel.name),
      leading: IconButton(
        onPressed: () {
          // Navigator.pop(context);
          Navigator.pushNamed(context, '/profileDetail');
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.black87,
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final users = await FirebaseFirestore.instance
        .collection('User')
        .doc(user!.uid)
        .get();

    UserModel userModel = UserModel.fromMap(users.data());
    userModel.name = displayName;
    userModel.phone = phone;
    userModel.imagePath = this.urlPicture;
    userModel.dateOfBirth = dob;
    Map<String, dynamic> data = userModel.toMap();
    await users.reference.update(data).then((value) =>
        Navigator.pushNamedAndRemoveUntil(
            context, '/profileDetail', (route) => false));
  }
}
