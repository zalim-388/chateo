import 'package:chateo/ui/Contacts.dart';
import 'package:chateo/ui/chats.dart';
import 'package:chateo/ui/more.dart';
import 'package:flutter/material.dart';

class Bottomnavi extends StatefulWidget {
  const Bottomnavi({super.key});

  @override
  State<Bottomnavi> createState() => _BottomnaviState();
}

class _BottomnaviState extends State<Bottomnavi> {
  int currentPageIndex = 0;

  final List<Widget> _bottom =[
    Contacts(),
  Chats(),
More(),

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottom[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.contacts_outlined,
                size: 25,
              ),
              label: 'Contacts'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline,
                size: 25,
              ),
              label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.more_vert_outlined,
                size: 25,
              ),
              label: 'More'),
        ],
        currentIndex: currentPageIndex,
        unselectedItemColor: Colors.grey
        ,
        selectedItemColor:Color(0xFF002DE3), 
        onTap: (Index) {
          setState(() {
            currentPageIndex = Index;
          });
        },
        elevation: 3,
      ),
    );
  }
}
