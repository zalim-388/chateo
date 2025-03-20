import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chats extends StatefulWidget {
  final String userid;
  final String chatroomid;
  const Chats({
    super.key,
    required this.userid,
    required this.chatroomid,  
  });

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _mesagecontroller = TextEditingController();
  Future<void> sendmessage(String? chatroomid) async {
    String message = _mesagecontroller.text.trim();

    if (message.isEmpty) return;

    if (chatroomid == null || chatroomid.isEmpty) {
      print("Error: chatroomid is empty or null");
      print("Chatroom ID: ${widget.chatroomid}");

      return;
    }

    await _firestore.collection("user").doc(chatroomid).collection("user").add({
      "text": message,
      "sender": widget.userid,
      "timestamp": FieldValue.serverTimestamp(),
    });
    _mesagecontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 25, color: Color(0xFF002DE3)),
                  ),
                  SizedBox(
                    width: 240.w,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.message,
                        color: Color(0xFF002DE3),
                      )),
                ],
              ),
            ),
          ),

//story/////////////////////

          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _mesagecontroller,
              decoration: InputDecoration(
                  hintText: "search",
                  hintStyle: TextStyle(fontSize: 17),
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),

          Expanded(
              child: StreamBuilder(
            stream: _firestore
                .collection("user")
                .doc(widget.chatroomid)
                .collection("user")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("available Alla...."),
                );
              }

              var message = snapshot.data!.docs;

              return ListView.builder(
                itemCount: message.length,
                itemBuilder: (context, index) {
                  var messageData =
                      message[index].data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () => openFullScreenDialog(
                        context,
                        _mesagecontroller,
                        () => sendmessage(widget.chatroomid),
                        _firestore,
                        widget.chatroomid,
                        widget.userid),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          (messageData['userid'] != null &&
                                  messageData['name'].isNotEmpty)
                              ? messageData['name'][0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(
                        messageData['name'] ?? 'no name',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}

Future openFullScreenDialog(
        BuildContext context,
        TextEditingController _mesagecontroller,
        Future<void> Function() sendmessage,
        FirebaseFirestore firestore,
        String chatroomid,
        String userid) =>
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("user")
                    .doc(chatroomid)
                    .collection("message")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No messages yet"));
                  }
                  var messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];

                      bool isme = message["sender"] == userid;

                      return Align(
                        alignment:
                            isme ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              color: isme ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            message["text"],
                            style: TextStyle(fontSize: 16),
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
                    Expanded(
                      child: TextField(
                        controller: _mesagecontroller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    IconButton(
                        onPressed: sendmessage,
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
