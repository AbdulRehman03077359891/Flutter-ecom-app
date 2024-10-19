import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';
import 'package:my_ecom_app/normUsers/dish_details.dart';

class SearchScreen extends StatefulWidget {
  final String userUid;
  final String userName;
  final String userEmail;
  final String profilePicture;

  const SearchScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.profilePicture,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();
  bool isSearchClicked = false;
  String searchText = "";
  List<String> items = [];

  List<String> filteredItems = [];
  var normUserController = Get.put(NormUserController());
  @override
  void initState() {
    super.initState();
    _initSearch();
  }

  Future<void> _initSearch() async {
    await getAllDishes();
    setState(() {
      filteredItems = List.from(items);
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      myFilterItems();
    });
  }

  void myFilterItems() {
    if (searchText.isEmpty) {
      filteredItems = List.from(items);
    } else {
      filteredItems = items
          .where(
              (item) => item.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  getAllDishes() async {
    await normUserController.getAllDishesData();
    await listItems();
  }

  listItems() async {
    for (int i = 0; i < normUserController.gotAllDishesData.length; i++) {
      items.add(await normUserController.gotAllDishesData[i]["name"]);
    }
  }

  void _onItemTap(String itemName) {
    final selectedDish = normUserController.gotAllDishesData
        .firstWhere((dish) => dish['name'] == itemName);

    Get.to(() => DishDetailScreen(
          dishName: selectedDish['name'],
          imageUrl: selectedDish['imageUrl'],
          price: selectedDish['price'],
          bUserUid: selectedDish['userUid'],
          bUserName: selectedDish['userName'],
          bUserEmail: selectedDish['userEmail'],
          bProfilePic: selectedDish['profilePicture'],
          dishKey: selectedDish["dishKey"],
          userUid: widget.userUid,
          userName: widget.userName,
          userEmail: widget.userEmail,
          profilePicture: widget.profilePicture,
          description: selectedDish['discription'],
        ));
  }

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
        ),foregroundColor: const Color.fromARGB(255, 111, 2, 56),
        backgroundColor: const Color(0xFFFFF8E1),
        title: isSearchClicked
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 111, 2, 43)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  cursorColor: const Color.fromARGB(255, 111, 2, 43),
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                      contentPadding:  EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      hintText: "Search..."),
                ),
              )
            : const Text("Search Food"),
            centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClicked = !isSearchClicked;
                  if (!isSearchClicked) {
                    searchController.clear();
                    myFilterItems();
                  }
                });
              },
              icon: Icon(isSearchClicked ? Icons.close : Icons.search))
        ],
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filteredItems[index]),
              dense: true,
              onTap: () => _onItemTap(filteredItems[index]),
            );
          }),
    );
  }
}
