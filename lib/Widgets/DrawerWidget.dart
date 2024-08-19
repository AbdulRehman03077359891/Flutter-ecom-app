import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/FireBaseScreen/SignUp.dart';
import 'package:my_ecom_app/admin/businessUsers.dart';
import 'package:my_ecom_app/admin/category.dart';

class DrawerWidget extends StatefulWidget {
  final String accountName, accountEmail, profilePicture;

  DrawerWidget({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.profilePicture,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
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
            arrowColor: const Color(0xFFDAA520),
            accountName: Text(widget
                .accountName), //const Text("UserName",style: TextStyle(color: Colors.white),),
            accountEmail: Text(widget
                .accountEmail), //const Text("user.name@email.com",style: TextStyle(color: Colors.white),),
            currentAccountPicture: CircleAvatar(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    image: DecorationImage(
                        image: NetworkImage(widget.profilePicture),
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
            onTap: () {},
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
              Get.off(BusinessUsers(
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
            onTap: () {},
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
              Get.off(AddCategory(userName: widget.accountName,userEmail: widget.accountEmail,profilePicture: widget.profilePicture,));
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
              Icons.settings,
              color: Color.fromARGB(255, 111, 2, 43),
            ),
            title: const Text(
              "Settings",
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
