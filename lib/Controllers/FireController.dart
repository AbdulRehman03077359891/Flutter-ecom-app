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
import 'package:my_ecom_app/FireBaseScreen/SignIn.dart';
import 'package:my_ecom_app/Widgets/Message.dart';
import 'package:my_ecom_app/admin/adminScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireController extends GetxController {
  bool isLoading = false;
  final _uid = ''.obs;
  final _imageLink = ''.obs;
  final pickedImageFire = Rx<File?>(null);
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final usersList = [];

//Loading indicator ----------------------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }



  //FireBase SignUp email/password---------------------------------------
  registerUser(
      email, password, fileData, image, context, userName, userType) async {
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
        ErrorMessage("error", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        setLoading(false);
        ErrorMessage("error", "email already registered");
      }
    } catch (e) {
      setLoading(false);

      ErrorMessage("error", "Firebase ${e.toString()}");
    }
    return null;
  }

//Storing Profile Image -----------------------------------------------
  imageStoreStorage(image, context, userName, email, password, userType) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("user/${pickedImageFire.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFire.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink.value = downloadUrl;
      update();
      fireStoreDBase(context, userName, email, password, userType);
    } catch (e) {
      ErrorMessage("error", "ImageStorage ${e.toString()}");
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
    pickedImageFire.value = File(PickedFile!.path);

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
        "imageUrl": _imageLink.value,
        "uid": _uid.value,
        "userType": userType,
      };

      await dBaseRef.child(userType).child(_uid.value).update(userObj);
      setLoading(false);

      ErrorMessage('Success', 'User Registered Successfully');

      setLoading(false);

      // Going to new page vvv
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignInPage()));
      //-------------------^^^
    } catch (e) {
      ErrorMessage("error", "Database ${e.toString()}");
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
        "imageUrl": _imageLink.value,
        "uid": _uid.value,
        "userType": userType,
      };

      await dBaseRef.doc(_uid.value).set(userObj);

      ErrorMessage('Success', 'User Registered Successfully');

      setLoading(false);

      // Going to new page vvv
      Get.off(const SignInPage());
      //-------------------^^^
    } catch (e) {
      ErrorMessage("error", "Database ${e.toString()}");
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
  }

//User Data  when LoginUser-----------------------------------------------------------------

  Future<UserCredential?> logInUser(
      String email, String password, context) async {
    try {
      setLoading(true);
      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      fireBaseDataFetch(context, user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ErrorMessage('error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ErrorMessage(
            "error", "The email adress is already in use by another user.");
      }
    } catch (e) {
      ErrorMessage("error", e.toString());
    }
    return null;
  }

//FireBase DataBase DataFetch -------------------------------------------
  fireBaseDataFetch(context, user) async {
    await FirebaseFirestore.instance
        .collection("NormUsers")
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map;
        userData.value = Map<String, dynamic>.from(data);
        setLoading(false);
        update();
        setPreference(userData);

        Get.offAll(AdminScreen(
          userType: userData["userType"],
          userName: userData["name"],
          userEmail: userData["email"],
          profilePicture: userData["imageUrl"],
        ));
      } else {
        FirebaseFirestore.instance
            .collection("BusinessUsers")
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data() as Map;
            userData.value = Map<String, dynamic>.from(data);
            setLoading(false);
            update();
            setPreference(userData);

            Get.offAll(AdminScreen(
              userType: userData["userType"],
              userName: userData["name"],
              userEmail: userData["email"],
              profilePicture: userData["imageUrl"],
            ));
          } else {
            FirebaseFirestore.instance
                .collection("admin")
                .doc(user.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                var data = documentSnapshot.data() as Map;
                userData.value = Map<String, dynamic>.from(data);
                setLoading(false);
                update();
                setPreference(userData);

                Get.offAll(AdminScreen(
                  userType: userData["userType"],
                  userName: userData["name"],
                  userEmail: userData["email"],
                  profilePicture: userData["imageUrl"],
                ));
              } else {
                setLoading(false);
                ErrorMessage(
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
    await users.get().then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((doc) {
            // print('${doc.id} => ${doc.data()}');
            usersList.add(doc.data());
          })
        });
    update();
  }

  getAllNormUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection("NormUsers");
    await users.get().then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((doc) {
            // print('${doc.id} => ${doc.data()}');
            usersList.add(doc.data());
          })
        });
    update();
  }
}
