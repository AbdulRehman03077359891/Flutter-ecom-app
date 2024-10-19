import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';
import 'package:my_ecom_app/normUsers/user_cart.dart';

class DishDetailScreen extends StatefulWidget {
  final String dishName;
  final String imageUrl;
  final String price;
  final String userUid;
  final String dishKey;
  final String userName;
  final String userEmail;  
  final String profilePicture;
  final String bUserUid;
  final String bUserName;
  final String bUserEmail;
  final String bProfilePic;
  final String? description;

  const DishDetailScreen({
    super.key,
    required this.dishName,
    required this.imageUrl,
    required this.price,
    required this.userUid,
    required this.dishKey,
    required this.userName,
    required this.userEmail,    
    required this.profilePicture,
    required this.bUserUid,
    required this.bUserName,
    required this.bUserEmail,
    required this.bProfilePic,
    
    this.description,
  });

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  var normUserController = Get.put(NormUserController());
  bool isInCart = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    // });
  }

  getAllCategory() async {
    await normUserController.getCartItems(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 111, 2, 43),
        backgroundColor: const Color(0xFFFFF8E1),
        title: Text(widget.dishName,style: const TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: () {
                Get.off(CartScreen(
                  userUid: widget.userUid,
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                  profilePicture: widget.profilePicture
                ));
              },
              icon: const Icon(Icons.shopping_cart_checkout))
        ],
      ),
      body: GetBuilder<NormUserController>(builder: (normUserController) {
        isInCart = normUserController.checkCard(widget.dishKey);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5,),
              // Dish Image
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.width*.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(widget.imageUrl),fit: BoxFit.cover)),
                  // child: CachedNetworkImage(
                  //   imageUrl: widget.imageUrl,
                  //   height: 250,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  //   placeholder: (context, url) => const Center(
                  //     child: CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),),
                  //   ),
                  //   errorWidget: (context, url, error) => const Icon(Icons.error),
                  // ),
                ),
              ),
              const SizedBox(height: 20),

              // Dish Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.dishName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rs ${widget.price}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                    const Row(
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
                                                )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.description ?? "description",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add to Cart Button
              Center(
                child: isInCart == true
                    ? OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color.fromARGB(255, 111, 2, 43),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          'Already Added to Cart',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 111, 2, 43),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          normUserController.addToCart(
                              widget.dishName,
                              widget.imageUrl,
                              widget.price,
                              widget.bUserUid,
                              widget.bUserName,
                              widget.bUserEmail,
                              widget.bProfilePic,
                              widget.dishKey,
                              widget.userUid,
                              widget.userName,
                              widget.userEmail,
                              widget.profilePicture);
                          // Example: Add the dish to the cart
                          Get.snackbar(
                            'Added to Cart',
                            'The dish has been added to your cart.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.withOpacity(0.7),
                            colorText: Colors.white,
                          );
                          setState(() {
                            
                          });
                          // Get.to(CartScreen(
                          //     userUid: widget.userUid,
                          //     userName: widget.userName,
                          //     userEmail: widget.userEmail));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 111, 2, 43),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
