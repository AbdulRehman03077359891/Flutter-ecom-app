import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';
import 'package:my_ecom_app/normUsers/dish_details.dart';

// ignore: must_be_immutable
class ViewDishes extends StatefulWidget {
  final String title;
  final String userUid, userName, userEmail, profilePicture;

  const ViewDishes({
    super.key,
    required this.title,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.profilePicture,
  });

  @override
  State<ViewDishes> createState() => _ViewDishesState();
}

class _ViewDishesState extends State<ViewDishes> {
  var normUserController = Get.put(NormUserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    normUserController.getCartItems(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NormUserController>(builder: (normUserController) {
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
              backgroundColor: const Color(0xFFFFF8E1),
              foregroundColor: const Color.fromARGB(255, 111, 2, 56),
              centerTitle: true,
              title: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          body: SingleChildScrollView(
              child: normUserController.selectedDishes.isEmpty
                  ? const Center(
                      child: Text(
                        "No Dishes in this Category",
                        style: TextStyle(
                          color: Color.fromARGB(255, 111, 2, 56),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .88,
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    normUserController.selectedDishes.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: .8),
                                itemBuilder: (context, index) {
                                  bool isInCart = normUserController.checkCard(
                                    normUserController.selectedDishes[index]
                                        ["dishKey"],
                                  );
                                  return Stack(children: [
                                    Card(
                                      elevation: 10,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .33,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 5,
                                              right: 5,
                                              top: 5,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Get.to(DishDetailScreen(
                                                  dishName: normUserController
                                                          .selectedDishes[index]
                                                      ["name"],
                                                  imageUrl: normUserController
                                                          .selectedDishes[index]
                                                      ["imageUrl"],
                                                  price: normUserController
                                                          .selectedDishes[index]
                                                      ["price"],
                                                  bUserUid: normUserController
                                                          .selectedDishes[index]
                                                      ["userUid"],
                                                  bUserName: normUserController
                                                          .selectedDishes[index]
                                                      ["userName"],
                                                  bUserEmail: normUserController
                                                          .selectedDishes[index]
                                                      ["userEmail"],
                                                  dishKey: normUserController
                                                          .selectedDishes[index]
                                                      ["dishKey"],
                                                  bProfilePic: normUserController
                                                          .selectedDishes[index]
                                                      ["profilePicture"],
                                                  description:
                                                      normUserController
                                                              .selectedDishes[
                                                          index]["discription"],
                                                  userUid: widget.userUid,
                                                  userName: widget.userName,
                                                  userEmail: widget.userEmail,
                                                  profilePicture:
                                                      widget.profilePicture,
                                                )),
                                                child: Card(
                                                    elevation: 10,
                                                    child: Container(
                                                      height: 120,
                                                      width: 140,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  normUserController
                                                                              .selectedDishes[
                                                                          index]
                                                                      [
                                                                      "imageUrl"]),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    )),
                                              ),
                                            ),
                                            Positioned(
                                              top: 135,
                                              left: 10,
                                              right: 10,
                                              child: Text(
                                                normUserController
                                                        .selectedDishes[index]
                                                    ["name"],
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                                bottom: 35,
                                                left: 10,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("3.5")
                                                  ],
                                                )),
                                            Positioned(
                                              bottom: 10,
                                              left: 10,
                                              child: Text(
                                                "Rs ${normUserController.selectedDishes[index]["price"]}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 172, 8, 71),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: IconButton(
                                          onPressed: () async {
                                            if (isInCart) {
                                              await normUserController
                                                  .deletCartItem(
                                                      normUserController
                                                              .selectedDishes[
                                                          index]["dishKey"],
                                                      widget.userUid);
                                            } else {
                                              await normUserController.addToCart(
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["name"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["imageUrl"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["price"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["userUid"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["userName"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["userEmail"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["profilePicture"],
                                                  normUserController
                                                          .selectedDishes[index]
                                                      ["dishKey"],
                                                  widget.userUid,
                                                  widget.userName,
                                                  widget.userEmail,
                                                  widget.profilePicture);
                                            }

                                            // Update cart items after action
                                            await normUserController
                                                .getCartItems(widget.userUid);
                                          },
                                          icon: Icon(
                                            isInCart
                                                ? Icons
                                                    .remove_shopping_cart_outlined
                                                : Icons.add_shopping_cart,
                                            size: 25,
                                            color: const Color(0xFFD32F2F),
                                          ),
                                        )),
                                  ]);
                                }))
                      ],
                    )));
    });
  }
}
