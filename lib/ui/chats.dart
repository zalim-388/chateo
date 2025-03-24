import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chats extends StatefulWidget {
  const Chats({
    super.key,
  });

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _mesagecontroller = TextEditingController();
  final CollectionReference contactsRef =
      FirebaseFirestore.instance.collection("user");

  @override
  void dispose() {
    _mesagecontroller.dispose();
    super.dispose();
  }

  // Future<String?> _getImageUrl(String number) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? imageUrl = prefs.getString('contact_image_$number');
  //   if (imageUrl == null) {
  //     DocumentSnapshot doc = await contactsRef.doc("contacts").get();
  //     if (doc.exists) {
  //       var contacts = (doc.data() as Map<String, dynamic>)['contacts'] ?? [];
  //       var contact = contacts.firstWhere(
  //         (c) => c['number'] == number,
  //         orElse: () => null,
  //       );
  //       if (contact != null && contact['imageUrl'] != null) {
  //         imageUrl = contact['imageUrl'];
  //         await prefs.setString('contact_image_$number', imageUrl!);
  //       }
  //     }
  //   }
  //   return imageUrl;
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  "Chats",
                  style: TextStyle(fontSize: 25, color: Color(0xFF002DE3)),
                ),
                SizedBox(width: 240.w),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message, color: Color(0xFF002DE3)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            decoration: InputDecoration(
              hintText: "search",
              hintStyle: const TextStyle(fontSize: 17),
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.grey.shade200,
              filled: true,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: contactsRef.doc("contacts").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("No contacts available"));
              }

              var contacts =
                  (snapshot.data!.data() as Map<String, dynamic>)['contacts'] ??
                      [];

              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  var contact = contacts[index];
                  String name = contact['name'] ?? 'No name';
                  String number = contact['number'] ?? 'No number';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: contact.data != null
                          ? NetworkImage(contact.data!)
                          : null,
                      child: contact.data == null
                          ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?')
                          : null,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      number,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      // Optionally navigate to a chat screen with messages subcollection
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(chatnumber: number, username: name)));
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}

  


Future openFullchatScreenDialog(
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
              )
            ],
          ),
        );
      },
    );




  // Future<void> sendmessage(String chatroomid) async {
  //   String message = _mesagecontroller.text.trim();
  //   if (message.isEmpty) return;
  //   if (chatroomid.isEmpty) {
  //     print("Error: chatroomid is empty or null");
  //     return;
  //   }
  //   await _firestore
  //       .collection("user") // Ensure correct collection
  //       .doc()
  //       .collection("messages")
  //       .add({
  //     "text": message,
  //     "sender": widget.otheruser.name, // Ensure proper sender identification
  //     "timestamp": FieldValue.serverTimestamp(),
  //   });
  //   _mesagecontroller.clear();
  // }