import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Widgets/Message.dart';

class AdminController extends GetxController {
  var isLoading = true;
  var catList = [];


  getCategoryList() async {
    catList.clear();
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.get().then((QuerySnapshot data) {
      data.docs.forEach((element) {
        catList.add(element.data());
      });
    });
    update();
  }

  deletCategory(index) async {
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.doc(catList[index]["catKey"]).delete();
    catList.removeAt(index);
    update();
  }
  updateCatStatus(index) async {
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.doc(catList[index]["catKey"]).update({
      "status" : !catList[index]["status"]
    });
    catList[index]["status"] = !catList[index]["status"];
    update();
  }
  updateCatName(index, name) async {
  if (name.isEmpty) {
    ErrorMessage("error", "Please enter a valid name");
    return;
  }

  CollectionReference categoryInst = FirebaseFirestore.instance.collection("Category");

  var docKey = catList[index]["catKey"];
  var doc = await categoryInst.doc(docKey).get();

  if (doc.exists) {
    await categoryInst.doc(docKey).update({
      "name": name,
    }).then((_) {
      getCategoryList();
      ErrorMessage("Success", "Category name updated successfully");
    }).catchError((error) {
      ErrorMessage("error", "Failed to update name: $error");
    });
  } else {
    ErrorMessage("error", "Document not found");
  }
}

  addCategory(String name) async {
    if (name.isEmpty) {
      ErrorMessage("error", "Please enter Category");
    } else {
      var key = FirebaseDatabase.instance.ref("Category").push().key;
      var categoryObj = {
        "name": name,
        "status": true,
        "catKey": key,
      };
      CollectionReference categoryInst =
          FirebaseFirestore.instance.collection("Category");
      await categoryInst.doc(key).set(categoryObj);
      ErrorMessage("Success", "Category added Successfully");
      getCategoryList();
    }
  }
}
