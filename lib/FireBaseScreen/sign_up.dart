import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';
import 'package:my_ecom_app/FireBaseScreen/sign_in.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';
import 'package:my_ecom_app/Widgets/text_field_widget.dart';

class SignUpPage extends StatefulWidget {
  final String userType;
  const SignUpPage({super.key, required this.userType});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _checkBoxVal = false;
  bool _buttonStatus = false;

  //Profile Image
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
                        backgroundColor: Color.fromARGB(255, 111, 2, 43),
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
  Widget build(BuildContext context) {
    return GetBuilder<FireController>(
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _goodToGo,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Create your new account.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 111, 2, 43),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "create an account to start looking for food you like.",
                                style: TextStyle(color: Colors.black54),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                child: controller.pickedImageFile.value == null
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            "assets/images/profilePlaceHolder.jpg"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(
                                            controller.pickedImageFile.value!)),
                              ),
                              Positioned(bottom: 1,right: 1,child: CircleAvatar(
                                radius: 18,
                                child: IconButton(onPressed: (){
                                                              showBottomSheet();}, icon: const Icon(Icons.add_a_photo,color: Color.fromARGB(255, 111, 2, 43),size: 20,)),
                              ))
                            ],
                          ),
                          TextFieldWidget(
                            labelText: "User Name",
                            labelColor: const Color.fromARGB(255, 111, 2, 43),
                            width: MediaQuery.of(context).size.width * .65,
                            validate: (value) {
                              if (!value!.startsWith(RegExp(r'[A-Z][a-z]'))) {
                                return "Start with Capital letter";
                              } else if (value.isEmpty) {
                                return "username required";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.name,
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
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        labelText: "Email Address",
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
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
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter your email",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 111, 2, 43),
                        ),
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
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
                        
                        keyboardType: TextInputType.visiblePassword,
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
                        labelText: "Password",
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
                      Row(
                        children: [
                          Checkbox(activeColor: const Color.fromARGB(255, 111, 2, 43),value: _checkBoxVal, onChanged: (bool? value){
                            setState(() {
                              _checkBoxVal = value!;
                              _buttonStatus = !_buttonStatus;
                            });
                          }),
                          Flexible(
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: "I Agree with ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "Terms and Service ",
                                  recognizer: TapGestureRecognizer()..onTap = (){},
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 111, 2, 43),
                                  )),
                              const TextSpan(
                                  text: "and ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "Privacy Policy",
                                  recognizer: TapGestureRecognizer()..onTap = (){},
                                  style: const TextStyle(color: Color.fromARGB(255, 111, 2, 43),overflow: TextOverflow.visible,))
                            ])),
                          ),
                        ],
                      ),
                      controller.isLoading
                          ? const CircularProgressIndicator(color: Color.fromARGB(255, 111, 2, 43),)
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const BeveledRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  backgroundColor: const Color.fromARGB(255, 111, 2, 43),
                                  shadowColor: Colors.black,
                                  elevation: 10),
                              onPressed: _buttonStatus? () {
                                if (_goodToGo.currentState!.validate()) {
                                  if (controller.pickedImageFile.value !=
                                      null) {
                                    _fireController.registerUser(
                                        _email.text,
                                        _password.text,
                                        _image,
                                        context,
                                        _userName.text,
                                        widget.userType);
                                  } else {
                                    errorMessage(
                                        'error', 'Profile Image Required');
                                  }
                                }
                              }:null,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )),
                      const SizedBox(height: 10,),
                      const Row(
                        children: [
                          Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              " Or signin with ",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 1,
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/google.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/facebook.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/images/apple.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                              text: "Sign In",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 111, 2, 43),
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Get.off(const SignInPage());
                              })
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
