
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/FireBaseScreen/sign_up.dart';

class ChooseType extends StatelessWidget {
  const ChooseType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height,child: Image.asset("assets/images/choose.jpg",fit: BoxFit.cover,)),
              Positioned(left: 0,bottom: MediaQuery.of(context).size.height*.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40))),
                          backgroundColor: const Color.fromARGB(                                                    255, 111, 2, 43),
                          shadowColor: Colors.black,
                          elevation: 10),
                      onPressed: () {Get.to(const SignUpPage(userType: 'BusinessUsers'));},
                      child: const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            Text(
                              "Business",
                              style: TextStyle(color: Colors.white, fontSize: 40,shadows: [BoxShadow(color: Colors.black54,blurRadius: 20)]),
                            ),Text(
                              "Account",
                              style: TextStyle(color: Colors.white, fontSize: 40,shadows: [BoxShadow(color: Colors.black54,blurRadius: 20)]),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              Positioned(right: 0,top: MediaQuery.of(context).size.height*.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40))),
                          backgroundColor: const Color.fromARGB(                                                    255, 111, 2, 43),
                          shadowColor: Colors.black,
                          elevation: 10),
                      onPressed: () {Get.to(const SignUpPage(userType: 'NormUsers',));},
                      child: const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            Text(
                              "User",
                              style: TextStyle(color: Colors.white, fontSize: 40,shadows: [BoxShadow(color: Colors.black54,blurRadius: 20)]),
                            ),Text(
                              "Account",
                              style: TextStyle(color: Colors.white, fontSize: 40,shadows: [BoxShadow(color: Colors.black54,blurRadius: 20)]),
                            ),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
