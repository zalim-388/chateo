import 'dart:io';

import 'package:chateo/ui/bottomnavi.dart';
import 'package:chateo/ui/home.dart';
import 'package:chateo/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String number; // Current user
  final String receiverNumber; //Contact
  const ChatScreen(
      {super.key,
      required this.name,
      required this.number,
      required this.receiverNumber});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _messagecontroller = TextEditingController();
  // final CollectionReference contactsRef =
  //     FirebaseFirestore.instance.collection("user");

  @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _messagecontroller.text = '';
    super.initState();
  }

  Future<void> sendmessage(
    String number,
  ) async {
    String message = _messagecontroller.text.trim();
    if (message.isEmpty) {
      print("Error: message is empty or null");
      return;
    }
    try {
      await _firestore
          .collection("users") // or contactsRef
          .doc(widget.number)
          .collection("contacts")
          .doc(widget.receiverNumber)
          .collection("chat")
          .add({
        "text": message,
        "sender": widget.number,
        "receiver": widget.receiverNumber,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // await _firestore
      //     .collection("users")
      //     .doc(widget.receiverNumber)
      //     .collection("contacts")
      //     .doc(widget.number)
      //     .collection("chat")
      //     .add({
      //   "text": message,
      //   "sender": widget.number,
      //   "receiver": widget.receiverNumber,
      //   "timestamp": FieldValue.serverTimestamp(),
      // });

      _messagecontroller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to send message: $e")));
    }
  }

  File? imagefile;
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imagefile = File(pickedFile.path);
      });

      final filename = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/$filename.jpg");

      try {
        await storageRef.putFile(imagefile!);
        String downloadurl = await storageRef.getDownloadURL();

        await _firestore
            .collection("users")
            .doc(widget.number)
            .collection("contacts")
            .doc(widget.receiverNumber)
            .collection("chat")
            .add({
          "type": "image",
          "imageUrl": downloadurl,
          "sender": widget.number,
          "timestamp": FieldValue.serverTimestamp(),
        });

        await _firestore
            .collection("users")
            .doc(widget.receiverNumber)
            .collection("contacts")
            .doc(widget.number)
            .collection("chat")
            .add({
          "type": "image",
          "imageUrl": downloadurl,
          "sender": widget.receiverNumber,
          "timestamp": FieldValue.serverTimestamp()
        });
      } catch (e) {}
    }
  }

  void _showAttachmentDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Icon(Icons.image_outlined),
            ),
            SimpleDialogOption(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Icon(Icons.camera_alt_outlined),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002DE3),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Bottomnavi(
                            number: widget.number,
                          )));
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        title: Row(
          children: [
            CircleAvatar(
              child: Text(widget.name.isNotEmpty ? widget.name[0] : "?"),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              widget.name,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.videocam, color: Colors.white)),
              IconButton(
                  onPressed: () {
                    makingphonecall(widget.receiverNumber);
                  },
                  icon: Icon(Icons.call, color: Colors.white)),
              PopupMenuButton(
                iconColor: Colors.white,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: "Report",
                      child: Text('Report'),
                    ),
                    PopupMenuItem(
                      value: 'block',
                      child: Text('block'),
                    ),
                    PopupMenuItem(
                      value: 'clear chat',
                      child: Text('clear chat'),
                    ),
                  ];
                },
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection("users")
                .doc(widget.number)
                .collection("contacts")
                .doc(widget.receiverNumber)
                .collection("chat")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No messages yet"));
              }
              var messages = snapshot.data!.docs;

              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index].data() as Map<String, dynamic>;

                  bool isme = message["sender"] == widget.number;

                  return SingleChildScrollView(
                    child: Align(
                      alignment:
                          isme ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration: BoxDecoration(
                                color: isme
                                    ? Color.fromARGB(255, 56, 93, 241)
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: isme
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  message["text"] ?? "No message",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isme ? Colors.white : Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  message["timestamp"] != null
                                      ? DateFormat("hh:mm").format(
                                          (message["timestamp"] as Timestamp)
                                              .toDate())
                                      : "sending...",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                if (message["type"] == "image")
                                  Image.network(message["imageUrl"])
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Transform.rotate(
                    angle: 5.5,
                    child: IconButton(
                      onPressed: () {
                        _showAttachmentDialog();
                      },
                      icon: Icon(Icons.attach_file, color: Color(0xFF002DE3)),
                    )),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: TextField(
                    controller: _messagecontroller,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        hintText: "message",
                        hintStyle: TextStyle(fontSize: 17),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                  ),
                ),
                IconButton(
                    onPressed: () => sendmessage(
                          widget.number,
                        ),
                    icon: Icon(
                      Icons.send,
                      color: Color(0xFF002DE3),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
