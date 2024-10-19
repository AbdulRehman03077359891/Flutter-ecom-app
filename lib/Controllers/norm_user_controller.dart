
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/normUsers/view_dishes.dart';
import 'package:http/http.dart' as http;


class NormUserController extends GetxController {
  var isLoading = false;
  var allCategories = [];
  var selectedDishes = [];
  var cartItems = [];
  var gotAllDishesData = [];
  var allOrders = [];
  List pendingOrders = [];
  List acceptedOrders = [];
  List shippedOrders = [];
  List deliveredOrders = [];
  List cancelledOrders = [];

  Map<String , dynamic>? paymentIntent;

  setLoading(value) {
    isLoading = value;
    update();
  }

// Get Data Category Data -------------------------------------------------
  getCategory() async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst
        .where("status", isEqualTo: true)
        .get()
        .then((QuerySnapshot data) {
      allCategories = data.docs.map((doc) => doc.data()).toList();
      // var newData = {
      //   "catKey": "",
      //   "name": "All",
      //   "status": true,
      //   "imageUrl":
      //       "https://firebasestorage.googleapis.com/v0/b/humanlibrary-1c35f.appspot.com/o/dish%2Fdata%2Fuser%2F0%2Fcom.example.my_ecom_app%2Fcache%2Fddef191b-ec35-409a-97d0-97f477f3ba23%2F1000340493.jpg?alt=media&token=73b61dd1-a8f8-441f-87cb-24eb4af30c7e"
      // };
      // allCategories = allCategories;
      // allCategories.insert(0, newData);
      setLoading(false);
    });
    setLoading(false);
    update();
  }

// Getting Dish Data ------------------------------------------------------
  getDishes(index, title, userName, userEmail, userUid, 
  profilePicture,
      ) async {
    setLoading(true);
    if (allCategories[index]["catKey"] == "") {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst.get().then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();
        Get.to(ViewDishes(
          title: title,
          userName: userName,
          userEmail: userEmail,
          userUid: userUid,
          profilePicture: profilePicture,
          
        ));
        setLoading(false);
      });
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
        Get.to(ViewDishes(
          title: title,
          userName: userName,
          userEmail: userEmail,
          userUid: userUid,
          profilePicture: profilePicture,
          
        ));
        setLoading(false);
      });
    }
  }

// Cart Settinngs ----------------------------------------------------------

// Updating  Item Quantity ==
  updateCard(index, status) {
    if (status == "inc") {
      cartItems[index]["quantity"] += 1;
    } else if (cartItems[index]["quantity"] != 1) {
      cartItems[index]["quantity"] -= 1;
    }
    update();
  }

// Adding Data in Cart =========================================
  addToCart(dishName, imageUrl, price, userUid, userName, userEmail, bProfilePic, dishKey,nUserUid, nUserName, nUserEmail, nProfilePic) async {
    
    CollectionReference cartInst =
        FirebaseFirestore.instance.collection("Cart");
    var cartKey = FirebaseDatabase.instance.ref("Cart").push().key;
    var cartObj = {
        "bUserUid" : userUid,
        "bUserName" : userName,
        "bUserEmail" : userEmail,
        "bProfilePic" : bProfilePic,
      "name": dishName,
      "imageUrl": imageUrl,
      "price": price,
      "cartKey": cartKey,
      "quantity": 1,
      "dishKey": dishKey,
      "userUid": nUserUid,
      "nUserName": nUserName,
      "nUserEmail": nUserEmail,
      "nProfilePic" : nProfilePic,
    };
    await cartInst.doc(cartKey).set(cartObj);
    errorMessage("Success", "dish added to cart Successfully");
    
    await getCartItems(nUserUid);
    update();
  }

// Getting Data================
  getCartItems(userUid) async {
    setLoading(true);
    CollectionReference cartInst =
        FirebaseFirestore.instance.collection("Cart");
    await cartInst
        .where("userUid", isEqualTo: userUid)
        .get()
        .then((QuerySnapshot data) {
      cartItems = data.docs.map((doc) => doc.data()).toList();
    });
    setLoading(false);
    update();
}

// Deleting Data ==============
  deletCartItem(dishKey, userUid) async {
  setLoading(true);
  CollectionReference cartInst = FirebaseFirestore.instance.collection("Cart");
  
  // Find the item index in cartItems
  int index = cartItems.indexWhere((item) => item["dishKey"] == dishKey);
  
  if (index != -1) {
    await cartInst.doc(cartItems[index]["cartKey"]).delete();
    cartItems.removeAt(index);
  }
      errorMessage("Success", "dish removed from cart Successfully");

    await getCartItems(userUid);
  setLoading(false);
  update();
}
  deleteItem(index, userUid) async {
  setLoading(true);
  CollectionReference cartInst = FirebaseFirestore.instance.collection("Cart");
  
    await cartInst.doc(cartItems[index]["cartKey"]).delete();
    cartItems.removeAt(index);
  
  setLoading(false);
  update();
    await getCartItems(userUid);
}

