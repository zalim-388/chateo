import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Contacts extends StatefulWidget {
  final String name;
  final String number;
  const Contacts({super.key, required this.name, required this.number});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final CollectionReference contactsRef =
      FirebaseFirestore.instance.collection("contacts");
  @override
  void initState() {
    super.initState();
    _namecontroller.text = widget.name;
    _phoneController.text = widget.number;
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> Addcontact() async {
    String name = _namecontroller.text.trim();
    String number = _phoneController.text.trim();

    // return contactsRef
    //     .doc("Contacts")
    //     .set({"name": name, "number": number})
    //     .then((value) => print(" Add user"))
    //     .catchError((Error) => print(Error));
    return
    contactsRef
        .add({"name": name, "number": number})
        .then((value) => print("add user"))
        .catchError((Error) => print(Error));
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
                      onPressed: () => openFullScreenDialog(context,
                          _phoneController, _namecontroller, Addcontact),
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
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
      (contact['name'] != null && contact['name'].isNotEmpty)
          ? contact['name'][0].toUpperCase()
          : '?', // Default character if name is missing
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

                                save(context, namecontroller, phoneController);
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

void save(BuildContext context, TextEditingController _namecontroller,
    TextEditingController _phoneController) {
  Navigator.pop(context);
  _namecontroller.clear();
  _phoneController.clear();
}
