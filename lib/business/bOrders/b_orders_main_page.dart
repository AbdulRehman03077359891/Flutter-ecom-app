import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/business_controller.dart';
import 'package:my_ecom_app/business/bOrders/b_order_accepted.dart';
import 'package:my_ecom_app/business/bOrders/b_order_cancelled.dart';
import 'package:my_ecom_app/business/bOrders/b_order_dilivered.dart';
import 'package:my_ecom_app/business/bOrders/b_order_pending.dart';
import 'package:my_ecom_app/business/bOrders/b_order_shipped.dart';

class Orders extends StatefulWidget {
  final String userUid, userName, userEmail;
  const Orders({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var businessController = Get.put(BusinessController());
  // @override
  // void initState() {
  //   super.initState();
  //   getOrders();
  // }
  // getOrders() async {
  //   await businessController.getOrder(widget.userUid,);
  // }
  @override
  Widget build(BuildContext context) {
    final kTabPages =  <Widget>[
      
      BOrderPending(
        userUid: widget.userUid,
        userName: widget.userName,
        userEmail: widget.userEmail,
        status: "pending",
      ),
      BOrderAccepted(
        userUid: widget.userUid,
        userName: widget.userName,
        userEmail: widget.userEmail,
        status: "accepted",
      ),
      BOrderShipped(
        userUid: widget.userUid,
        userName: widget.userName,
        userEmail: widget.userEmail,
        status: "shipped",
      ),
      BOrderDilivered(
        userUid: widget.userUid,
        userName: widget.userName,
        userEmail: widget.userEmail,
        status: "dilivered",
      ),
      BOrderCancelled(
        userUid: widget.userUid,
        userName: widget.userName,
        userEmail: widget.userEmail,
        status: "cancelled",
      ),
    ];
    final kTabs = [
      const Tab(icon: Icon(Icons.restaurant_outlined), text: 'Pending'),
      const Tab(icon: Icon(Icons.dinner_dining_outlined), text: 'Cooking'),
      const Tab(icon: Icon(Icons.delivery_dining_outlined), text: 'Delivering'),
      const Tab(icon: Icon(Icons.check), text: 'Delivered'),
      const Tab(icon: Icon(Icons.cancel_presentation), text: 'Canceled'),
    ];
    return DefaultTabController(
      length: kTabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8E1),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
              businessController.setLoading(false);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          centerTitle: true,
          title: const Text(
            "Your Order",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFFFF8E1),
          foregroundColor: const Color.fromARGB(255, 111, 2, 43),
          bottom: TabBar(
              isScrollable: true,
              indicatorPadding: const EdgeInsets.all(8),
              indicator: const BoxDecoration(
                color: Color.fromARGB(255, 111, 2, 43),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: const Color(0xFFFFF8E1),
              tabs: kTabs),
        ),
        body: TabBarView(children: kTabPages),
      ),
    );
  }
}
