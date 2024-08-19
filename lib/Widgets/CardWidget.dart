
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final userName , userEmail ,profilePicture;
  const CardWidget({super.key,required this.userEmail,required this.userName,required this.profilePicture});

  @override
  Widget build(BuildContext context) {
    return Card(
      // shape: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
      shadowColor: Colors.white,
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/material_design_2.jpg"),fit: BoxFit.fill,)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userName),
                  Text(userEmail),
                  Text("Category")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: CircleAvatar(backgroundImage: NetworkImage(profilePicture),radius: 60,),
            )
            // Column(
            //   children: [
            //     Container(height: 150,child: Image.network(profilePicture),)
              // ],
            // )
          ],
        ),
      ),
    );
  }
}