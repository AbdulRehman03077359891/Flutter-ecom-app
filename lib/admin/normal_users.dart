import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/animation_controller.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';

class NormUsers extends StatefulWidget {
  final String userName, userEmail, profilePicture;
  const NormUsers(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<NormUsers> createState() => _NormUsersState();
}

class _NormUsersState extends State<NormUsers> {
  var controller = Get.put(FireController());
  final AnimateController animateController = Get.put(AnimateController());
  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  getAllUsers() {
    controller.getAllNormUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NormUsers"),
        backgroundColor: const Color.fromARGB(255, 111, 2, 43),
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<FireController>(builder: (controller) {
        return Center(
          child: controller.isLoading
              ? const CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),)
              : ListView.builder(
                  itemCount: controller.usersListN.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color.fromARGB(255, 111, 2, 43),
                      shadowColor: const Color.fromARGB(255, 111, 2, 43),
                      elevation: 30,
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
                                                        controller.usersListN[index]["imageUrl"],
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
                                                                controller.usersListN[index]["imageUrl"]),
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
                          controller.usersListN[index]["name"],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          controller.usersListN[index]["email"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
        );
      }),
    );
  }
}
