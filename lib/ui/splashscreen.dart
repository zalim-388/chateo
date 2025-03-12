import 'package:chateo/ui/Login_screen.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 260),
        child: Column(
          children: [
            Container(
              height: 271,
              width: 262,
            ),
            Center(
              child: Image.asset(
                'assets/image/Illustration.png',
                fit: BoxFit.contain,
                height: 250,
              ),
            ),
            SizedBox(
              height: 170,
            ),
            Center(
                child: Text(
              "Connect easily with\n your family and friends\n over countries",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            )),
            Center(
                child: Text(
              "Terms & Privacy Policy",
              style: TextStyle(
                fontSize: 20,
              ),
            )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              child: Container(
                height: 60,
                width: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
