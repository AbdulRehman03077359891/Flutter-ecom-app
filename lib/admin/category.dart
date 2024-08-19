import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/AdminController.dart';
import 'package:my_ecom_app/Widgets/DrawerWidget.dart';
import 'package:my_ecom_app/Widgets/TextFieldWidget.dart';

class AddCategory extends StatefulWidget {
  final userName, userEmail, profilePicture;
  const AddCategory(
      {super.key, this.userName, this.userEmail, this.profilePicture});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryController = TextEditingController();
  var adminController = Get.put(AdminController());
  TextEditingController editingController = TextEditingController();
  late int selectedIndex;
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
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                controller: categoryController,
                focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                hintText: "Enter your Category",
                errorBorderColor: Colors.red,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      fixedSize: MaterialStatePropertyAll<Size>(Size(160, 20)),
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
              const Divider(),
              ListView(shrinkWrap: true, children: [
                const Center(
                    child: Text(
                  'All Categories',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  rows: List.generate(adminController.catList.length, (index) {
                    return DataRow(cells: [
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(adminController.catList[index]["name"])),
                      DataCell(Row(
                        children: [
                          adminController.catList[index]["status"]
                              ? GestureDetector(
                                  onTap: () {
                                    adminController.updateCatStatus(index);
                                  },
                                  child: const Icon(Icons.check_box_outlined))
                              : GestureDetector(
                                  onTap: () {
                                    adminController.updateCatStatus(index);
                                  },
                                  child: const Icon(
                                      Icons.check_box_outline_blank_outlined),
                                ),
                          Text(adminController.catList[index]["status"]
                              .toString()),
                        ],
                      )),
                      DataCell(Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                adminController.deletCategory(index);
                              },
                              icon: const Icon(Icons.delete)),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                  editingController.text =
                                      adminController.catList[index]["name"].toString();
                                });
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: TextField(
                                            controller: editingController,
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Color.fromARGB(255,
                                                                111, 2, 43))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Color.fromARGB(255,
                                                                111, 2, 43))),
                                                onPressed: () {
                                                  adminController.updateCatName(
                                                      index, editingController.text);
                                                      Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
        );
      }),
      endDrawer: DrawerWidget(
          accountName: widget.userName,
          accountEmail: widget.userEmail,
          profilePicture: widget.profilePicture),
    );
  }
}
