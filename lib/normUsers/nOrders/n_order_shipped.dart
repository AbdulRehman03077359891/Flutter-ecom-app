import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';

class NOrderShipped extends StatefulWidget {
  final String userUid, userName, userEmail, status;
  const NOrderShipped({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.status,
  });

  @override
  State<NOrderShipped> createState() => _NOrderShippedState();
}

class _NOrderShippedState extends State<NOrderShipped> {
  var normUserController = Get.put(NormUserController());
  var animateController = Get.put(AnimateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getOrders();
    });
  }

  getOrders() async {
    await normUserController.getOrder(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NormUserController>(builder: (normUserController) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF8E1),
        body: normUserController.shippedOrders.isEmpty
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
            // normUserController.isLoading? SizedBox(height: MediaQuery.of(context).size.height*.8,child: const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),),),):
            ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: normUserController.shippedOrders.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Stack(
                      children: [
                        ListTile(
                          leading: GestureDetector(
                            onTap: () {animateController.showSecondPage("pic$index", 
                                            normUserController.shippedOrders[index]
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
                                            normUserController
                                                    .shippedOrders[index]
                                                ["imageUrl"]),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            normUserController.shippedOrders[index]["name"],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                  "Quantity: ${normUserController.shippedOrders[index]['quantity'].toString()}"),
                              Text(
                                "Per Item Rs ${(int.parse(normUserController.shippedOrders[index]["price"]) / normUserController.shippedOrders[index]["quantity"]).toStringAsFixed(2)}",
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
                                        "Rs ${normUserController.shippedOrders[index]['price']}")),
                                Positioned(
                                    bottom: 20,
                                    right: 0,
                                    child: Text(
                                        normUserController.shippedOrders[index]
                                            ["status"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  );
                }),
      );
    });
  }
}
