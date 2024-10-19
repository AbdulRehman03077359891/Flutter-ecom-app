import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';
import 'package:my_ecom_app/admin/all_dishes_data.dart';
import 'package:my_ecom_app/admin/admin_dashboard.dart';
import 'package:my_ecom_app/admin/all_business_users.dart';
import 'package:my_ecom_app/admin/add_category.dart';
import 'package:my_ecom_app/admin/normal_users.dart';

class AdminDrawerWidget extends StatefulWidget {
  final String accountName, accountEmail, profilePicture;

  const AdminDrawerWidget({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.profilePicture,
  });

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  var fireController = Get.put(FireController());
  var animateController = Get.put(AnimateController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      elevation: 50,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 111, 2, 43)),
            arrowColor: const Color.fromARGB(255, 111, 2, 43),
            accountName: Text(widget
                .accountName), //const Text("UserName",style: TextStyle(color: Colors.white),),
            accountEmail: Text(widget
                .accountEmail), //const Text("user.name@email.com",style: TextStyle(color: Colors.white),),
            currentAccountPicture: GestureDetector(
                      onTap: () {animateController.showSecondPage("Profile Picture", 
                      widget.profilePicture
                                          // fireController.userData
                                          //     ["imageUrl"]
                                          , context
                                          );
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
                                                  widget.profilePicture
                                                  // fireController.userData["imageUrl"]
                                                  ),
                                              fit: BoxFit.cover),
                                        ),
                        ),
                      ),
                    ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: Color.fromARGB(255, 111, 2, 43),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            onTap: () {
              Get.off(AdminScreen(
                  userName: widget.accountName,
                  userEmail: widget.accountEmail,
                  profilePicture: widget.profilePicture));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            title: const Text("BusinessUsers",
                style: TextStyle(color: Color.fromARGB(255, 111, 2, 43))),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            onTap: () {
              Get.to(BusinessUsers(
                userName: widget.accountName,
                userEmail: widget.accountEmail,
                profilePicture: widget.profilePicture,
              ));
            },
            // onTap: () => Navigator.of(context).push(_NewPage(2)),
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            title: const Text("NormalUsers",
                style: TextStyle(color: Color.fromARGB(255, 111, 2, 43))),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            onTap: () {
              Get.to(NormUsers(
                  userName: widget.accountName,
                  userEmail: widget.accountEmail,
                  profilePicture: widget.profilePicture));
            },
            // onTap: () => Navigator.of(context).push(_NewPage(2)),
          ),
          ListTile(
            leading: const Icon(
              Icons.contact_page,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            title: const Text("Add Category",
                style: TextStyle(color: Color.fromARGB(255, 111, 2, 43))),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            onTap: () {
              Get.to(AddCategory(
                userName: widget.accountName,
                userEmail: widget.accountEmail,
                profilePicture: widget.profilePicture,
              ));
            },
          ),ListTile(
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
              Get.to(AdminDishData(userName: widget.accountName, userEmail: widget.accountEmail, profilePicture: widget.profilePicture));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.app_blocking,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            title: const Text(
              "About",
              style: TextStyle(color: Color.fromARGB(255, 111, 2, 43)),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            onTap: () {},
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
  }
}
