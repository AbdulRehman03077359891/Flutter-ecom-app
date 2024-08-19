import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/FireController.dart';
import 'package:my_ecom_app/Widgets/DrawerWidget.dart';

class BusinessUsers extends StatefulWidget {
  final userName, userEmail, profilePicture;
  const BusinessUsers(
      {super.key, this.userName, this.userEmail, this.profilePicture});

  @override
  State<BusinessUsers> createState() => _BusinessUsersState();
}

class _BusinessUsersState extends State<BusinessUsers> {
  var controller = Get.put(FireController());
  void initState() {
    super.initState();
    getAllUsers();
  }

  getAllUsers() {
    controller.getAllBusiUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BusinessUsers"),
        backgroundColor: const Color.fromARGB(255, 111, 2, 43),
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<FireController>(builder: (controller) {
        return Center(
          child: controller.isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: controller.usersList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color.fromARGB(255, 111, 2, 43),
                      shadowColor: const Color.fromARGB(255, 111, 2, 43),
                      elevation: 30,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              controller.usersList[index]["imageUrl"]),
                        ),
                        title: Text(
                          controller.usersList[index]["name"],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          controller.usersList[index]["email"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
        );
      }),
      endDrawer: DrawerWidget(
          accountName: widget.userName,
          accountEmail: widget.userEmail,
          profilePicture: widget.profilePicture),
    );
  }
}
