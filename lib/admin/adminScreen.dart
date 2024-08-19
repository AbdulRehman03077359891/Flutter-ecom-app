import 'package:flutter/material.dart';
import 'package:my_ecom_app/Widgets/DrawerWidget.dart';

class AdminScreen extends StatefulWidget {
  final userType, userName, userEmail, profilePicture;
  const AdminScreen(
      {super.key,
      required this.userType,
      this.userName,
      this.userEmail,
      this.profilePicture});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("AdminDashBoard"),
        backgroundColor: const Color.fromARGB(255, 111, 2, 43),
        foregroundColor: Colors.white,
      ),
      body: Container(),
      endDrawer: DrawerWidget(
          accountName: widget.userName,
          accountEmail: widget.userEmail,
          profilePicture: widget.profilePicture),
    );
  }
}
