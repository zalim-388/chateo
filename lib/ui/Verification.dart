import 'package:chateo/ui/otp.dart';
import 'package:chateo/ui/your_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Verification extends StatefulWidget {
  final String Phonenumber;
  const Verification({super.key, required this.Phonenumber});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference user = FirebaseFirestore.instance.collection("user");

  final TextEditingController _phoneController = TextEditingController();

  Future<void> verification() async {
    String phonenumber = _phoneController.text.trim();

    return user
        .add({"Phonenumber": _phoneController.text})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.Phonenumber;
  }

  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Text(
                "Enter Your Phone Number",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50.h),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  hintText: "Phone Number",
                  hintStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
                child: GestureDetector(
                  onTap: () async {
                    await verification();
                    String Phonenumber = _phoneController.text;
                    print("phonenumber${Phonenumber}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Otp(
                          phonenumber: _phoneController.text.trim(),
                        ),
                      ),
                    );
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
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