// Ceck Cart if dish already in it or not ==
  bool checkCard(data,) {
    var check = false;
    for (var i = 0; i < cartItems.length; i++) {
      if (cartItems[i]["dishKey"] == data) {
        check = true;
        
      }
    }
    return check;
  }
// Search Bar settings----------------------------------------------------
//Get Dishes
  getAllDishesData() async {
    CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst.get().then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        gotAllDishesData = allDishesData;
        update();
      });
  }

  orderFood(bUserUid, bUserName, bUserEmail, bProfilePic, dishName, imageUrl, price, cartKey, quantity, dishKey, totalPrice, nUserUid, nUserName, nUserEmail, nProfilePic, nAddress, nLatitude, nLongitude, nContact , index) async {
    CollectionReference orderInst = FirebaseFirestore.instance.collection("Orders");
    var orderKey = FirebaseDatabase.instance.ref("Orders").push().key;
    var orderObj = {
      "bUserUid" : bUserUid,
        "bUserName" : bUserName,
        "bUserEmail" : bUserEmail,
        "bProfilePic" : bProfilePic,
      "name": dishName,
      "imageUrl": imageUrl,
      "price": price,
      "cartKey": cartKey,
      "quantity": quantity,
      "dishKey": dishKey,
      "orderKey": orderKey,
      "totalPrice": totalPrice,
      "nUserUid": nUserUid,
      "nUserName": nUserName,
      "nUserEmail": nUserEmail,
      "nProfilePic": nProfilePic,
      "nAddress" : nAddress,
      "nLatitude" : nLatitude,
      "nLongitude" : nLongitude,
      "nContact" : nContact,
      "status" : "pending"
    };
    await orderInst.doc(orderKey).set(orderObj);
    deleteItem(index, nUserUid);
    errorMessage("Success", "your order is Successfully placed");
    update();
  }

  getOrder1(nUserUid,status) async {
    allOrders.clear();
    update();
    CollectionReference orderInst = FirebaseFirestore.instance.collection("Orders");
    await orderInst.where("nUserUid", isEqualTo: nUserUid)
        .where("status", isEqualTo: status)
        .get().then((QuerySnapshot data) {
        var ordersData = data.docs.map((doc) => doc.data()).toList();
        
        allOrders = ordersData;
        update();
      });
  }
  getOrder(String nUserUid) async {
    setLoading(true);
  // Clear previous data
  allOrders.clear();
  pendingOrders.clear();
  acceptedOrders.clear();
  shippedOrders.clear();
  deliveredOrders.clear();
  cancelledOrders.clear();

  update();

  CollectionReference orderInst = FirebaseFirestore.instance.collection("Orders");

  // Fetch orders based on user UID
  await orderInst.where("nUserUid", isEqualTo: nUserUid).get().then((QuerySnapshot data) {
    var ordersData = data.docs.map((doc) => doc.data()).toList();

    // Loop through each order and categorize it by its status
    for (var order in ordersData) {
      // Check if order is not null and status exists
      if (order != null && order is Map<String, dynamic> && order.containsKey('status')) {
        String? status = order['status'] as String?;

        // Switch based on status
        switch (status) {
          case "pending":
            pendingOrders.add(order);
            break;
          case "accepted":
            acceptedOrders.add(order);
            break;
          case "shipped":
            shippedOrders.add(order);
            break;
          case "delivered":
            deliveredOrders.add(order);
            break;
          case "cancelled":
            cancelledOrders.add(order);
            break;
          default:
            // Handle unknown or missing status
            allOrders.add(order);
        }
      } else {
        // Handle cases where order or status is null
        allOrders.add(order);  // Optionally add the order to a general list
      }
    }

    // Update with categorized orders
      allOrders = ordersData;  // If you want to keep all orders in one list as well
      setLoading(false);
      update();
    });
  
  }

  Future<void> makePayment(amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount.toString(), 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent

                  style: ThemeMode.dark,
                  merchantDisplayName: 'My'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      errorMessage("error",'==========================> errorrr: $err');
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
      
        // print(paymentIntent!["id"].toString());

       
        paymentIntent = null;
      }).onError((error, stackTrace) {
        errorMessage("error",'Error is:---> $error');

        throw Exception(error);
      });
    } on StripeException catch (e) {
      errorMessage("error",'Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      // print('$e');
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  createPaymentIntent(String amount, String currency) async {
    var secretKey = 'sk_test_51N6z0WCSqEAeQmco5oYdduocrsMEG55iW5qXyz9rB9X0MAFUM7mgZlKN0jeGemUJrIIYlAentHB2P9UDSUisLRrF00tMByKHA3';
    final uri = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final headers = {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'};

    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
    };

    try {
      final response = await http.post(uri, headers: headers, body: body);

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

}
