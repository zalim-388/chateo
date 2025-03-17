import 'package:chateo/ui/Verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      print("user Registration:${userCredential.user?.email}");

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        print("verification email send ${user.email}");

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Verification(
                Phonenumber: '',
              ),
            ));
      }
    } catch (e) {
      print("Registraction error${e}");

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registraction failed${e}")));
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          print("user loggin ${userCredential.user?.uid}");
        } else {
          print("user's email is not verified");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Your email is not verified. Please verify your email before logging in.")));
        }
      }
    } on FirebaseAuthException catch (e) {
      print("login error${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Verification(
                        Phonenumber: '',
                      ),
                    ));
              },
              child: Text("skip"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.h),
            // ElevatedButton(
            //   onPressed: () {
            //     _login(context);
            //     String email = emailController.text;
            //     String password = passwordController.text;
            //     print("Email: $email, Password: $password");
            //   },
            //   child: Text("Login"),
            // ),
// TextButton(onPressed: (){
//   Navigator.push(context, MaterialPageRoute(builder: (context) => Verification(Phonenumber: '',),));
// }, child: Text("already logged in"))

            GestureDetector(
              onTap: () {
                _login(context);
                String email = emailController.text;
                String password = passwordController.text;
                print("Email: $email, Password: $password");
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
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),

            TextButton(onPressed: () {}, child: Text("Forget password"))
          ],
        ),
      ),
    );
  }
}
