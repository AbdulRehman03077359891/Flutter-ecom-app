import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_ecom_app/Controllers/admin_controller.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/Widgets/text_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class AddCategory extends StatefulWidget {
  final String userName, userEmail, profilePicture;
  const AddCategory(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryController = TextEditingController();
  var adminController = Get.put(AdminController());
  TextEditingController editingController = TextEditingController();
  late int selectedIndex;

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
                        if (await adminController
                                .requestPermision(Permission.camera) ==
                            true) {
                          adminController.pickAndCropImage(
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
                      if (await adminController
                              .requestPermision(Permission.storage) ==
                          true) {
                        adminController.pickAndCropImage(
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
    getAllCategory();
  }

  getAllCategory() {
    adminController.getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Category"),
        backgroundColor: const Color.fromARGB(255, 111, 2, 43),
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<AdminController>(builder: (adminController) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: adminController.pickedImageFile.value == null
                      ? const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/dishPlaceHolder.png"),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundImage: FileImage(
                              adminController.pickedImageFile.value!)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    controller: categoryController,
                    focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                    hintText: "Enter your Category",
                    errorBorderColor: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                adminController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 111, 2, 43),
                        ),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            fixedSize:
                                MaterialStatePropertyAll<Size>(Size(160, 20)),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 111, 2, 43))),
                        onPressed: () {
                          adminController.addCategory(categoryController.text);
                          categoryController.clear();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_box, color: Colors.white),
                            Text(
                              "Add Category",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      const Center(
                          child: Text(
                        'All Categories',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                      DataTable(
                        headingRowColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 111, 2, 43)),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(
                              label: Text('S.NO',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Category',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Action',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                        rows: List.generate(adminController.catList.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                                Text(adminController.catList[index]["name"])),
                            DataCell(Row(
                              children: [
                                adminController.catList[index]["status"]
                                    ? GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateCatStatus(index);
                                        },
                                        child: const Icon(
                                            Icons.check_box_outlined))
                                    : GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateCatStatus(index);
                                        },
                                        child: const Icon(Icons
                                            .check_box_outline_blank_outlined),
                                      ),
                                Text(adminController.catList[index]["status"]
                                    .toString()),
                              ],
                            )),
                            DataCell(Row(
                              children: [
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
                                                        adminController
                                                            .deletCategory(
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
                                    icon: const Icon(Icons.delete)),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = index;
                                        editingController.text = adminController
                                            .catList[index]["name"]
                                            .toString();
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Column(
                                                  children: [
                                                    GestureDetector(onTap: () {
                                                      showBottomSheet();
                                                    }, child: Obx(() {
                                                      return adminController
                                                                  .pickedImageFile
                                                                  .value ==
                                                              null
                                                          ? const CircleAvatar(
                                                              radius: 50,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      "assets/images/dishPlaceHolder.png"),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 70,
                                                              backgroundImage: FileImage(
                                                                  adminController
                                                                      .pickedImageFile
                                                                      .value!));
                                                    })),
                                                    TextField(
                                                      controller:
                                                          editingController,
                                                    ),
                                                  ],
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
                                                        adminController
                                                            .updateCatData(
                                                                index,
                                                                editingController
                                                                    .text);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Update",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ))
                          ]);
                        }),
                      ),
                    ])
              ],
            ),
          ),
        );
      }),
    );
  }
}
