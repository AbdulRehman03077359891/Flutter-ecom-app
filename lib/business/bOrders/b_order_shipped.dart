import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/business_controller.dart';
import 'package:my_ecom_app/Widgets/e1_button.dart';
import 'package:my_ecom_app/Widgets/text_field_widget.dart';

class BOrderShipped extends StatefulWidget {
  final String userUid, userName, userEmail, status;
  const BOrderShipped({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.status,
  });

  @override
  State<BOrderShipped> createState() => _BOrderShippedState();
}

class _BOrderShippedState extends State<BOrderShipped> {
  var businessController = Get.put(BusinessController());
  TextEditingController reason = TextEditingController();
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

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
        body: businessController.shippedOrders.isEmpty
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
                    itemCount: businessController.shippedOrders.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.width * .75,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => Center(
                                                child: Stack(
                                                  children: [
                                                    Hero(
                                                        tag: "Profile Picture",
                                                        child: Image(
                                                          image: CachedNetworkImageProvider(
                                                              businessController
                                                                          .shippedOrders[
                                                                      index]
                                                                  ["imageUrl"]),
                                                        )),
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: Card(
                                      elevation: 10,
                                      child: Hero(
                                        tag: "pic",
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .38,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .38,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        businessController
                                                                .shippedOrders[
                                                            index]["imageUrl"]),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 5,
                                    left:
                                        MediaQuery.of(context).size.width * .4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .4,
                                          child: Text(
                                            "Dish Name: ${businessController.shippedOrders[index]["name"]}",
                                            softWrap: true,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                            "Quantity: ${businessController.shippedOrders[index]['quantity'].toString()}"),
                                        Text(
                                          "Per Item Rs ${(int.parse(businessController.shippedOrders[index]["price"]) ~/ businessController.shippedOrders[index]["quantity"]).toStringAsFixed(2)}",
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          "Total Rs ${businessController.shippedOrders[index]['price']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Wrap(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  businessController.openMap(
                                                      businessController
                                                          .shippedOrders[index]
                                                              ["nLatitude"]
                                                          .toString(),
                                                      businessController
                                                          .shippedOrders[index]
                                                              ["nLongitude"]
                                                          .toString());
                                                },
                                                tooltip: businessController
                                                        .shippedOrders[index]
                                                    ["nAddress"],
                                                icon: const Icon(
                                                  Icons.fmd_good_outlined,
                                                )),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              child: Text(
                                                businessController
                                                        .shippedOrders[index]
                                                    ["nAddress"],
                                                softWrap: true,
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                                Positioned(
                                    bottom: 0,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .91,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          E1Button(
                                            backColor: const Color.fromARGB(
                                                255, 111, 2, 43),
                                            text: "Cancel",
                                            textColor: const Color(0xFFFFF8E1),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => GetBuilder<
                                                        BusinessController>(
                                                    builder:
                                                        (businessController) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Are you sure?",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: Form(
                                                      key: _goodToGo,
                                                      child: TextFieldWidget(
                                                        validate: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please provide a reason';
                                                          }
                                                          return null;
                                                        },
                                                        controller: reason,
                                                        hintText:
                                                            "Provide your reason",
                                                        fillColor: const Color
                                                            .fromARGB(
                                                            31, 255, 255, 255),
                                                        focusBorderColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                111, 2, 43),
                                                        errorBorderColor:
                                                            Colors.red,
                                                      ),
                                                    ),
                                                    actions: [
                                                      E1Button(
                                                        backColor: const Color
                                                            .fromARGB(
                                                            255, 111, 2, 43),
                                                        text: "Cancel",
                                                        textColor: const Color(
                                                            0xFFFFF8E1),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      E1Button(
                                                          backColor: const Color
                                                              .fromARGB(
                                                              255, 111, 2, 43),
                                                          text: "Update",
                                                          textColor:
                                                              const Color(
                                                                  0xFFFFF8E1),
                                                          onPressed: () {
                                                            if (_goodToGo
                                                                .currentState!
                                                                .validate()) {
                                                              businessController.updateOrder(
                                                                  businessController
                                                                              .pendingOrders[
                                                                          index]
                                                                      [
                                                                      "orderKey"],
                                                                  "cancelled",
                                                                  reason.text);
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          })
                                                    ],
                                                  );
                                                }),
                                              );
                                            },
                                          ),
                                          E1Button(
                                            backColor: const Color.fromARGB(
                                                255, 111, 2, 43),
                                            text: "Delivered",
                                            textColor: const Color(0xFFFFF8E1),
                                            onPressed: () {
                                              businessController.updateOrder(
                                                  businessController
                                                          .shippedOrders[index]
                                                      ["orderKey"],
                                                  "delivered",
                                                  "");
                                            },
                                          )
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    top: MediaQuery.of(context).size.width * .4,
                                    left: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.person),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              businessController
                                                      .shippedOrders[index]
                                                  ["nUserName"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.contact_phone),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              businessController
                                                      .shippedOrders[index]
                                                  ["nContact"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.contact_mail),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              businessController
                                                      .shippedOrders[index]
                                                  ["nUserEmail"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ));
                    }),
              ),
      );
    });
  }
}
