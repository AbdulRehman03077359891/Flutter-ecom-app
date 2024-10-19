import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/business_dashboard.dart';
import 'package:my_ecom_app/Helper/globle.dart';
import 'package:my_ecom_app/Widgets/business_drawer_widget.dart';
import 'package:my_ecom_app/business/b_view_dish.dart';

class BusinessScreen extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;
  const BusinessScreen({super.key,
  required this.userUid,
  required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  var businessDashController = Get.put(BusinessDashBoardController());


   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDashBoardData();
      userUid = widget.userUid;
    });
  }

  getDashBoardData() {
    businessDashController.getDashBoardData(widget.userUid);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("BusinessDashBoard",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFFFFF8E1),
        foregroundColor: const Color.fromARGB(255, 111, 2, 43),
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
                      businessDashController.catergoryCount.value.toString(),
                      "Categories", () {
                   }, Icons.local_dining_sharp, Colors.amber),
                  board(context, 
                  businessDashController.pOrders.value.toString(), "Pending Orders", null, Icons.watch_later_outlined, Colors.redAccent),
                  board(
                      context,
                      businessDashController.sOrders.value.toString(),
                      "Shipped Orders", null, Icons.delivery_dining_rounded, Colors.blueGrey),
                      board(
                      context,
                      businessDashController.cOrders.value.toString(),
                      "Cancelled Orders", null, Icons.cancel_presentation_outlined, Colors.red)
                ],
              ),
              Column(
                children: [
                  
                  board(
                      context,
                      businessDashController.dishesCount.value.toString(),
                      "    Dishes", () {
                    Get.to(DishData(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        profilePicture: widget.profilePicture, userUid: widget.userUid,));
                  }, Icons.dinner_dining, Colors.deepOrange),
                  board(
                      context,
                      businessDashController.aOrders.value.toString(),
                      "Accepted Orders", null, Icons.add_box_outlined, Colors.greenAccent),
                      board(
                      context,
                      businessDashController.dOrders.value.toString(),
                      "Delivered Orders", null, Icons.done_all_sharp, Colors.deepPurple)
                ],
              )
            ],
          ),
        ),
      ),
      drawer: BusinessDrawerWidget(userUid: widget.userUid,accountName: widget.userName, accountEmail: widget.userEmail, profilePicture: widget.profilePicture),
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