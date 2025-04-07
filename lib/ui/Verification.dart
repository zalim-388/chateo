import 'package:chateo/ui/Contacts.dart';
import 'package:chateo/ui/otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Verification extends StatefulWidget {
  const Verification({
    super.key,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  final TextEditingController _phoneController = TextEditingController();

  Future<void> verification() async {
    String phonenumber = _phoneController.text.trim();

    if (phonenumber.isEmpty) {
      print("Fields cannot be empty");
      return;
    }

    DocumentReference docRef = users.doc(phonenumber);
    DocumentSnapshot docSnapshot = await docRef.get();

    print("User Added: $phonenumber");

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Contacts(name: '', number: phonenumber),
        ));
  }

  @override
  void initState() {
    super.initState();

    _phoneController.text = '';
    print("phonenumber${''}");
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 79.h),
              Text(
                "Enter Your Phone Number",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                "Please confirm your country code and enter\n                 your phone number",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 45.h),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Phone Number",
                  hintStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFF002DE3),
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFF002DE3),
                  )),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 81.h),
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
