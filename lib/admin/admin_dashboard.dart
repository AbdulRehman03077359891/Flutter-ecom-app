
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/admin_dashboard_controller.dart';
import 'package:my_ecom_app/Widgets/admin_drawer_widget.dart';
import 'package:my_ecom_app/admin/all_dishes_data.dart';
import 'package:my_ecom_app/admin/all_business_users.dart';
import 'package:my_ecom_app/admin/add_category.dart';
import 'package:my_ecom_app/admin/normal_users.dart';

class AdminScreen extends StatefulWidget {
  final String userName, userEmail, profilePicture;
  const AdminScreen(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  var adminDashController = Get.put(AdminDashBoardController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDashBoardData();
    });
  }

  getDashBoardData() {
    adminDashController.getDashBoardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("AdminDashBoard"),
        backgroundColor: const Color.fromARGB(255, 111, 2, 43),
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () => Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  board(
                      context,
                      adminDashController.userNCount.value.toString(),
                      "NormUsers", () {
                    Get.to(NormUsers(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        profilePicture: widget.profilePicture));
                  }, Icons.people_alt_sharp, Colors.green),
                  board(
                      context,
                      adminDashController.catergoryCount.value.toString(),
                      "Categories", () {
                    Get.to(AddCategory(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        profilePicture: widget.profilePicture));
                  }, Icons.local_dining_sharp, Colors.amber),
                  board(context, 
                  adminDashController.pOrders.value.toString(), "Pending Orders", null, Icons.watch_later_outlined, Colors.redAccent),
                  board(
                      context,
                      adminDashController.sOrders.value.toString(),
                      "Shipped Orders", null, Icons.delivery_dining_rounded, Colors.blueGrey),
                      board(
                      context,
                      adminDashController.cOrders.value.toString(),
                      "Cancelled Orders", null, Icons.cancel_presentation_outlined, Colors.red)
                ],
              ),
              Column(
                children: [
                  board(
                      context,
                      adminDashController.userBCount.value.toString(),
                      "BusinessUsers", () {
                    Get.to(BusinessUsers(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        profilePicture: widget.profilePicture));
                  }, Icons.business_center, Colors.blue),
                  board(
                      context,
                      adminDashController.dishesCount.value.toString(),
                      "    Dishes", () {
                    Get.to(AdminDishData(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        profilePicture: widget.profilePicture));
                  }, Icons.dinner_dining, Colors.deepOrange),
                  board(
                      context,
                      adminDashController.aOrders.value.toString(),
                      "Accepted Orders", null, Icons.add_box_outlined, Colors.greenAccent),
                      board(
                      context,
                      adminDashController.dOrders.value.toString(),
                      "Accepted Orders", null, Icons.done_all_sharp, Colors.deepPurple)
                ],
              )
            ],
          ),
        ),
      ),
      endDrawer: AdminDrawerWidget(
          accountName: widget.userName,
          accountEmail: widget.userEmail,
          profilePicture: widget.profilePicture),
    );
  }

  Card board(
    BuildContext context,
    count,
    name,
    onpress,
    icon,
    iconColor,
  ) {
    return Card(
      color: const Color(0xFFFFF8E1),
      child: SizedBox(
        width: 160,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: onpress,
                    icon: Icon(
                      icon,
                      color: iconColor,
                    )),
                Wrap(direction: Axis.vertical,
                  children: [
                    SizedBox(width: 105,
                      child: Text(
                        name,
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 111, 2, 43),
                        ),
                      ),
                    ),
                    SizedBox(width: 80,
                      child: Center(
                        child: Text(count,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 111, 2, 43),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 0,
                                      offset: Offset(3, 1))
                                ])),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
