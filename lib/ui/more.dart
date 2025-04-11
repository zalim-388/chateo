import 'dart:io';

import 'package:chateo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class More extends StatefulWidget {
  final String phonenumber;

  const More({
    super.key,
    required this.phonenumber,
  });

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  String? profile_name;
  File? profile_image;
  String phonenumber = "";

  @override
  void initState() {
    super.initState();
    phonenumber = widget.phonenumber;
    loadprofiledata();
  }

  void loadprofiledata() async {
    final prefs = await SharedPreferences.getInstance();

    final imagepath = prefs.getString("profile_image");
    profile_name = prefs.getString("profile_name");
    phonenumber = prefs.getString("phonenumber") ?? "";
    setState(() {
        profile_name = profile_name ?? "Your Name";
    phonenumber = phonenumber ?? widget.phonenumber;
      if (imagepath != null) {
        profile_image = File(imagepath);
      }

      //     await prefs.setBool("darkmode", darkNotifier.value);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profile_image = File(pickedFile.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image", pickedFile.path);
    }
  }

  @override
  void dispose() {
    darkNotifier.dispose();
    super.dispose();
  }

  Future<void> _showdialogtheme(bool isdark) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          RadioListTile<bool>(
            title: Text("Dark"),
            value: true,
            groupValue: isdark,
            onChanged: (value) {
              darkNotifier.value = value!;
              Navigator.pop(context);
            },
          ),
          RadioListTile<bool>(
            title: Text("Light"),
            value: false,
            groupValue: isdark,
            onChanged: (value) {
              darkNotifier.value = value!;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isdark = darkNotifier.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profile_image != null
                          ? FileImage(profile_image!)
                          : null,
                      child: profile_image == null
                          ? Icon(Icons.person, size: 35)
                          : null,
                    ),
                    Positioned(
                      left: 50,
                      top: 50,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF002DE3),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (profile_name != null && profile_name!.isNotEmpty)
                          ? profile_name!
                          : "Your Name",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      phonenumber.isNotEmpty ? phonenumber : "",
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            ),
            SizedBox(height: 90.h),
            buildMenuItem(Icons.person_2_outlined, "Account", () {}),
            buildMenuItem(Icons.chat_bubble_outline_outlined, "Chats", () {}),
            buildMenuItem(Icons.wb_sunny_outlined, "Theme", () {
              _showdialogtheme(isdark);
            }),
            buildMenuItem(
                Icons.notifications_none_outlined, "Notification", () {}),
            buildMenuItem(Icons.shield_outlined, "Privacy", () {}),
            buildMenuItem(Icons.insert_chart_outlined, "Data Usage", () {}),
            buildMenuItem(Icons.help_outline, "Help", () {}),
            buildMenuItem(Icons.mail_outline, "Invite Your Friends", () {}),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuItem(IconData icon, String title, dynamic onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Icon(icon),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        Spacer(),
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ],
    ),
  );
}
