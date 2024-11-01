// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/FireBaseScreen/sign_in.dart';
import 'package:my_ecom_app/admin/admin_dashboard.dart';
import 'package:my_ecom_app/business/business_dashboard.dart';
import 'package:my_ecom_app/normUsers/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), (() {
      checkUser();
      //  Get.to(SignInPage());
    }));
  }

  checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userCheck = prefs.getBool("Login") ?? false;
    if (userCheck) {
      var userType = prefs.getString("userType");
      // Get.offAll(HumanLibrary());
      if (userType == "NormUsers") {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HumanLibrary(userType: userType!,userName: prefs.getString("name"),userEmail: prefs.getString("email"),profilePicture: prefs.getString("imageUrl"),)));
        Get.offAll(() => UserScreen(
          userUid: prefs.getString("uid").toString(),
              userName: prefs.getString("name").toString(),
              userEmail: prefs.getString("email").toString(),
              profilePicture: prefs.getString("imageUrl").toString(),
            ));
      } else if (userType == "BusinessUsers") {
        Get.offAll(() => BusinessScreen(
          userUid: prefs.getString("uid").toString(),
              userName: prefs.getString("name").toString(),
              userEmail: prefs.getString("email").toString(),
              profilePicture: prefs.getString("imageUrl").toString(),
            ));
      } else if (userType == "admin") {
        Get.offAll(() => AdminScreen(
              userName: prefs.getString("name").toString(),
              userEmail: prefs.getString("email").toString(),
              profilePicture: prefs.getString("imageUrl").toString(),
            ));
      }
    } else {
      Get.offAll(SignInPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.network(
              "https://img.freepik.com/free-vector/bird-colorful-logo-gradient-vector_343694-1365.jpg?t=st=1722092962~exp=1722096562~hmac=6dba715e83ca9513cc06ac9b36c21744be36b4697513fc9a230038c0a5cda43c&w=360"),
        ),
      ),
    );
  }
}
