import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videochat/Screens/Authentications/auth.dart';
import 'package:videochat/constants/Constants.dart';

import 'Authentications/SignUp.dart';
import 'Authentications/firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

                return ListView(
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
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
