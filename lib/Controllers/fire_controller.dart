// ignore_for_file: non_constant_identifier_names, file_names
// cupertino_icons: ^1.0.6
//   firebase_core: ^3.1.1
//   firebase_auth: ^5.1.1
//   firebase_storage: ^12.1.0
//   font_awesome_flutter: ^10.7.0
//   image_picker: ^1.1.2
//   cloud_firestore: ^5.0.2
//   firebase_database: ^11.0.2
//   get: ^4.6.6
//   shared_preferences: ^2.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/FireBaseScreen/sign_in.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/admin/admin_dashboard.dart';
import 'package:my_ecom_app/business/business_dashboard.dart';
import 'package:my_ecom_app/normUsers/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireController extends GetxController {
  bool isLoading = false;
  final _uid = ''.obs;
  final imageLink = ''.obs;
  final pickedImageFile = Rx<File?>(null);
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final usersListB = [];
  final usersListN = [];

//Loading indicator ----------------------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }



  //FireBase SignUp email/password---------------------------------------
  registerUser(
      email, password, image, context, userName, userType) async {
    try {
      setLoading(true);

      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      _uid.value = user!.uid;

      update();

      imageStoreStorage(image, context, userName, email, password, userType);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setLoading(false);
        errorMessage("error", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        setLoading(false);
        errorMessage("error", "email already registered");
      }
    } catch (e) {
      setLoading(false);

      errorMessage("error", "Firebase ${e.toString()}");
    }
    return null;
  }

//Storing Profile Image -----------------------------------------------
  imageStoreStorage(image, context, userName, email, password, userType) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("user/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      imageLink.value = downloadUrl;
      update();
      fireStoreDBase(context, userName, email, password, userType);
    } catch (e) {
      errorMessage("error", "ImageStorage ${e.toString()}");
    }
  }

// Picking Image --------------------------------------------------------
  pickImage(
    source,
    picker,
    context,
    image,
  ) async {
    final PickedFile = await picker.pickImage(source: source);

    Navigator.pop(context);
    pickedImageFile.value = File(PickedFile!.path);

    update();
  }

// Storing Data --RealTime DataBase --------------------------------------
  realTimeDbase(context, userName, email, password, userType) async {
    try {
      var dBaseInstance = FirebaseDatabase.instance;
      DatabaseReference dBaseRef = dBaseInstance.ref();

      var userObj = {
        "name": userName,
        "email": email,
        "password": password,
        "imageUrl": imageLink.value,
        "uid": _uid.value,
        "userType": userType,
        "contact": "contact",
        "address": "address",
        "gender": "gender",
        "dateOfBirth": "dob",
        
      };

      await dBaseRef.child(userType).child(_uid.value).update(userObj);
      setLoading(false);

      errorMessage('Success', 'User Registered Successfully');

      setLoading(false);

      // Going to new page vvv
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignInPage()));
      //-------------------^^^
    } catch (e) {
      errorMessage("error", "Database ${e.toString()}");
    }
  }

//Storing Data --Firestore Database -------------------------------------
  fireStoreDBase(context, userName, email, password, userType) async {
    try {
      var dBaseInstance = FirebaseFirestore.instance;
      CollectionReference dBaseRef = dBaseInstance.collection(userType);

      var userObj = {
        "name": userName,
        "email": email,
        "password": password,
        "imageUrl": imageLink.value,
        "uid": _uid.value,
        "userType": userType,
      };

      await dBaseRef.doc(_uid.value).set(userObj);

      errorMessage('Success', 'User Registered Successfully');

      setLoading(false);

      // Going to new page vvv
      Get.off(const SignInPage());
      //-------------------^^^
    } catch (e) {
      errorMessage("error", "Database ${e.toString()}");
    }
  }

//Auto LogIn preferences -------------------------------------------------
  setPreference(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Login", true);
    prefs.setString("userType", userData["userType"]);
    prefs.setString("email", userData["email"]);
    prefs.setString("imageUrl", userData["imageUrl"]);
    prefs.setString("name", userData["name"]);
    prefs.setString("uid", userData["uid"]);
    prefs.setString("address", userData["address"]);
  }
  
  logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(const SignInPage());
  }

//User Data  when LoginUser-----------------------------------------------------------------

  Future<UserCredential?> logInUser(
      String email, String password, context, go) async {
    try {
      setLoading(true);
      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      fireBaseDataFetch(context, user, go);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {  
      setLoading(false);
        errorMessage('error', 'The password provided is too weak.');
        update();
      } else if (e.code == 'email-already-in-use') {
        setLoading(false);
        errorMessage(
            "error", "The email adress is already in use by another user.");
            update();
      } else if (e.code == "invalid-credential") {
        setLoading(false);
        errorMessage("error", "invalid-credential: ${e.toString()}");
        update();
      }
    } catch (e) {
      setLoading(false);
      errorMessage("error", e.toString());
      update();
    }
    return null;
  }

