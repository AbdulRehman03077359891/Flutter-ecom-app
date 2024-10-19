import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/chat_controller.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';
import 'package:my_ecom_app/Widgets/e1_button.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/Widgets/text_field_widget.dart';
import 'package:my_ecom_app/normUsers/user_screen.dart';

class CartScreen extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const CartScreen(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var normUserController = Get.put(NormUserController());
  var chatController = Get.put(ChatController());
  TextEditingController contact = TextEditingController();
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();
  late String totalPrice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCartItems();
    });
  }

  getAllCartItems() {
    normUserController.getCartItems(widget.userUid);
  }

// Finding Address -------------------------------------------------------
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't proceed.
      errorMessage("error", "Location services are disabled.");
      return null;
    }

    // Check for permission.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a message.
        errorMessage("error", "Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, show a message.
      errorMessage("error", "Location permissions are permanently denied.");
      return null;
    }

    // If everything is fine, return the position.
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // Optional timeout
      );
    } catch (e) {
      // Catch any errors and show a message.
      errorMessage("error", "Failed to get location: $e");
      return null;
    }
  }

  _getAddressFromCoordination() async {
    try {
      if (_currentLocation != null) {
        List<Placemark> placeMark = await placemarkFromCoordinates(
            _currentLocation!.latitude, _currentLocation!.longitude);

        if (placeMark.isNotEmpty) {
          Placemark place1 = placeMark[0];
          Placemark place3 = placeMark[2];
          Placemark place4 = placeMark[3];

          setState(() {
            _currentAddress =
                "${place3.name}, ${place4.name}, ${place1.subLocality}, ${place1.locality}, ${place1.administrativeArea}, ${place1.country}";
          });
        } else {
          errorMessage("error", "No placemark found");
        }
      } else {
        errorMessage("error", "Current location is null");
      }
    } catch (e) {
      errorMessage("error", "Failed to get placemark: $e");
    }
  }

  // Future<void> _openMap(String lat, String long) async {
  //   String googleUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  //   try {
  //     await launchUrlString(googleUrl);
  //   } catch (e) {
  //     errorMessage("error", 'Error launching URL: $e');
  //     // Optionally, show an error message to the user
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFF8E1),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
              normUserController.setLoading(false);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          centerTitle: true,
          title: const Text(
            "Your Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFFFF8E1),
          foregroundColor: const Color.fromARGB(255, 111, 2, 43),
        ),
        body: GetBuilder<NormUserController>(builder: (normUserController) {
          return normUserController.cartItems.isEmpty
              ? const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: normUserController.cartItems.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => Center(
                                            child: Stack(
                                              children: [
                                                Hero(
                                                    tag: "",
                                                    child: Image(
                                                      image: CachedNetworkImageProvider(
                                                          normUserController
                                                                      .cartItems[
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
                                    tag: "Profile Picture$index",
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                normUserController
                                                        .cartItems[index]
                                                    ["imageUrl"]),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                normUserController.cartItems[index]["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Row(
                                children: [
                                  IconButton(
                                    icon: const Card.filled(
                                        shape: BeveledRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomLeft:
                                                    Radius.circular(5))),
                                        elevation: 5,
                                        child: Icon(Icons.remove)),
                                    onPressed: () {
                                      normUserController.updateCard(
                                          index, "dec");
                                      // Decrease quantity
                                    },
                                  ),
                                  Text(normUserController.cartItems[index]
                                          ['quantity']
                                      .toString()),
                                  IconButton(
                                    icon: const Card.filled(
                                        shape: BeveledRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomLeft:
                                                    Radius.circular(5))),
                                        elevation: 5,
                                        child: Icon(Icons.add)),
                                    onPressed: () {
                                      normUserController.updateCard(
                                          index, "inc");
                                      // Increase quantity
                                    },
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
                                            "Rs ${int.parse(normUserController.cartItems[index]['price']) * normUserController.cartItems[index]['quantity']}")),
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          normUserController.deleteItem(
                                              index, widget.userUid);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rs ${normUserController.cartItems.fold(0, (total, item) => total + (int.parse(item['price']) * item['quantity'] as int))}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              _currentLocation = await _getCurrentLocation();
                              await _getAddressFromCoordination();

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Current Location Required",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Wrap(
                                    direction: Axis.vertical,
                                    alignment: WrapAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "Location Coordination",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Location : ${_currentLocation != null ? '${_currentLocation!.latitude}, ${_currentLocation!.longitude}' : 'Location not available'}",
                                      ),
                                      const Text(
                                        "Location Address",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: Text(
                                          "Address: ${_currentAddress.isNotEmpty ? _currentAddress : 'Address not available'}",
                                          softWrap: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        key: _goodToGo,
                                        child: TextFieldWidget(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .65,
                                          validate: (value) {
                                            if (!value!.startsWith("03", 0)) {
                                              return "Invalid Number";
                                            } else if (value.length < 11) {
                                              return "Invalid Number Length";
                                            } else {
                                              return null;
                                            }
                                          },
                                          labelColor: const Color.fromARGB(
                                              255, 111, 2, 43),
                                          labelText: "Phone",
                                          keyboardType: TextInputType.number,
                                          controller: contact,
                                          hintText: "03xxxxxxxxx",
                                          fillColor: const Color.fromARGB(
                                              31, 255, 255, 255),
                                          focusBorderColor:
                                              const Color.fromARGB(
                                                  255, 111, 2, 43),
                                          errorBorderColor: Colors.red,
                                          suffixIconColor: const Color.fromARGB(
                                              255, 111, 2, 43),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          maximumSize:
                                              const Size.fromWidth(145),
                                          shape: const BeveledRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              255, 111, 2, 43),
                                          shadowColor: Colors.black,
                                          elevation: 10,
                                        ),
                                        onPressed: () async {
                                          if (_goodToGo.currentState!
                                              .validate()) {
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                      title: const Text(
                                                        "Choose Payment Method!",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      actions: [
                                                        E1Button(
                                                          backColor: const Color
                                                              .fromARGB(
                                                              255, 111, 2, 43),
                                                          text:
                                                              "Cash on Delivery",
                                                          textColor:
                                                              const Color(
                                                                  0xFFFFF8E1),
                                                          onPressed: () async {
                                                            for (int i = 0;
                                                                i <
                                                                    normUserController
                                                                        .cartItems
                                                                        .length;
                                                                i++) {
                                                              // Create conversation for each receiver
                                                              await chatController
                                                                  .createConversation(
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bUserUid"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bUserName"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bUserEmail"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bProfilePic"],
                                                                widget.userUid,
                                                                widget.userName,
                                                                widget
                                                                    .userEmail,
                                                                widget
                                                                    .profilePicture,
                                                              );

                                                              // Place order (same logic as before)
                                                              normUserController
                                                                  .orderFood(
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bUserUid"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bUserName"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bUserEmail"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "bProfilePic"],
                                                                normUserController
                                                                        .cartItems[
                                                                    i]["name"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "imageUrl"],
                                                                "${int.parse(normUserController.cartItems[i]['price']) * normUserController.cartItems[i]['quantity']}",
                                                                normUserController
                                                                        .cartItems[i]
                                                                    ["cartKey"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    [
                                                                    "quantity"],
                                                                normUserController
                                                                        .cartItems[i]
                                                                    ["dishKey"],
                                                                totalPrice,
                                                                widget.userUid,
                                                                widget.userName,
                                                                widget
                                                                    .userEmail,
                                                                widget
                                                                    .profilePicture,
                                                                _currentAddress,
                                                                _currentLocation!
                                                                    .latitude,
                                                                _currentLocation!
                                                                    .longitude,
                                                                contact.text,
                                                                i,
                                                              );
                                                            }

                                                            Get.off(UserScreen(
                                                                userUid: widget
                                                                    .userUid,
                                                                userName: widget
                                                                    .userName,
                                                                userEmail: widget
                                                                    .userEmail));
                                                          },
                                                        ),
                                                        E1Button(
                                                          backColor: const Color
                                                              .fromARGB(
                                                              255, 111, 2, 43),
                                                          text: "Use Card",
                                                          textColor:
                                                              const Color(
                                                                  0xFFFFF8E1),
                                                          onPressed: () async {
                                                            await normUserController
                                                                .makePayment(
                                                                    totalPrice);
                                                          },
                                                        )
                                                      ],
                                                    ));
                                          }
                                        },
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              );
                              setState(() {
                                totalPrice =
                                    "${normUserController.cartItems.fold(0, (total, item) => total + (int.parse(item['price']) * item['quantity'] as int))}";
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 111, 2, 43),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Proceed Order",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        }));
  }
}
