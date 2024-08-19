import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_ecom_app/Controllers/FireController.dart';
import 'package:my_ecom_app/FireBaseScreen/SignIn.dart';
import 'package:my_ecom_app/Widgets/Message.dart';
import 'package:my_ecom_app/Widgets/TextFieldWidget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  //Profile Image
  File? _image;
  var _fileData;
  final ImagePicker _picker = ImagePicker();
  var _userType = '';

  //Password Settings
  var _checkCapital = false;
  var _checkSmall = false;
  var _checkNumbers = false;
  var _checkSpecial = false;

  bool _hidePassword = true;
  var _passwordIcon = FontAwesomeIcons.eyeSlash;

  // is Form Filled
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

  //FireController
  final _fireController = Get.put(FireController());

  // showing bottom sheet when tapped on profile pic
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
                      onPressed: () {
                        _fireController.pickImage(
                          ImageSource.camera,
                          _picker,
                          context,
                          _image,
                        );
                        //pickImage(ImageSource.camera);
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () {
                      _fireController.pickImage(
                        ImageSource.gallery,
                        _picker,
                        context,
                        _image,
                      );
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
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
  Widget build(BuildContext context) {
    return GetBuilder<FireController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 111, 2, 43),
            centerTitle: true,
            title: const Text(
              "SignUp",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          body: Form(
            key: _goodToGo,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      showBottomSheet();
                    },
                    child: controller.pickedImageFire.value == null
                        ? const CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(
                                "assets/images/profilePlaceHolder.jpg"),
                          )
                        : CircleAvatar(
                            radius: 100,
                            backgroundImage:
                                FileImage(controller.pickedImageFire.value!)),
                  ),
                  TextFieldWidget(
                    validate: (value) {
                      if (!value!.startsWith(RegExp(r'[A-Z][a-z]'))) {
                        return "Start with Capital letter";
                      } else if (value.isEmpty) {
                        return "username required";
                      } else {
                        return null;
                      }
                    },
                    controller: _userName,
                    hintText: "Enter your username",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 111, 2, 43),
                    ),
                    fillColor: const Color.fromARGB(31, 255, 255, 255),
                    focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                    errorBorderColor: Colors.red,
                  ),
                  TextFieldWidget(
                    validate: (value) {
                      if (!value!.endsWith("@gmail.com")) {
                        return "Invalid email";
                      } else if (value.isEmpty) {
                        return "email required";
                      } else {
                        return null;
                      }
                    },
                    controller: _email,
                    hintText: "Enter your email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 111, 2, 43),
                    ),
                    fillColor: const Color.fromARGB(31, 255, 255, 255),
                    focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                    errorBorderColor: Colors.red,
                  ),
                  TextFieldWidget(
                    validate: (value) {
                      for (var i = 0; i < value!.length; i++) {
                        debugPrint(value[i]);
                        if (value.codeUnitAt(i) >= 65 &&
                            value.codeUnitAt(i) <= 90) {
                          _checkCapital = true;
                        }
                        if (value.codeUnitAt(i) >= 97 &&
                            value.codeUnitAt(i) <= 122) {
                          _checkSmall = true;
                        }
                        if (value.codeUnitAt(i) >= 48 &&
                            value.codeUnitAt(i) <= 57) {
                          _checkNumbers = true;
                        }
                        if (value.codeUnitAt(i) >= 33 &&
                                value.codeUnitAt(i) <= 47 ||
                            value.codeUnitAt(i) >= 58 &&
                                value.codeUnitAt(i) <= 64) {
                          _checkSpecial = true;
                        }
                      }
                      if (value.isEmpty) {
                        return "Password Required";
                      } //else if(passwordRules.hasMatch(value)){
                      // return "Invalid password" ;}
                      else if (!_checkCapital) {
                        return "Capital Letter Required";
                      } else if (!_checkSmall) {
                        return "Small Letter Required";
                      } else if (!_checkNumbers) {
                        return "Number Required";
                      } else if (!_checkSpecial) {
                        return "Special Character Required";
                      } else if (value.length < 8) {
                        return "Atleast 8 characters Required";
                      } else {
                        return null;
                      }
                    },
                    hidePassword: _hidePassword,
                    controller: _password,
                    hintText: "Enter your password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _hidePassword = !_hidePassword;
                        if (_passwordIcon == FontAwesomeIcons.eyeSlash) {
                          _passwordIcon = FontAwesomeIcons.eye;
                        } else {
                          _passwordIcon = FontAwesomeIcons.eyeSlash;
                        }
                        setState(() {});
                      },
                      child: Icon(_passwordIcon),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 111, 2, 43),
                    ),
                    fillColor: const Color.fromARGB(31, 255, 255, 255),
                    focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                    errorBorderColor: Colors.red,
                    suffixIconColor: const Color.fromARGB(255, 111, 2, 43),
                  ),
                  controller.isLoading
                      ? const CircularProgressIndicator()
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromARGB(255, 111, 2, 43))),
                                  onPressed: () {
                                    if (_goodToGo.currentState!.validate()) {
                                      if (controller.pickedImageFire.value !=
                                          null) {
                                        setState(() {
                                          _userType = 'NormUsers';
                                        });
                                        _fireController.registerUser(
                                            _email.text,
                                            _password.text,
                                            _fileData,
                                            _image,
                                            context,
                                            _userName.text,
                                            _userType);
                                      } else {
                                        ErrorMessage(
                                            'error', 'Profile Image Required');
                                      }
                                    }
                                  },
                                  child: const Text(
                                    ' NormalSignUp ',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromARGB(255, 111, 2, 43))),
                                  onPressed: () {
                                    if (_goodToGo.currentState!.validate()) {
                                      if (controller.pickedImageFire.value !=
                                          null) {
                                        setState(() {
                                          _userType = 'BusinessUsers';
                                        });
                                        _fireController.registerUser(
                                            _email.text,
                                            _password.text,
                                            _fileData,
                                            _image,
                                            context,
                                            _userName.text,
                                            _userType);
                                      } else {
                                        ErrorMessage(
                                            "error", "Profile image Required");
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'BusinessSignUp',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              // ElevatedButton(
                              //     onPressed: () {
                              //       if (_goodToGo.currentState!.validate()) {
                              //         if (controller.pickedImageFire.value !=
                              //             null) {
                              //           setState(() {
                              //             _userType = 'admin';
                              //           });
                              //           _fireController.registerUser(
                              //               _email.text,
                              //               _password.text,
                              //               _fileData,
                              //               _image,
                              //               context,
                              //               _userName.text,
                              //               _userType);
                              //         } else {
                              //           _fireController.ErrorMessage(
                              //               'error', 'Profile Image Required');
                              //         }
                              //       }
                              //     },
                              //     child: const Text(' adminSignUp ')),
                            ],
                          ),
                        ),
                  TextButton(
                      onPressed: () {
                        Get.off(const SignInPage());
                      },
                      child: const Text(
                        "SignIn",
                        style:
                            TextStyle(color: Color.fromARGB(255, 111, 2, 43)),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
