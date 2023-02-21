// ignore_for_file: prefer_const_constructors

import 'package:borderless/pages/account.dart';
import 'package:borderless/pages/home_posts.dart';
import 'package:borderless/pages/secrete.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // navigate the bottom bar
  int _selectedIndex = 0;
  void bottomNavigator(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // nav to different pages
  final List<Widget> _children = [
    Post(),
    SecretePage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: bottomNavigator,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.weekend_outlined), label: 'secret hole'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'account'),
      ]),
    );
  }
}
