import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/business_controller.dart';

class DishData extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const DishData(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<DishData> createState() => _DishDataState();
}

class _DishDataState extends State<DishData> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController dishPriceController = TextEditingController();
  var businessController = Get.put(BusinessController());
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    businessController.getCategory(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        title: const Text("View Dishes",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFFFFF8E1),
        foregroundColor: const Color.fromARGB(255, 111, 2, 43),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),))
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
                            itemCount: businessController.allCategories.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),businessController.allCategories[index]["selected"] == true ? ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Color.fromARGB(
                                                      255, 111, 2, 43))),
                                      onPressed: () {
                                        businessController.getDishes(
                                            index, widget.userUid);
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add_box,
                                              color: Colors.white),
                                          Text(
                                            businessController.allCategories[index]
                                                ["name"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      )):ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      onPressed: () {
                                        businessController.getDishes(
                                            index, widget.userUid);
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add_box,
                                              color: Color.fromARGB(
                                                      255, 111, 2, 43)),
                                          Text(
                                            businessController.allCategories[index]
                                                ["name"],
                                            style: const TextStyle(
                                                color: Color.fromRGBO(111, 2, 43, 1)),
                                          )
                                        ],
                                      )),
                                ],
                              );
                            }),
                      ),businessController.selectedDishes.isEmpty? SizedBox(
                        
                        height: MediaQuery.of(context).size.height*.8,
                        width: MediaQuery.of(context).size.width*.8,
                        child: const Center(
                          child:  Text("No Dish Available",style: TextStyle(color: Color.fromARGB(
                                                          255, 111, 2, 43)),),
                        ),
                      ):
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: businessController.selectedDishes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: const Color.fromARGB(255, 111, 2, 43),
                              shadowColor:
                                  const Color.fromARGB(255, 111, 2, 43),
                              elevation: 10,
                              child: ListTile(
                                leading: Wrap(
                                  children: [
                                    Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Card(
                                          elevation: 10,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                              BoxShadow(
                                  color:  Color.fromARGB(255, 255, 239, 183),
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],border: Border.all(
                              color: const Color.fromARGB(255, 111, 2, 43),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  businessController
                                                          .selectedDishes[index]
                                                      ["imageUrl"]),
                                              fit: BoxFit.cover)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                title: Text(
                                  businessController.selectedDishes[index]
                                      ["name"],
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                                ),
                                trailing: Wrap(
                                  children: [
                                    Column(
                                      children: [
                                        
                                        Text(
                                          "Rs ${businessController.selectedDishes[index]["price"]}",
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        IconButton(onPressed: (){
                                          showDialog(context: context, builder: (_) => AlertDialog(
                                            title: CachedNetworkImage(imageUrl: businessController.selectedDishes[index]["imageUrl"]),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text("Name : ${businessController.selectedDishes[index]["name"]}"),
                                                  Text("Category : ${businessController.selectedDishes[index]["category"]}"),
                                                  Text("Price : ${businessController.selectedDishes[index]["price"]}"),
                                                  Text("Discription : ${businessController.selectedDishes[index]["discription"]}"),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                              maximumSize: const Size.fromWidth(145),
                              shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 111, 2, 43),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "OK",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white,fontWeight: FontWeight.bold),
                                                      )),],
                                          ));
                                        }, icon: const Icon(Icons.info_outline,color: Colors.white,))
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
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          111,
                                                                          2,
                                                                          43))),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          111,
                                                                          2,
                                                                          43))),
                                                      onPressed: () {
                                                        businessController
                                                            .deletDish(
                                                                index);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                  businessController.selectedDishes[index]
                                      ["category"],
                                  style: const TextStyle(color: Colors.white),
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
