import 'package:chateo/ui/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String number;
  const ChatScreen({super.key, required this.name, required this.number});

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
    super.initState();
    _messagecontroller = TextEditingController();
  }

  Future<void> sendmessage(String number, String name) async {
    String message = _messagecontroller.text.trim();
    if (message.isEmpty) {
      print("Error: message is empty or null");
      return;
    }
    try {
      await _firestore
          .collection("user") // or contactsRef
          .doc("contacts")
          .collection("chat")
          .doc(widget.number)
          .collection("messages")
          .add({
        "text": message,
        "sender": widget.number,
        "timestamp": FieldValue.serverTimestamp(),
      });
      _messagecontroller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to send message: $e")));
    }
  }

  void _makingphonecall() async {
    var _url = Uri.parse("tel:${widget.name}");
    if (await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $_url");
    }
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
                      builder: (context) => Home(
                            name: widget.name,
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
                    _makingphonecall();
                  },
                  icon: Icon(Icons.call, color: Colors.white)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert, color: Colors.white)),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection("user")
                .doc('contacts')
                .collection("chat")
                .doc(widget.number)
                .collection("messages")
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

                  return Align(
                    alignment:
                        isme ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          color: isme
                              ? Color.fromARGB(255, 56, 93, 241)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: isme
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
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
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )
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
                      onPressed: () {},
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
                    onPressed: () => sendmessage(widget.number, widget.name),
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
