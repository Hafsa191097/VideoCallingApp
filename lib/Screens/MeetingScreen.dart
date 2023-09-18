import 'package:flutter/material.dart';

import '../constants/Constants.dart';
import 'Authentications/firestore.dart';
import 'CallingScreen.dart';
import 'Home.dart';



import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Action;


class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
    final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Users').snapshots();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  FireStoreDataBase db = FireStoreDataBase();
  // ignore: non_constant_identifier_names
  Widget QuizList() {
    return Container();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CallScreen()),
                      );
                  },
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      data['documentId'] = document.id;
                      return ListTile(
                        title: Text(data['Name'],
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500)),
                        subtitle: Text(data['Email']),
                        leading: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 58,
                            maxHeight: 100,
                          ),
                          child: Container(
                            width: 130,
                            height: 155,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: appColor,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(96),
                              child: Image.network(
                                data['Image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
