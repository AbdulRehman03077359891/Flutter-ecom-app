import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/admin_controller.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';

class AdminDishData extends StatefulWidget {
  final String userName, userEmail, profilePicture;

  const AdminDishData(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AdminDishData> createState() => _AdminDishDataState();
}

class _AdminDishDataState extends State<AdminDishData> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController dishPriceController = TextEditingController();
  var adminController = Get.put(AdminController());
  var animateController = Get.put(AnimateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    adminController.getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("View Dishes"),
        backgroundColor: const Color.fromARGB(255, 111, 2, 43),
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<AdminController>(
        builder: (adminController) {
          return adminController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 111, 2, 43),
                ))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: adminController.allCategories.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  adminController.allCategories[index]
                                              ["selected"] ==
                                          true
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: const BeveledRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              10)))),
                                          onPressed: () {
                                            adminController.getDishes(
                                              index,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add_box,
                                                  color: Color.fromARGB(
                                                      255, 111, 2, 43)),
                                              Text(
                                                adminController
                                                        .allCategories[index]
                                                    ["name"],
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        111, 2, 43, 1)),
                                              )
                                            ],
                                          ))
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      111, 2, 43, 1),
                                              shape: const BeveledRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10)))),
                                          onPressed: () {
                                            adminController.getDishes(
                                              index,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add_box,
                                                  color: Colors.white),
                                              Text(
                                                adminController
                                                        .allCategories[index]
                                                    ["name"],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      adminController.selectedDishes.isEmpty
                          ? const Text(
                              "No Dish Available",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 111, 2, 43)),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: adminController.selectedDishes.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.all(5),
                                  shape: const BeveledRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20))),
                                  color: const Color.fromARGB(255, 111, 2, 43),
                                  shadowColor:
                                      const Color.fromARGB(255, 111, 2, 43),
                                  elevation: 10,
                                  child: ListTile(
                                    leading: Wrap(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                animateController
                                                    .showSecondPage(
                                                        "image$index",
                                                        adminController
                                                                .selectedDishes[
                                                            index]["imageUrl"],
                                                        context);
                                              },
                                              child: Hero(
                                                tag: "image$index",
                                                child: Card(
                                                  elevation: 10,
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                adminController
                                                                            .selectedDishes[
                                                                        index][
                                                                    "imageUrl"]),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      adminController.selectedDishes[index]
                                          ["name"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    trailing: Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Rs ${adminController.selectedDishes[index]["price"]}",
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (_) => AlertDialog(
                                                                title: CachedNetworkImage(
                                                                    imageUrl: adminController
                                                                            .selectedDishes[index]
                                                                        [
                                                                        "profilePicture"]),
                                                                content: Column(
                                                                  children: [
                                                                    Text(
                                                                        "Name : ${adminController.selectedDishes[index]["userName"]}"),
                                                                    Text(
                                                                        "UID : ${adminController.selectedDishes[index]["userUid"]}"),
                                                                    Text(
                                                                        "Email : ${adminController.selectedDishes[index]["userEmail"]}"),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      style: const ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Color.fromARGB(
                                                                              255,
                                                                              111,
                                                                              2,
                                                                              43))),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "OK",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                ],
                                                              ));
                                                },
                                                icon: const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        title: const Text(
                                                          "Are you sure?",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                              style: const ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(Color.fromARGB(
                                                                          255,
                                                                          111,
                                                                          2,
                                                                          43))),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                          ElevatedButton(
                                                              style: const ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(Color.fromARGB(
                                                                          255,
                                                                          111,
                                                                          2,
                                                                          43))),
                                                              onPressed: () {
                                                                adminController
                                                                    .deletDish(
                                                                        index);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ))
                                                        ],
                                                      ));
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 27,
                                            )),
                                      ],
                                    ),
                                    subtitle: Text(
                                      adminController.selectedDishes[index]
                                          ["category"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              })
                    ],
                  ),
                );
        },
      ),
    );
  }
}
