import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminController extends GetxController {
  var isLoading = true;
  var catList = [];
  late String _imageLink = '';
  final pickedImageFile = Rx<File?>(null);
  var allCategories = [];
  var selectedDishes = [];


// Setting Loading ---------------------------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }
// Category Settings -------------------------------------------------------

// Get Data================
  getCategoryList() async {
    setLoading(true);
    catList.clear();
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.get().then((QuerySnapshot data) {
      for (var element in data.docs) {
        catList.add(element.data());
      }
    });
    setLoading(false);
    update();
  }

  getCategory() async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst
        .where("status", isEqualTo: true)
        .get()
        .then((QuerySnapshot data) {
      allCategories = data.docs.map((doc) => doc.data()).toList();
      var newData = {
        "catKey": "",
        "name": "All",
        "status": true,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/humanlibrary-1c35f.appspot.com/o/dish%2Fdata%2Fuser%2F0%2Fcom.example.my_ecom_app%2Fcache%2Fddef191b-ec35-409a-97d0-97f477f3ba23%2F1000340493.jpg?alt=media&token=73b61dd1-a8f8-441f-87cb-24eb4af30c7e",
        "selected" : false,
      };
      allCategories = allCategories;
      allCategories.insert(0, newData);
      getDishes(0);
    });
    setLoading(false);
    update();
  }

// Get Dish via Category==========
  getDishes(index) async {
    for(int i = 0; i <allCategories.length; i++){
      allCategories[i]["selected"] = false;
    }
    allCategories[index]["selected"] = true;
    if (allCategories[index]["catKey"] == "") {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst
          .get()
          .then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();});
      } else {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst
          .where("catKey", isEqualTo: allCategories[index]["catKey"])
          .get()
          .then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();
      });
    }
  }
// Delete Dishes
   deletDish(index) async {
    CollectionReference dishInst = FirebaseFirestore.instance.collection("Dishes");
    await dishInst.doc(selectedDishes[index]["dishKey"]).delete();
    selectedDishes.removeAt(index);
    update();
  }


// Delete Category============
  deletCategory(index) async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.doc(catList[index]["catKey"]).delete();
    catList.removeAt(index);
    setLoading(false);
    update();
  }

// Update Category Status=======
  updateCatStatus(index) async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst
        .doc(catList[index]["catKey"])
        .update({"status": !catList[index]["status"]});
    catList[index]["status"] = !catList[index]["status"];
    setLoading(false);
    update();
  }

// Update Category Data=============
  updateCatData(index, name) async {
    setLoading(true);
    if (name.isEmpty) {
      errorMessage("error", "Please enter a valid name");
      return;
    }
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("dish/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink = downloadUrl;
      updateCategory(index, name);
      update();
      
    } catch (e) {
      setLoading(false);
      errorMessage("error", "ImageStorages ${e.toString()}");
    }
    

    
  }
  updateCategory(index,name) async {
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");

    var docKey = catList[index]["catKey"];
    var doc = await categoryInst.doc(docKey).get();

    if (doc.exists) {
      await categoryInst.doc(docKey).update({
        "name": name,
        "imageUrl": _imageLink,
      }).then((_) {
        getCategoryList();
        pickedImageFile.value = null;
        setLoading(false);
        update();
        errorMessage("Success", "Category updated successfully");
      }).catchError((error) {
        setLoading(false);
        errorMessage("error", "Failed to update name: $error");
      });
    } else {
      setLoading(false);
      errorMessage("error", "Document not found");
    }
  }
// Adding New Category======
  addCategory(String name) {
    setLoading(true);
    if (name.isEmpty) {
      errorMessage("error", "Please enter Category");
    } else {
      imageStoreStorage(name);
    }
  }

//Storing Category Image -----------------------------------------------
  imageStoreStorage(name) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("dish/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink = downloadUrl;
      fireStoreDBase(name);
      update();
    } catch (e) {
      setLoading(false);
      errorMessage("error", "ImageStorages ${e.toString()}");
    }
  }

// Storing New Category Data in Firebase Data Base===
  fireStoreDBase(name) async {
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    var key = FirebaseDatabase.instance.ref("Category").push().key;
    var categoryObj = {
      "name": name,
      "status": true,
      "catKey": key,
      "imageUrl": _imageLink,
      "selected": false,  
    };
    await categoryInst.doc(key).set(categoryObj);
    errorMessage("Success", "Category added Successfully");
    pickedImageFile.value = null ;
    getCategoryList();
    setLoading(false);
    update();
  }

// Taking permission to from Mobile ==========================
  Future<bool> requestPermision(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

// Taking Category Picture from Camera/Storage =====================
  Future<void> pickAndCropImage(ImageSource source, context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          pickedImageFile.value = croppedFile;
          update();
        }else {
        errorMessage("error", "Image cropping was canceled or failed.");
      }
    } else {
      errorMessage("error", "Image picking was canceled.");
    }
      
    } catch (e) {
      errorMessage("error", "Failed to pick or crop image: $e");
    }
    finally{
      Navigator.pop(context);
    }
  }
// Cropping Image=================================
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,

        uiSettings: [
          AndroidUiSettings(
            
            toolbarTitle: "Image Cropper",
            toolbarColor: const Color.fromARGB(255, 111, 2, 43),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
            hideBottomControls: true
          ),
          IOSUiSettings(
            title: "Image Cropper",
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
      errorMessage("error", "No image was cropped.");
      return null;
      }
    } catch (e) {
      errorMessage("error", "Failed to crop image: $e");
    }
    return null;
  }
  

}
