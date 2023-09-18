import 'package:flutter/material.dart';
import 'package:videochat/Screens/MeetingScreen.dart';
import 'package:videochat/Screens/Schedule.dart';
import 'package:videochat/Screens/Settings.dart';
import 'package:videochat/constants/Constants.dart';

import 'History.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MeetingScreen(),
    const HistoryScreen(),
    const ScheduleScreen(),
    const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: appColor,
          boxShadow:const [
            BoxShadow(
            color: Colors.grey, 
            offset: Offset(0, 3), 
            blurRadius: 5, 
            spreadRadius: 2, 
            ),
          ],
        ),
        child: BottomNavigationBar(
          unselectedItemColor: appColor, 
          unselectedLabelStyle: TextStyle(color: appColor, fontSize: 14),
          fixedColor: appColor,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home ,color: appColor,),
              label: 'Home' ,
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history,color: appColor,),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule,color: appColor,),
              label: 'Schedule',
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: appColor,),
              label: 'Settings',
              
            ),
            
          ],
        ),
      ),
    );
  }
}