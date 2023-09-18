import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:videochat/Screens/Home.dart';

import '../constants/Constants.dart';

class Videochat extends StatefulWidget {
  const Videochat({super.key});

  @override
  State<Videochat> createState() => _VideochatState();
}

class _VideochatState extends State<Videochat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              width: 411,
              height: 450,
              decoration:  BoxDecoration(
                  borderRadius:const BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                  color: appColor,
                  boxShadow: const[
                        BoxShadow(
                        color: Colors.grey, 
                        offset: Offset(0, 3), 
                        blurRadius: 5, 
                        spreadRadius: 2, 
                        ),
                    ],
                  ),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Center(
                       child: Text(
                          "VideoChat",
                          style: GoogleFonts.titanOne(
                          fontSize: 50,
                          fontWeight: FontWeight.w400,
                          color: TextColor,
                          height: 111 / 73,
                          ) ,
                          textAlign: TextAlign.center,
                        ),
                     ),
                      Text(
                        "Platform of online learning",
                        style: TextStyle(
                        fontSize: 17,
                        color: TextColor,
                        fontWeight: FontWeight.w400,
                        ),
                    ),
                   ],
                 ),
            ),
            const SizedBox(
                height: 25,
            ),
           TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>const HomeScreen(),
                  ),
                );
              },
              
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  color: appColor,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                  
                  child: Center(
                    child: Text(
                      'New Meeting',
                      style: TextStyle(color: TextColor, fontSize: 20.0),
                    ),
                    
                  ),
                ),
              ),
            ),
            
           Padding(
              padding: const EdgeInsets.only(left: 28,right: 28),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('Join Meeting',style: TextStyle(fontSize: 20,color: Colors.teal),),
                  style: OutlinedButton.styleFrom(
                    primary: TextColor,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    side: BorderSide(color: appColor, width: 2),
                  ),
                  onPressed: () {
                    print('Pressed');
                  },
                ),
              ),
            ),
          ],
      ),
    );
  }
}
