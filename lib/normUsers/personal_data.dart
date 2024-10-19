import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_ecom_app/Controllers/fire_controller.dart';
import 'package:my_ecom_app/Controllers/norm_user_controller.dart';
import 'package:my_ecom_app/Widgets/gender_choose.dart';
import 'package:my_ecom_app/Widgets/text_field_widget.dart';

class PersonalData extends StatefulWidget {
  final String imageUrl;
  final String userName;
  final String userUid;
  final String? address;
  final String? gender;
  final String? contact;
  final String? dob;
  final String userEmail;
  const PersonalData(
      {super.key,
      required this.imageUrl,
      required this.userName,
      required this.userUid,
      this.address = "",
      this.gender = "",
      this.contact = "",
      this.dob = "",
      required this.userEmail});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  var controller = Get.put(FireController());
  var normUserController = Get.put(NormUserController());
  @override
  void initState() {
    super.initState();
    _userName.text = widget.userName.isNotEmpty ? widget.userName : "";
    _address.text = widget.address ?? "";
    _dOB.text = widget.dob ?? "";
    _contact.text = widget.contact ?? "";
    _gender.text = widget.gender ?? "";
    if (widget.gender != null) {
      _selectedGender = widget.gender;
    }
  }

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _dOB = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _gender = TextEditingController();

  String? _selectedGender;

  // Profile Image
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(value);

      // Check if the date is not in the future
      if (parsedDate.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      // Check if the age is reasonable (e.g., not less than 0 or more than 120)
      int age = DateTime.now().year - parsedDate.year;
      if (age < 0 || age > 120) {
        return 'Please enter a valid age';
      }
    } catch (e) {
      return 'Please enter a valid date in the format dd/MM/yyyy';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FireController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8E1),
          appBar: AppBar(
            toolbarHeight: 40,
            backgroundColor: const Color.fromARGB(255, 255, 246, 217),
            foregroundColor: const Color.fromARGB(255, 111, 2, 43),
            leading: IconButton(
              onPressed: () {
                Get.back();
                normUserController.setLoading(false);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: const Text(
              "Personal Data",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _goodToGo,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          controller.pickedImageFile.value == null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: CachedNetworkImageProvider(
                                      widget.imageUrl),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(
                                      controller.pickedImageFile.value!)),
                          Positioned(
                              bottom: 1,
                              right: 1,
                              child: Container(
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: IconButton(
                                      onPressed: () {
                                        showBottomSheet();
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                      ))))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.name,
                        labelText: "User Name",
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
                        width: MediaQuery.of(context).size.width,
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
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.datetime,
                        width: MediaQuery.of(context).size.width,
                        labelText: "Date of birth",
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
                        validate: _validateDOB,
                        controller: _dOB,
                        hintText: "dd/MM/yyyy",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GenderChoose(
                        controller: _gender,
                        selectedGender: _selectedGender,
                        onChange: (value) {
                          setState(() {
                            _selectedGender = value;
                            _gender.text = value!;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
                        focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (!value!.startsWith("03", 0)) {
                            return "Invalid Number";
                          } else if (value.length < 11) {
                            return "Invalid Number Length";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
                        labelText: "Phone",
                        controller: _contact,
                        hintText: "03xxxxxxxxx",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color.fromARGB(255, 111, 2, 43),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Invalid Address";
                          } else {
                            return null;
                          }
                        },
                        labelColor: const Color.fromARGB(255, 111, 2, 43),
                        labelText: "Address",
                        controller: _address,
                        hintText: "address",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: const Color.fromARGB(255, 111, 2, 43),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color.fromARGB(255, 111, 2, 43),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      controller.isLoading
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 111, 2, 43),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const BeveledRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  backgroundColor:
                                      const Color.fromARGB(255, 111, 2, 43),
                                  shadowColor: Colors.black,
                                  elevation: 10),
                              onPressed: () async {
                                await controller.storeImage(_image);
                                if (_goodToGo.currentState!.validate()) {
                                  controller.imageLink.isEmpty
                                      ? controller.updateUserData(
                                          widget.imageUrl,
                                          _userName.text,
                                          widget.userUid,
                                          _address.text,
                                          _gender.text,
                                          _contact.text,
                                          _dOB.text,
                                          widget.userEmail)
                                      : controller.updateUserData(
                                          controller.imageLink,
                                          _userName.text,
                                          widget.userUid,
                                          _address.text,
                                          _gender.text,
                                          _contact.text,
                                          _dOB.text,
                                          widget.userEmail);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
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
