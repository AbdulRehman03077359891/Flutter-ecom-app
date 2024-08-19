import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Controllers/FireController.dart';
import 'package:my_ecom_app/FireBaseScreen/SignUp.dart';
import 'package:my_ecom_app/Widgets/TextFieldWidget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  //Password Settings-------------------------------------------------------------
  var _checkCapital = false;
  var _checkSmall = false;
  var _checkNumbers = false;
  var _checkSpecial = false;

  bool _hidePassword = true;
  var _passwordIcon = FontAwesomeIcons.eyeSlash;

  // is Form Filled---------------------------------------------------------------
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

  //User Data---------------------------------------------------------------------
  final _fireController = Get.put(FireController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FireController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 111, 2, 43),
          centerTitle: true,
          title: const Text(
            "SignIn",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.white,
            child: Form(
              key: _goodToGo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    suffixIconColor: const Color.fromARGB(255, 111, 2, 43),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 111, 2, 43),
                    ),
                    fillColor: const Color.fromARGB(31, 255, 255, 255),
                    focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                    errorBorderColor: Colors.red,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 111, 2, 43))),
                          onPressed: () {
                            if (_goodToGo.currentState!.validate()) {
                              _fireController.logInUser(
                                  _email.text, _password.text, context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              "SignIn",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                  TextButton(
                      onPressed: () {
                        Get.off(const SignUpPage());
                      },
                      child: const Text(
                        "Create Account",
                        style:
                            TextStyle(color: Color.fromARGB(255, 111, 2, 43)),
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
