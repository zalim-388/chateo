import 'package:chateo/ui/otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  final TextEditingController _phoneController = TextEditingController();

  Country? selectedCountry;

  Future<void> verification() async {
    String phonenumber = _phoneController.text.trim();

    if (phonenumber.isEmpty) {
      print("Fields cannot be empty");
      return;
    }

    String fullPhoneNumber =
        '+${selectedCountry?.phoneCode ?? '91'}$phonenumber';

    try {
      DocumentReference docRef = users.doc(fullPhoneNumber);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({
          'contacts': [],
        });
        print("New user created: $fullPhoneNumber");
      } else {
        print("User already exists: $fullPhoneNumber");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Otp(phonenumber: fullPhoneNumber),
        ),
      );
    } catch (e) {
      print("Error during verification: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneController.text = '';
    selectedCountry = Country.parse("IN");
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
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
                "Please confirm your country code and enter\n    your phone number",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 45.h),
              Row(
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Phone Number",
                        hintStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF002DE3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF002DE3)),
                        ),
                        prefixIcon: GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country;
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            child: Text(
                              selectedCountry != null
                                  ? "+${selectedCountry!.phoneCode}"
                                  : "+91", // default
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ),
                  )
                ],
              ),
              SizedBox(height: 81.h),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: GestureDetector(
                  onTap: () async {
                    await verification();
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
