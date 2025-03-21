import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class More extends StatefulWidget {
  final String phonenumber;
  const More({super.key, required this.phonenumber});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              "More",
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF002DE3),
              ),
            ),
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
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
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.phonenumber.isNotEmpty
                          ? widget.phonenumber
                          : "you number",
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
                SizedBox(
                  width: 130.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 90.h,
            ),
            Row(
              children: [
                Icon(Icons.person_2_outlined),
                Text(
                  "Acount",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 225.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.chat_bubble_outline_outlined),
                Text(
                  "Chats",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 232.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              children: [
                Icon(Icons.wb_sunny_outlined),
                Text(
                  "Theme",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 227.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.notifications_none_outlined),
                Text(
                  "Notification",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 200.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.shield_outlined),
                Text(
                  "Privacy",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 225.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.insert_chart_outlined),
                Text(
                  "Data Usage",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 200.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.help_outline),
                Text(
                  "Help",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 240.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.mail_outline),
                Text(
                  "Invite Your Friends",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 161.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ))
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
