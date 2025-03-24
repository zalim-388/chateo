import 'package:chateo/ui/your_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Otp extends StatefulWidget {
  final String phonenumber;
  const Otp({super.key, required this.phonenumber});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 63.h,
              ),
              Center(
                child: Text(
                  "Enter Code",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "We have sent you an SMS with the code  ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'to ${widget.phonenumber.isNotEmpty ? widget.phonenumber : 'your number'}',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 64.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.grey,
                    selectedColor: Color(0xFF002DE3),
                  ),
                  onChanged: (value) {
                    print("Entered Otp:$value");
                  },
                ),
              ),
              SizedBox(
                height: 350.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Resend Code",
                          style:
                              TextStyle(color: Color(0xFF002DE3), fontSize: 21),
                        )),
                    SizedBox(
                      width: 170.w,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YourProfile(),
                            ));
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                      ),
                      backgroundColor: Color(0xFF002DE3),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
