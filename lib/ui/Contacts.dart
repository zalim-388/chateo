import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Contacts extends StatefulWidget {
  final String name;
  final String number;
  final String email;

  const Contacts(
      {super.key,
      required this.name,
      required this.number,
      required this.email});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();

  final CollectionReference contactsRef =
      FirebaseFirestore.instance.collection("contact");
  @override
  void initState() {
    super.initState();
    _namecontroller.text = widget.name;
    _phoneController.text = widget.number;
    _emailcontroller.text = widget.email;
    fetchContacts();
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _phoneController.dispose();
    _emailcontroller.dispose();

    super.dispose();
  }

  Future<void> Addcontact() async {
    String name = _namecontroller.text.trim();
    String number = _phoneController.text.trim();
    String email = _emailcontroller.text.trim();

    return contactsRef
        .doc("contacts")
        .update({
          "contacts": FieldValue.arrayUnion([
            {"name": name, "number": number, "email": email}
          ])
        })
        .then((value) => print(" Add user"))
        .catchError((Error) => print(Error));

    // return contactsRef

    //     .add({"name": name, "number": number})
    //     .then((value) => print("add user"))
    //     .catchError((Error) => print(Error));
  }

  Future<void> deletecontacts(
      dynamic name, dynamic number, dynamic email) async {
    return contactsRef
        .doc("contacts")
        .update({
          "contacts": FieldValue.arrayRemove([
            {"name": name, "number": number, "email": email}
          ])
        })
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

List<Map<String, dynamic>> contactList = []; // Store contacts in a list

Future<void> fetchContacts() async {
  DocumentSnapshot documentSnapshot =
      await contactsRef.doc("contacts").get();

  if (documentSnapshot.exists) {
    var data = documentSnapshot.data() as Map<String, dynamic>;
    setState(() {
      contactList = List<Map<String, dynamic>>.from(data["contacts"] ?? []);
    });
  } else {
    print("Document does not exist");
  }
}


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
                  Text(
                    "Contacts",
                    style: TextStyle(fontSize: 25, color: Color(0xFF002DE3)),
                  ),
                  SizedBox(
                    width: 220.w,
                  ),
                  IconButton(
                      onPressed: () => openFullScreenDialog(
                          context,
                          _phoneController,
                          _namecontroller,
                          _emailcontroller,
                          Addcontact),
                      icon: Icon(
                        Icons.add,
                        color: Color(0xFF002DE3),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
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
              child: StreamBuilder<QuerySnapshot>(
                  stream: contactsRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No contacts available"));
                    }

                    var contacts = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        var contact = contacts[index];
                        return GestureDetector(
                          onLongPress: () => deletecontacts(contact['name'],
                              contact['number'], contact['email']),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                (contact['name'] != null &&
                                        contact['name'].isNotEmpty)
                                    ? contact['name'][0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(
                              contact['name'] ?? 'no name',
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                              contact['number'] ?? 'no number',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        );
                      },
                    );
                  })),
        ],
      ),
    );
  }
}

Future openFullScreenDialog(
        BuildContext context,
        TextEditingController phoneController,
        TextEditingController namecontroller,
        TextEditingController emailController,
        Future<void> Function() Addcontact) =>
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: namecontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            size: 25,
                            color: Color(0xFF002DE3),
                          ),
                          hintText: "Name",
                          hintStyle: TextStyle(fontSize: 17),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.call,
                            color: Color(0xFF002DE3),
                            size: 25,
                          ),
                          hintText: "Phone",
                          hintStyle: TextStyle(fontSize: 17),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            size: 25,
                            color: Color(0xFF002DE3),
                          ),
                          hintText: "email",
                          hintStyle: TextStyle(fontSize: 17),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF002DE3),
                                ),
                              )),
                          Spacer(),
                          TextButton(
                              onPressed: () async {
                                await Addcontact();
                                FocusScope.of(context).unfocus();

                                String name = namecontroller.text.trim();
                                print("name:${namecontroller.text}");
                                String number = phoneController.text.trim();
                                print("number:${phoneController.text}");
                                String email = emailController.text.trim();
                                print("number:${emailController.text}");
                                save(context, namecontroller, phoneController,
                                    emailController);
                              },
                              child: Text(
                                "save",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF002DE3),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

void save(
    BuildContext context,
    TextEditingController _namecontroller,
    TextEditingController _phoneController,
    TextEditingController _emailcontroller) {
  Navigator.pop(context);
  _namecontroller.clear();
  _phoneController.clear();
  _emailcontroller.clear();
}
