
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});


  @override

  _ChatScreenState createState() => _ChatScreenState();

}

class ChatScreenState {
}

class _ChatScreenState extends State<ChatScreen> {

  Stream<QuerySnapshot> messagesStreem = FirebaseFirestore.instance

      .collection('chat_messages')

      .snapshots();

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(

        stream: messagesStreem,

        builder: (context, snapshot) {

          if (snapshot.hasError) {

            return Text('Error: ${snapshot.error}');

          }

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const CircularProgressIndicator();

          }

          return ListView.builder(

            itemCount: snapshot.data!.docs.length,

            itemBuilder: (context, index) {
              
              Map<String, dynamic> messageData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              String messageText = messageData['content'];

              return Text(messageText);

            },
          );
          
        },
      ),
    );
  }
}