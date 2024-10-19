import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/business_controller.dart';

class BOrderCancelled extends StatefulWidget {
  final String userUid, userName, userEmail, status;
  const BOrderCancelled({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.status,
  });

  @override
  State<BOrderCancelled> createState() => _BOrderCancelledState();
}

class _BOrderCancelledState extends State<BOrderCancelled> {
  var businessController = Get.put(BusinessController());
  var animateController = Get.put(AnimateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getOrders();
    });
  }

  getOrders() async {
    await businessController.getOrder(
      widget.userUid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF8E1),
        body: businessController.cancelledOrders.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                child: const Center(
                  child: Text(
                    "No Orders Found",
                    style: TextStyle(
                      color: Color.fromARGB(255, 111, 2, 43),
                    ),
                  ),
                ),
              )
            :
            // businessController.isLoading? SizedBox(height: MediaQuery.of(context).size.height*.8,child: const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),),),):
            SingleChildScrollView(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: businessController.cancelledOrders.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 255, 225, 225),
                        shape: const BeveledRectangleBorder(
                            side: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () {animateController.showSecondPage("pic$index", 
                                            businessController.pendingOrders[index]
                                                ["imageUrl"], context);},
                            child: Card(
                              elevation: 10,
                              child: Hero(
                                tag: "pic$index",
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            businessController
                                                    .cancelledOrders[index]
                                                ["imageUrl"]),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            businessController.cancelledOrders[index]["name"],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                  "Quantity: ${businessController.cancelledOrders[index]['quantity'].toString()}"),
                              Text(
                                "Per Item Rs ${(int.parse(businessController.cancelledOrders[index]["price"]) / businessController.cancelledOrders[index]["quantity"]).toStringAsFixed(2)}",
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            height: 60,
                            width: 60,
                            child: Stack(
                              children: [
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Text(
                                        "Rs ${businessController.cancelledOrders[index]['price']}")),
                                Positioned(
                                    bottom: 20,
                                    right: 0,
                                    child: Text(businessController
                                        .cancelledOrders[index]["status"],style: const TextStyle(fontWeight: FontWeight.bold),)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      );
    });
  }
}
