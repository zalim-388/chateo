import 'dart:io';

import 'package:chateo/ui/bottomnavi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourProfile extends StatefulWidget {
  final String phonenumber;
  const YourProfile({
    super.key,
    required this.phonenumber,
  });

  @override
  State<YourProfile> createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  final TextEditingController _Firstnamecontroller = TextEditingController();
  final TextEditingController _lastnamecontroller = TextEditingController();
  File? profileImage;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
    }
  }

  void saveProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name',
        '${_Firstnamecontroller.text.trim()} ${_lastnamecontroller.text.trim()}');
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,

      appBar: AppBar(
              backgroundColor: Colors.white,

        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Your profile",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      profileImage != null ? FileImage(profileImage!) : null,
                  child: profileImage == null
                      ? const Icon(Icons.add_a_photo,
                          color: Colors.white, size: 50)
                      : null,
                ),
                Positioned(
                    left: 90,
                    top: 75,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF002DE3),
                            size: 20,
                          )),
                    ))
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _Firstnamecontroller,
                decoration: InputDecoration(
                    hintText: "First Name (Required)",
                    hintStyle: TextStyle(fontSize: 17),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF002DE3),
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF002DE3),
                    ))),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _lastnamecontroller,
                decoration: InputDecoration(
                    hintText: "Last Name (Required)",
                    hintStyle: TextStyle(fontSize: 17),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF002DE3),
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF002DE3),
                    ))),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            GestureDetector(
              onTap: () {
                saveProfileName();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Bottomnavi(
                        number: widget.phonenumber,
                      ),
                    ));
              },
              child: Container(
                height: 52.h,
                width: 327.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF002DE3),
                ),
                alignment: Alignment.center,
                child: Text(
                  " save",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

  // void getdata() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   final savename = await prefs.getString("profile_name");
  //   final saveimage = await prefs.getString("profile_image");
  //   if (savename != null) {
  //     final nameparts = savename.split('');
  //     if (savename.isNotEmpty) {
  //       setState(() {
  //         _Firstnamecontroller.text = savename.split(" ")[0];
  //         _lastnamecontroller.text = savename.split("")[1];
  //       });
  //     }
  //   }

  //   if (saveimage != null) {
  //     setState(() {
  //       profileImage = File(saveimage);
  //     });
  //   }
  // }