import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_ecom_app/Controllers/business_controller.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/Widgets/text_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDish extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const AddDish(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddDish> createState() => _AddDishState();
}

class _AddDishState extends State<AddDish> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController dishPriceController = TextEditingController();
  TextEditingController dishDiscriptionController = TextEditingController();
  var businessController = Get.put(BusinessController());

  showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (await businessController
                                .requestPermision(Permission.camera) ==
                            true) {
                          businessController.pickAndCropImage(
                              ImageSource.camera, context);
                          errorMessage(
                              "success", "permision for storage is granted");
                        } else {
                          errorMessage(
                              "error", "permision for storage is not granted");
                        }
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 111, 2, 43),
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () async {
                      if (await businessController
                              .requestPermision(Permission.storage) ==
                          true) {
                        businessController.pickAndCropImage(
                            ImageSource.gallery, context);
                        errorMessage(
                            "success", "permision for storage is granted");
                      } else {
                        errorMessage(
                            "error", "permision for storage is not granted");
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 111, 2, 43),
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

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
        toolbarHeight: 40,
        centerTitle: true,
        leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        title: const Text("Add Dishes",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFFFFF8E1),
        foregroundColor: const Color.fromARGB(255, 111, 2, 43),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),))
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showBottomSheet();
                          },
                          child: businessController.pickedImageFile.value ==
                                  null
                              ? Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/dishPlaceHolder.png"),
                                            fit: BoxFit.cover)),
                                  ))
                              : Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(businessController
                                                .pickedImageFile.value!),
                                            fit: BoxFit.cover)),
                                  )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: dishNameController,
                          focusBorderColor:
                              const Color.fromARGB(255, 111, 2, 43),
                          hintText: "Enter your Dish Name",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          lines: 1,
                          prefixIcon: const Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                " RS: ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 111, 2, 43),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          keyboardType: TextInputType.number,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: dishPriceController,
                          focusBorderColor:
                              const Color.fromARGB(255, 111, 2, 43),
                          hintText: "Enter your Dish Price",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          lines: 8,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: dishDiscriptionController,
                          focusBorderColor:
                              const Color.fromARGB(255, 111, 2, 43),
                          hintText: "Enter your Dish Discription",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 111, 2, 43),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  hint: businessController.dropDownValue == ""
                                      ? const Text(
                                          "Select Category",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          businessController.dropDownValue
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                  isExpanded: true,
                                  dropdownColor:
                                      const Color.fromARGB(255, 111, 2, 43),
                                  iconEnabledColor: Colors.white,
                                  // value: businessController.dropDownValue,
                                  items: businessController.allCategories
                                      .map((items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items["name"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      businessController
                                          .setDropDownValue(newValue);
                                    });
                                  }),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                              businessController.addDish(
                                  dishNameController.text,
                                  dishPriceController.text,
                                  dishDiscriptionController.text,
                                  widget.userUid,
                                  widget.userName,
                                  widget.userEmail,
                                  widget.profilePicture);
                              dishNameController.clear();
                              dishPriceController.clear();
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add_box, color: Colors.white),
                                Text(
                                  "Add Dishes",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                            const SizedBox(height: 10,)
                      ],
                    ),
                  ),
                );
        },
      ),
      );
  }
}
