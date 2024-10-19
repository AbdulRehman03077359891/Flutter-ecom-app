import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Chat/choose_chat.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';
import 'package:my_ecom_app/Widgets/e1_button.dart';
import 'package:my_ecom_app/normUsers/nOrders/n_orders_main_page.dart';
import 'package:my_ecom_app/normUsers/personal_data.dart';

class UserDrawerWidget extends StatefulWidget {
  final String userUid, accountName, accountEmail;
  // profilePicture;

  const UserDrawerWidget({
    super.key,
    required this.userUid,
    required this.accountName,
    required this.accountEmail,
    // required this.profilePicture,
  });

  @override
  State<UserDrawerWidget> createState() => _UserDrawerWidgetState();
}

class _UserDrawerWidgetState extends State<UserDrawerWidget> {
  var fireController = Get.put(FireController());
  var animateController = Get.put(AnimateController());
  @override
  void initState() {
    super.initState();
    fetchData();
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
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/drawer.jpg",
                      ),
                      fit: BoxFit.cover)),
              arrowColor: const Color.fromARGB(255, 111, 2, 43),
              accountName: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1200),
                  builder: (BuildContext context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Padding(
                        padding: EdgeInsets.only(left: value * 10),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    // widget.accountName,
                    fireController.userData["name"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          BoxShadow(color: Colors.black87, blurRadius: 20)
                        ]),
                  )), //const Text("UserName",style: TextStyle(color: Colors.white),),
              accountEmail: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1200),
                builder: (BuildContext context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Padding(
                      padding: EdgeInsets.only(left: value * 10),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  // widget.accountEmail,
                  fireController.userData["email"],
                  style: const TextStyle(fontWeight: FontWeight.bold, shadows: [
                    BoxShadow(color: Colors.black87, blurRadius: 20)
                  ]),
                ),
              ), //const Text("user.name@email.com",style: TextStyle(color: Colors.white),),
              currentAccountPicture: GestureDetector(
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
                            color: Color.fromARGB(255, 111, 2, 43),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 111, 2, 43),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              // widget.profilePicture
                              fireController.userData["imageUrl"]),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            const Text(
              "     Profile",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.person_rounded,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),
                title: const Text(
                  "Personal Data",
                  style: TextStyle(
                      color: Color.fromARGB(255, 111, 2, 43),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
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
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.fastfood,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),
                title: const Text(
                  "Orders",
                  style: TextStyle(
                      color: Color.fromARGB(255, 111, 2, 43),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
                onTap: () {
                  Get.to(Orders(
                    userUid: widget.userUid,
                    userName: widget.accountName,
                    userEmail: widget.accountEmail,
                  ));
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.chat,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),

                title: const Text("Chat",
                    style: TextStyle(
                        color: Color.fromARGB(255, 111, 2, 43),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
                onTap: () {
                  Get.to(ChatsScreen(
                    userUid: widget.userUid,
                    userName: fireController.userData["name"],
                    userEmail: widget.accountEmail,
                    profilePicture: fireController.userData["imageUrl"], 
                    status: false,
                  ));
                },
                // onTap: () => Navigator.of(context).push(_NewPage(2)),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.add_card,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),

                title: const Text("Extra Card",
                    style: TextStyle(
                        color: Color.fromARGB(255, 111, 2, 43),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
                onTap: () {},
                // onTap: () => Navigator.of(context).push(_NewPage(2)),
              ),
            ),
            const Divider(),
            const Text(
              "     Support",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),
                title: const Text("Help Center",
                    style: TextStyle(
                        color: Color.fromARGB(255, 111, 2, 43),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
                onTap: () {},
              ),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.delete_forever,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),
                title: const Text(
                  "Request Account Deletion",
                  style: TextStyle(
                      color: Color.fromARGB(255, 111, 2, 43),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
                onTap: () {},
              ),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                leading: const Card(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 111, 2, 43),
                      ),
                    )),
                title: const Text(
                  "LogOut",
                  style: TextStyle(
                      color: Color.fromARGB(255, 111, 2, 43),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              "Are you sure?",
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  E1Button(
                                    backColor:
                                        const Color.fromARGB(255, 111, 2, 43),
                                    text: "Cancel",
                                    textColor: Colors.white,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  E1Button(
                                    backColor:
                                        const Color.fromARGB(255, 111, 2, 43),
                                    text: "Log Out",
                                    textColor: Colors.white,
                                    onPressed: () => fireController.logOut(),
                                  )
                                ],
                              ),
                            ],
                          ));
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
