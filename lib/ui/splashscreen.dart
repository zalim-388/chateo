import 'package:chateo/ui/Login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});


  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 113.h,
          ),
          Container(
              height: 271.h,
              width: 262.w,
              child: Image.asset(
                'assets/image/Illustration.png',
                fit: BoxFit.contain,
                // height: 250.h,
              )),
          SizedBox(
            height: 64.h,
          ),
          Center(
              child: Text(
            "    Connect easily with\n your family and friends\n         over countries",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          )),
          SizedBox(
            height: 126.h,
          ),
          Center(
              child: Text(
            "Terms & Privacy Policy",
            style: TextStyle(
              fontSize: 20,
            ),
          )),
          SizedBox(
            height: 18.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
            },
            child: Container(
              height: 52.h,
              width: 327.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF002DE3),
              ),
              alignment: Alignment.center,
              child: Text(
                "Start Messaging",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }
}
