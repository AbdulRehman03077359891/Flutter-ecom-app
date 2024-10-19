import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/normUsers/nOrders/n_orders_main_page.dart';
import 'package:my_ecom_app/Widgets/user_drawer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_ecom_app/normUsers/search_screen.dart';
import 'package:my_ecom_app/normUsers/user_cart.dart';

class UserScreen extends StatefulWidget {
  final String userUid, userName, userEmail;
  final profilePicture;

  const UserScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    this.profilePicture,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var normUserController = Get.put(NormUserController());
  var fireController = Get.put(FireController());
  // var items = [];
  var address = "";
  var profilePic = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      fetchData();
      getAllCategory();
      // items = normUserController.cartItems;
    });
  }

  getAllCategory() {
    normUserController.getCategory();
    normUserController.getCartItems(widget.userUid);
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.userUid, "go");
    address = fireController.userData["address"];
    profilePic = fireController.userData["imageUrl"];
  }

  // Finding Address -------------------------------------------------------
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "non";

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF8E1),
        body: normUserController.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 111, 2, 43),
                ),
              )
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                    SliverAppBar(
                      actions: [
                        IconButton(
                          onPressed: () {
                            Get.to(SearchScreen(
                              userUid: widget.userUid,
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                              profilePicture: profilePic,
                            ));
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                          tooltip: "Cart",
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(Orders(
                              userUid: widget.userUid,
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                            ));
                          },
                          icon: const Icon(Icons.fastfood_outlined),
                          tooltip: "Orders",
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(CartScreen(
                                userUid: widget.userUid,
                                userName: widget.userName,
                                userEmail: widget.userEmail,
                                profilePicture: profilePic,
                              ));
                            },
                            icon: const Icon(
                              Icons.shopping_cart_checkout_outlined,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                      backgroundColor: const Color.fromARGB(255, 111, 2, 43),
                      shadowColor: Colors.white,
                      foregroundColor: Colors.white,
                      pinned: true,
                      floating: true,
                      snap: false,
                      expandedHeight: 160,
                      flexibleSpace: FlexibleSpaceBar(
                        title: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 1200),
                          child: const Text(
                            "Halal Panda",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 111, 2, 43),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  )
                                ]),
                          ),
                          builder: (BuildContext context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: value * 10),
                                child: child,
                              ),
                            );
                          },
                        ),
                        background: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/images/choose.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: 40,
                                  left: 40,
                                  child: IconButton(
                                      onPressed: () async {
                                        _currentLocation =
                                            await _getCurrentLocation();
                                        await _getAddressFromCoordination();
                                        await fireController.updateUserAddress(
                                            _currentAddress.toString(),
                                            widget.userUid,
                                            widget.userName,
                                            widget.userEmail);
                                      },
                                      icon: const Icon(
                                        Icons.fmd_good_outlined,
                                        color: Colors.white,
                                      ))),
                              Positioned(
                                  top: 30,
                                  left: 75,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .40,
                                      child: TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration:
                                            const Duration(milliseconds: 1200),
                                        child: Text(
                                          address,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            shadows: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 111, 2, 43),
                                                  spreadRadius: 5,
                                                  blurRadius: 20)
                                            ],
                                          ),
                                        ),
                                        builder: (BuildContext context,
                                            double value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: value * 20),
                                              child: child,
                                            ),
                                          );
                                        },
                                      )))
                            ])),
                      ),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Check if there are categories available before building the CarouselSlider
                      normUserController.allCategories.isNotEmpty
                          ? SizedBox(
                              height: 250,
                              child: CarouselSlider.builder(
                                itemCount:
                                    normUserController.allCategories.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Wrap(children: [
                                  Column(children: [
                                    Card(
                                        elevation: 10,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      normUserController
                                                                  .allCategories[
                                                              itemIndex]
                                                          ["imageUrl"]),
                                                  fit: BoxFit.cover)),
                                        )),
                                    Text(
                                      normUserController
                                          .allCategories[itemIndex]["name"],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])
                                ]),
                                options: CarouselOptions(
                                    height: 200,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 30),
                                    autoPlayAnimationDuration:
                                        const Duration(seconds: 4)),
                              ),
                            )
                          : const Center(
                              child: Text(
                                  "No categories available")), // Display a message if the list is empty

                      const Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Cuisines",
                            style: TextStyle(
                                color: Color.fromARGB(255, 111, 2, 43),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: 5,
                                      blurRadius: 10)
                                ]),
                          ),
                        ],
                      ), // Check if there are categories before building the GridView
                      normUserController.allCategories.isNotEmpty
                          ? SizedBox(
                              height: 200,
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    normUserController.allCategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          normUserController.getDishes(
                                            index,
                                            normUserController
                                                .allCategories[index]["name"],
                                            widget.userName,
                                            widget.userEmail,
                                            widget.userUid,
                                            profilePic,
                                          );
                                        },
                                        child: Card(
                                            elevation: 10,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: CachedNetworkImageProvider(
                                                          normUserController
                                                                  .allCategories[
                                                              index]["imageUrl"]),
                                                      fit: BoxFit.cover)),
                                            )),
                                      ),
                                      Text(
                                        normUserController.allCategories[index]
                                            ["name"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : const Center(child: Text("No cuisines available")),
                      Container(
                        child: const Text("deals VVVV data"),
                      )
                    ],
                  ),
                ),
              ),
        drawer: UserDrawerWidget(
          userUid: widget.userUid,
          accountName: widget.userName,
          accountEmail: widget.userEmail,
          // profilePicture: profilePic
        ),
      );
    });
  }
}
