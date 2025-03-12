import 'package:chateo/ui/your_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              builder: (context) => YourProfile(),
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
      appBar: AppBar(title: Text("Login")),
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
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login(context);
                String email = emailController.text;
                String password = passwordController.text;
                print("Email: $email, Password: $password");
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