//FireBase DataBase DataFetch -------------------------------------------
  fireBaseDataFetch(context, user, go) async {
    setLoading(true);
    await FirebaseFirestore.instance
        .collection("NormUsers")
        .doc(go=="go"?user:user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map;
        userData.value = Map<String, dynamic>.from(data);
        setLoading(false);
        update();
        setPreference(userData);
        go=="go"?
        {debugPrint(go),setLoading(false)}:
        Get.offAll(UserScreen(
          userUid: userData["uid"],
          userName: userData["name"],
          userEmail: userData["email"],
          profilePicture: userData["imageUrl"],
        )) ;
      } else {
        FirebaseFirestore.instance
            .collection("BusinessUsers")
            .doc(go=="go"?user:user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data() as Map;
            userData.value = Map<String, dynamic>.from(data);
            setLoading(false);
            update();
            setPreference(userData);

            go=="go"?
        {debugPrint(go),setLoading(false)}:
            Get.offAll(BusinessScreen(
              userUid: userData["uid"],
              userName: userData["name"],
              userEmail: userData["email"],
              profilePicture: userData["imageUrl"],
            ));
          } else {
            FirebaseFirestore.instance
                .collection("admin")
                .doc(go=="go"?user:user.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                var data = documentSnapshot.data() as Map;
                userData.value = Map<String, dynamic>.from(data);
                setLoading(false);
                update();
                setPreference(userData);

go=="go"?
        {debugPrint(go),setLoading(false)}:
                Get.offAll(AdminScreen(
                  userName: userData["name"],
                  userEmail: userData["email"],
                  profilePicture: userData["imageUrl"],
                ));
              } else {
                setLoading(false);
                errorMessage(
                    "error", "Docunment does not exist on the database");
              }
            });
          }
        });
      }
    });
  }

//RealTime DataBase DataFetch---------------------------------------------
  realTimeDataFetch(user) async {
    final ref = FirebaseDatabase.instance.ref();
    await ref.child('NormalUser').child(user.uid).once().then((event) async {
      event;

      if (event.snapshot.value == null) {
        final ref = FirebaseDatabase.instance.ref();
        await ref
            .child('BusinessUser')
            .child(user.uid)
            .once()
            .then((event) async {
          event;
          var data = event.snapshot.value as Map;

          userData.value = Map<String, dynamic>.from(data);
          update();
        });
      } else {
        var data = event.snapshot.value as Map;

        userData.value = Map<String, dynamic>.from(data);
        update();
      }
    });
  }

//Fetch AllBusinessUsers -------------------------------------------------
  getAllBusiUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection("BusinessUsers");
        usersListB.clear();
    await users.get().then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((doc) {
            // print('${doc.id} => ${doc.data()}');
            usersListB.add(doc.data());
          })
        });
    update();
  }

  getAllNormUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection("NormUsers");
        usersListN.clear();
    await users.get().then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((doc) {
            // print('${doc.id} => ${doc.data()}');
            usersListN.add(doc.data());
          })
        });
    update();
  }
  updateUserAddress(address, userUid, userName, userEmail) async {
    CollectionReference userInst = FirebaseFirestore.instance.collection("NormUsers");
    var doc = await userInst.doc(userUid).get();

    if(doc.exists){
      await userInst.doc(userUid).update({
        "address":address
      }).then((value) async {

        update();
        Get.offAll(UserScreen(userUid: userUid, userName: userName, userEmail: userEmail, ));
});
    }
  }
  updateUserData(imageUrl, userName, userUid , address , gender , contact , dob, userEmail) async {
    CollectionReference userInst = FirebaseFirestore.instance.collection("NormUsers");
    var doc = await userInst.doc(userUid).get();

    if (doc.exists) {
      await userInst.doc(userUid).update({
        "name": userName,
        "contact": contact,
        "address": address,
        "gender": gender,
        "dateOfBirth": dob,
        "imageUrl": imageUrl,
      }).then((_) async {

        pickedImageFile.value = null;
        setLoading(false);
        update();
        errorMessage("Success", "Personal Data updated successfully");
        Get.offAll(UserScreen(userUid: userUid, userName: userName, userEmail: userEmail, ));
      }).catchError((error) {
        setLoading(false);
        errorMessage("error", "Failed to update Personal Data: $error");
      });
    } else {
      setLoading(false);
      errorMessage("error", "Document not found");
    }
  }
  //Storing Profile Image -----------------------------------------------
  storeImage(image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("user/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      imageLink.value = downloadUrl;
      update();
    } catch (e) {
      // errorMessage("error", "ImageStorage ${e.toString()}");
    }
  }
}
