import 'package:chateo/ui/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  final String name;
  final String number;
  const Home({
    super.key,
    required this.name,
    required this.number,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchcontroller = TextEditingController();
  final CollectionReference contactsRef =
      FirebaseFirestore.instance.collection("user");

  @override
  void dispose() async {
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
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
                  "Chateo",
                  style: TextStyle(fontSize: 25, color: Color(0xFF002DE3)),
                ),
                SizedBox(width: 230.w),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Color(0xFF002DE3)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: _searchcontroller,
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
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
            child: StreamBuilder<DocumentSnapshot>(
                stream: contactsRef.doc("contacts").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData || snapshot.data!.exists) {
                    return Center(
                      child: Text("No chat available"),
                    );
                  }
                  var contactsData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List<dynamic> contacts = contactsData['contacts'] ?? [];

                  return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchChattedUsers(
                          contacts, FirebaseFirestore.instance, widget),
                      builder: (context, chatsnapshot) {
                        if (chatsnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (chatsnapshot.hasData ||
                            chatsnapshot.data!.isEmpty) {
                          return Center(
                            child: Text("No chat available"),
                          );
                        }
                        var chattedusers = chatsnapshot.data;

                        if (_searchcontroller.text.isNotEmpty) {
                          chattedusers = chattedusers?.where((user) {
                            return user['name']
                                .toString()
                                .contains(_searchcontroller.text.toLowerCase());
                          }).toList();
                        }

                        return ListView.builder(
                          itemCount: chattedusers?.length,
                          itemBuilder: (context, index) {
                            var user = chattedusers![index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(user['name']?.isNotEmpty == true
                                    ? user['name'][0]
                                    : '?'),
                              ),
                              title: Text(
                                user['name'] ?? 'No Name',
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      user['lastmessage'] ?? 'no message',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    user['lastimestamp' ?? 'no time'],
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      name: user['name'] ?? '',
                                      number: user['number'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      });
                }))
      ],
    ));
  }
}

Future<List<Map<String, dynamic>>> _fetchChattedUsers(
  List<dynamic> contacts,
  FirebaseFirestore _firestore,
  dynamic widget,
) async {
  List<Map<String, dynamic>> chattedusers = [];
  for (var contact in contacts) {
    var chatqurey = await _firestore
        .collection("user")
        .doc("contacts")
        .collection("chat")
        .doc(widget.number)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (chatqurey.docs.isNotEmpty) {
      var lastmessage = chatqurey.docs.first.data();
      chattedusers.add({
        "name": contact['name'],
        "number": contact['number'],
        "lastmessage": lastmessage['text'],
        "lastimestamp": lastmessage['timestamp']
      });
    }
chattedusers.sort((a, b) {
      if (a['lastTimestamp'] == null || b['lastTimestamp'] == null) return 0;
      return b['lastTimestamp'].compareTo(a['lastTimestamp']);
    });
  }
  return chattedusers;
}
