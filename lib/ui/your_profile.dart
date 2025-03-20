import 'package:chateo/ui/bottomnavi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourProfile extends StatefulWidget {
  const YourProfile({
    super.key,
  });

  @override
  State<YourProfile> createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  final TextEditingController _Firstnamecontroller = TextEditingController();
  final TextEditingController _lastnamecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
              ),
              Positioned(
                  left: 90,
                  top: 75,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                        onPressed: () {},
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Bottomnavi(),
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
    );
  }
}
