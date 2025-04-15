import 'dart:io';

import 'package:chateo/ui/bottomnavi.dart';
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
  //     FirebaseFirestore.instance.collection("users");

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

  File? imageFile;

  Future<void> _pickAndSendImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      String? imageUrl = await _uploadImage(imageFile!);

      if (imageUrl != null) {
        print("Image uploaded: $imageUrl");
        await _sendImageMessage(imageUrl);
      }
    } else {
      print("No image picked");
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child("chat_images/$fileName.jpg");

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _sendImageMessage(String imageUrl) async {
    try {
      Map<String, dynamic> imageMessage = {
        "type": "image",
        "imageUrl": imageUrl,
        "sender": widget.number,
        "timestamp": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection("users")
          .doc(widget.number)
          .collection("contacts")
          .doc(widget.receiverNumber)
          .collection("chat")
          .add(imageMessage);

      await _firestore
          .collection("users")
          .doc(widget.receiverNumber)
          .collection("contacts")
          .doc(widget.number)
          .collection("chat")
          .add(imageMessage);
    } catch (e) {
      print("Error sending image message: $e");
    }
  }

  void _showAttachmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickAndSendImage(ImageSource.gallery);
              },
              child: Row(
                children: [
                  Icon(Icons.image_outlined),
                  SizedBox(width: 10),
                  Text('Gallery'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickAndSendImage(ImageSource.camera);
              },
              child: Row(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(width: 10),
                  Text('Camera'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearchat() async {
    try {
      var chatDocs = await _firestore
          .collection("users")
          .doc(widget.number)
          .collection("contacts")
          .doc(widget.receiverNumber)
          .collection("chat")
          .get();

      for (var doc in chatDocs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Failed to clear chat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                onSelected: (value) {
                  if (value == "Report") {
                    print("User reported");
                  }
                  if (value == "block") {
                    print("User blocked");
                  }
                  if (value == "clear chat") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:
                              Text("Are you sure you want to clear the chat?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                clearchat();
                                print("Chat cleared");

                                Navigator.pop(context);
                              },
                              child: Text("Confirm"),
                            ),
                          ],
                        );
                      },
                    );
                    print("Chat cleared");
                  }
                },
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
              final messages = snapshot.data!.docs;

              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message =
                      messages[index].data() as Map<String, dynamic>;
                  final isme = message["sender"] == widget.number;
                  final isimage = message["type"] == "image";

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
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                isimage
                                    ? Image.network(
                                        message["imageUrl"],
                                        width: 200,
                                      )
                                    : Text(
                                        message["text"] ?? "No message",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isme
                                              ? Colors.white
                                              : Colors.black87,
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
                                  Image.network(message["imageurl"]),
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
          if (imageFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Stack(children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          imageFile = null;
                        });
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ))
              ]),
            ),
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
                imageFile != null
                    ? IconButton(
                        onPressed: () {
                          if (imageFile != null) {
                            _sendImageMessage(imageFile!.path);
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.green),
                      )
                    : IconButton(
                        onPressed: () => sendmessage(widget.number),
                        icon: Icon(Icons.send, color: Color(0xFF002DE3)),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
