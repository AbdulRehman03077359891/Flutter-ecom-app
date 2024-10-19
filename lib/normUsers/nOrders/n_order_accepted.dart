import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';

class NOrderAccepted extends StatefulWidget {
  final String userUid, userName, userEmail, status;
  const NOrderAccepted({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.status,
  });

  @override
  State<NOrderAccepted> createState() => _NOrderAcceptedState();
}

class _NOrderAcceptedState extends State<NOrderAccepted> {
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
        body: normUserController.acceptedOrders.isEmpty
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
            SingleChildScrollView(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: normUserController.acceptedOrders.length,
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
                              onTap: () {
                                animateController.showSecondPage("pic$index", 
                                            normUserController.acceptedOrders[index]
                                                ["imageUrl"], context);
                              },
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
                                                      .acceptedOrders[index]
                                                  ["imageUrl"]),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              normUserController.acceptedOrders[index]["name"],
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                    "Quantity: ${normUserController.acceptedOrders[index]['quantity'].toString()}"),
                                Text(
                                  "Per Item Rs ${(int.parse(normUserController.acceptedOrders[index]["price"]) / normUserController.acceptedOrders[index]["quantity"]).toStringAsFixed(2)}",
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
                                          "Rs ${normUserController.acceptedOrders[index]['price']}")),
                                  Positioned(
                                      bottom: 20,
                                      right: 0,
                                      child: Text(
                                          normUserController.acceptedOrders[index]
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
            ),
      );
    });
  }
}
