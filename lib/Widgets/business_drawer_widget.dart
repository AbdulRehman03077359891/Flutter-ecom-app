import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Chat/choose_chat.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';
import 'package:my_ecom_app/business/add_dish.dart';
import 'package:my_ecom_app/business/bOrders/b_orders_main_page.dart';
import 'package:my_ecom_app/business/b_view_dish.dart';
import 'package:my_ecom_app/normUsers/personal_data.dart';

class BusinessDrawerWidget extends StatefulWidget {
  final String userUid, accountName, accountEmail, profilePicture;

  const BusinessDrawerWidget({
    super.key,
    required this.userUid,
    required this.accountName,
    required this.accountEmail,
    required this.profilePicture,
  });

  @override
  State<BusinessDrawerWidget> createState() => _BusinessDrawerWidgetState();
}

class _BusinessDrawerWidgetState extends State<BusinessDrawerWidget> {
  var fireController = Get.put(FireController());
  var animateController = Get.put(AnimateController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.userUid, "go");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FireController>(builder: (fireController) {
      return Drawer(
        backgroundColor: const Color(0xFFFFF8E1),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 50,
        child: ListView(
          children: [
            fireController.isLoading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .265,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    ))
                : UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(232, 111, 2, 44)),
                    arrowColor: const Color.fromARGB(255, 111, 2, 43),
                    accountName: Text(
                      // fireController.userData["name"],
                      fireController.userData["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          shadows: [
                            BoxShadow(color: Colors.black87, blurRadius: 20)
                          ]),
                    ), //const Text("UserName",style: TextStyle(color: Colors.white),),
                    accountEmail: Text(
                      // fireController.userData["email"],
                      fireController.userData["email"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          shadows: [
                            BoxShadow(color: Colors.black87, blurRadius: 20)
                          ]),
                    ), //const Text("user.name@email.com",style: TextStyle(color: Colors.white),),
                    currentAccountPicture: CircleAvatar(
                      child: GestureDetector(
                        onTap: () {
                          animateController.showSecondPage("Profile Picture",
                              fireController.userData["imageUrl"], context);
                        },
                        child: Hero(
                          tag: "Profile Picture",
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 255, 239, 183),
                                    blurRadius: 10,
                                    spreadRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 239, 183),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      // fireController.userData["imageUrl"]
                                      fireController.userData["imageUrl"]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ListTile(
              leading: const Icon(
                Icons.person_rounded,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              title: const Text(
                "Personal Data",
                style: TextStyle(color: Color.fromARGB(255, 111, 2, 43)),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              onTap: () {
                Get.to(PersonalData(
                  imageUrl: fireController.userData["imageUrl"],
                  userName: fireController.userData["name"],
                  userUid: widget.userUid,
                  gender: fireController.userData["gender"],
                  contact: fireController.userData["contact"],
                  dob: fireController.userData["dateOfBirth"],
                  address: fireController.userData["address"],
                  userEmail: fireController.userData["email"],
                ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.local_dining,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              title: const Text("View Dishes",
                  style: TextStyle(color: Color.fromARGB(255, 111, 2, 43))),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              onTap: () {
                Get.to(DishData(
                  userUid: widget.userUid,
                  userName: fireController.userData["name"],
                  userEmail: fireController.userData["email"],
                  profilePicture: fireController.userData["imageUrl"],
                ));
              },
              // onTap: () => Navigator.of(context).push(_NewPage(2)),
            ),
            ListTile(
              leading: const Icon(
                Icons.dining,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              title: const Text("Add Dishes",
                  style: TextStyle(color: Color.fromARGB(255, 111, 2, 43))),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              onTap: () {
                Get.to(AddDish(
                    userUid: widget.userUid,
                    userName: fireController.userData["name"],
                    userEmail: fireController.userData["email"],
                    profilePicture: fireController.userData["imageUrl"]));
              },
              // onTap: () => Navigator.of(context).push(_NewPage(2)),
            ),
            ListTile(
              leading: const Icon(
                Icons.work,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              title: const Text(
                "Orders",
                style: TextStyle(color: Color.fromARGB(255, 111, 2, 43)),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              onTap: () {
                Get.to(Orders(
                    userUid: widget.userUid,
                    userName: fireController.userData["name"],
                    userEmail: fireController.userData["email"]));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.chat,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              title: const Text(
                "Chats",
                style: TextStyle(color: Color.fromARGB(255, 111, 2, 43)),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              onTap: () {
                Get.to(ChatsScreen(
                    userUid: widget.userUid,
                    userName: fireController.userData["name"],
                    userEmail: fireController.userData["email"],
                    profilePicture: fireController.userData["imageUrl"], status: true,));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              title: const Text(
                "LogOut",
                style: TextStyle(
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 111, 2, 43),
              ),
              onTap: () {
                fireController.logOut();
              },
            ),
          ],
        ),
      );
    });
  }
}
