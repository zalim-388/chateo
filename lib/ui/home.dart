import 'package:chateo/ui/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _searchcontroller = TextEditingController();

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchChattedUsers(
      List<dynamic> contacts) async {
    List<Map<String, dynamic>> chattedUsers = [];

    for (var contact in contacts) {
      var chatQuery = await _firestore
          .collection("user")
          .doc("contacts")
          .collection("chat") // Fixed to match ChatScreen
          .doc(contact['number'] as String? ?? '')
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (chatQuery.docs.isNotEmpty) {
        var lastMessage = chatQuery.docs.first.data();
        chattedUsers.add({
          "name": contact['name'] as String? ?? 'Unknown',
          "number": contact['number'] as String? ?? '',
          "lastmessage": lastMessage['text'] as String? ?? 'No message',
          "lastTimestamp": (lastMessage['timestamp'] as Timestamp?)?.toDate(),
        });
      }
    }

    chattedUsers.sort((a, b) => (b['lastTimestamp'] ?? DateTime(0))
        .compareTo(a['lastTimestamp'] ?? DateTime(0)));

    return chattedUsers;
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
                    icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF002DE3)),
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
              stream: _firestore.collection('user').doc("contacts").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Fixed logic
                  return const Center(child: Text("No chats available"));
                }

                var contactsData =
                    snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> contacts = contactsData['contacts'] ?? [];

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchChattedUsers(contacts),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (chatSnapshot.hasError) {
                      return Center(
                          child: Text("Error: ${chatSnapshot.error}"));
                    }
                    if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
                      return const Center(child: Text("No chats available"));
                    }

                    var chattedUsers = chatSnapshot.data!;
                    if (_searchcontroller.text.isNotEmpty) {
                      chattedUsers = chattedUsers.where((user) {
                        return (user['name'] ?? '')
                            .toLowerCase()
                            .contains(_searchcontroller.text.toLowerCase());
                      }).toList();
                    }

                    return ListView.builder(
                      itemCount: chattedUsers.length,
                      itemBuilder: (context, index) {
                        var user = chattedUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              user['name'].isNotEmpty ? user['name'][0] : '?',
                            ),
                          ),
                          title: Text(
                            user['name'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  user['lastmessage'],
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                user['lastTimestamp'] != null
                                    ? DateFormat('hh:mm')
                                        .format(user['lastTimestamp'])
                                    : '',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  name: user['name'],
                                  number: user['number'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:chateo/ui/chat_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// class Home extends StatefulWidget {
//   final String name;
//   final String number;
//   const Home({
//     super.key,
//     required this.name,
//     required this.number,
//   });

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   TextEditingController _searchcontroller = TextEditingController();

//   @override
//   void dispose() {
//     _searchcontroller.dispose();
//     super.dispose();
//   }

//   Future<List<Map<String, dynamic>>> _fetchChattedUsers(
//       List<dynamic> contacts) async {
//     List<Map<String, dynamic>> chattedUsers = [];

//     for (var contact in contacts) {
//       var chatQuery = await _firestore
//           .collection("user")
//           .doc("contacts")
//           .collection("chat")
//           .doc(widget.number)
//           .collection("messages")
//           .orderBy("timestamp", descending: true)
//           .limit(1)
//           .get();

//       if (chatQuery.docs.isNotEmpty) {
//         var lastMessage = chatQuery.docs.first.data();
//         chattedUsers.add({
//           "name": contact['name'] as String? ?? 'Unknown',
//           "number": contact['number'] as String? ?? '',
//           "lastmessage": lastMessage['text'] as String? ?? 'No message',
//           "lastTimestamp": (lastMessage['timestamp'] as Timestamp?)?.toDate(),
//         });
//       }
//     }

//     chattedUsers.sort((a, b) => (b['lastTimestamp'] ?? DateTime(0))
//         .compareTo(a['lastTimestamp'] ?? DateTime(0)));

//     return chattedUsers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 40),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 const Text(
//                   "Chateo",
//                   style: TextStyle(fontSize: 25, color: Color(0xFF002DE3)),
//                 ),
//                 SizedBox(width: 230.w),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.search, color: Color(0xFF002DE3)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 20.h),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: TextField(
//             controller: _searchcontroller,
//             decoration: InputDecoration(
//               hintText: "search",
//               hintStyle: const TextStyle(fontSize: 17),
//               prefixIcon: const Icon(Icons.search),
//               fillColor: Colors.grey.shade200,
//               filled: true,
//               border: const OutlineInputBorder(borderSide: BorderSide.none),
//               focusedBorder:
//                   const OutlineInputBorder(borderSide: BorderSide.none),
//             ),
//             onChanged: (value) {
//               setState(() {});
//             },
//           ),
//         ),
//         SizedBox(height: 20.h),
//         Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream:
//                     _firestore.collection('user').doc("contacts").snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text("Error: ${snapshot.error}"));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.exists) {
//                     return Center(
//                       child: Text("No chat available"),
//                     );
//                   }
//                   var contactsData =
//                       snapshot.data!.data() as Map<String, dynamic>;
//                   List<dynamic> contacts = contactsData['contacts'] ?? [];

//                   return FutureBuilder<List<Map<String, dynamic>>>(
//                       future: _fetchChattedUsers(
//                         contacts,
//                       ),
//                       builder: (context, chatSnapshot) {
//                         if (chatSnapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         }

//                         if (chatSnapshot.hasError) {
//                           return Center(
//                               child: Text("Error: ${chatSnapshot.error}"));
//                         }
//                         if (!chatSnapshot.hasData ||
//                             chatSnapshot.data!.isEmpty) {
//                           return Center(child: Text("No chats available"));
//                         }

//                         var chattedUsers = chatSnapshot.data!;

//                         if (_searchcontroller.text.isNotEmpty) {
//                           chattedUsers = chattedUsers.where((user) {
//                             return user['name'] ??
//                                 ''.toLowerCase().contains(
//                                     _searchcontroller.text.toLowerCase());
//                           }).toList();
//                         }
//                         return ListView.builder(
//                           itemCount: chattedUsers.length,
//                           itemBuilder: (context, index) {
//                             var user = chattedUsers[index];
//                             return ListTile(
//                               leading: CircleAvatar(
//                                 child: Text(
//                                   user['name'].isNotEmpty
//                                       ? user['name'][0]
//                                       : '?',
//                                 ),
//                               ),
//                               title: Text(
//                                 user['name'],
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               subtitle: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       user['lastmessage'],
//                                       style: TextStyle(fontSize: 14),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   Text(
//                                     user['lastTimestamp'] != null
//                                         ? DateFormat('hh:mm')
//                                             .format(user['lastTimestamp'])
//                                         : '',
//                                     style: TextStyle(fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ChatScreen(
//                                       name: user['name'] ?? '',
//                                       number: user['number'] ?? '',
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       });
//                 }))
//       ],
//     ));
//   }
// }
