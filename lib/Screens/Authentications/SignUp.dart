import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import '../Globles.dart';
import 'Login.dart';
import 'auth.dart';
import 'firestore.dart';




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

class createQuiz extends StatefulWidget {
  const createQuiz({Key? key});

  @override
  State<createQuiz> createState() => _createQuizState();
}

class _createQuizState extends State<createQuiz> {
 final _signupformkey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  File? image_file;
  final ImagePicker _picker = ImagePicker();
  final FocusNode _correctfocus = FocusNode();
  final FocusNode _opt2focus = FocusNode();
  final FocusNode _opt3focus = FocusNode();
  bool _isloading = false;
  final TextEditingController _opt1 = TextEditingController(text: '');
  final TextEditingController _opt2 = TextEditingController(text: '');
  final TextEditingController _opt3 = TextEditingController(text: '');
  String? imgUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUploaded = false;
  bool loading = false;
  String imageName = '';
  Uint8List? _imageBytes;
  @override
  void dispose() {
    _opt1.dispose();
    _opt2.dispose();
    _opt3.dispose();
    super.dispose();
  }

  

  void _chooseImageOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please Choose An Option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFilefromcamera(context);
                  },
                  child:  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: appColor,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFilefromgallery(context);
                  },
                  child:  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: appColor,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _getFilefromcamera(BuildContext context) async {
    final XFile? imagepicked =
        await _picker.pickImage(source: ImageSource.camera);
    _CroppImage(imagepicked!.path);
    Navigator.pop(context);
  }

  void _getFilefromgallery(BuildContext context) async {
    final XFile? imagepicked =
        await _picker.pickImage(source: ImageSource.gallery);
    _CroppImage(imagepicked!.path);
    Navigator.pop(context);
  }

  void _CroppImage(filepath) async {
    CroppedFile? imagecropped = await ImageCropper()
        .cropImage(sourcePath: filepath, maxHeight: 1080, maxWidth: 1080);
    if (imagecropped != null) {
      setState(() {
        image_file = File(imagecropped.path);
        _imageBytes = image_file!.readAsBytesSync();
        imageName = image_file!.path.split('/').last;
      });
    }
  }

  void _submitform(BuildContext context) async {
    log("Submit Form");

    final isValid = _signupformkey.currentState!.validate();
    if (isValid) {
      log("Valid");
      // If image is not present, we dont continue
      if (image_file == null) {
        log("Image File Null");
        Global_Methods.showErrorBox(
          error: "Please Choose An Image",
          ctx: context,
        );
        return;
      } 
      
      setState(() {
        _isloading = true;
      });
    }

    try {
        log("Try");

      log('Image File: $image_file');
      log('Image path: ${image_file!.path}');
      // final User? user = FirebaseAuth.instance.currentUser;
      // final uid = user!.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child('pfpImages')
          .child(imageName);

      await ref.putFile(image_file!);

      final imgUrl = await ref.getDownloadURL();

      
      final refer = FirebaseFirestore.instance.collection('Users').doc();
      var data1 = {
        'Email' : _opt1.text,
        'Name' : _opt2.text,
        'Password' : _opt3.text,
        'Image' : imgUrl.toString(),
      };
      await refer.set(data1, SetOptions(merge: true));
      // ignore: use_build_context_synchronously
      AuthService().registerUser(_opt1.text,_opt3.text,context);
      log('Uploaded i assume');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      Global_Methods.showErrorBox(error: e.toString(), ctx: context);
      log("Error Occured $e");
    }
    setState(() {
      _isloading = false;
    });
  }





  @override
  Widget build(BuildContext context) {
    Size sizze = MediaQuery.of(context).size;
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Form(
                    key: _signupformkey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _chooseImageOptions(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: sizze.width * 0.35,
                              height: sizze.width * 0.35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: appColor,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: image_file == null
                                    ? Icon(
                                        Icons.camera_enhance_sharp,
                                        color: appColor,
                                        size: 30,
                                      )
                                    : Image.file(
                                        image_file!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_opt2focus),
                              keyboardType: TextInputType.emailAddress,
                              controller: _opt1,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Email!';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                              decoration:  InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10,30,30,0),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: appColor, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_opt3focus),
                              keyboardType: TextInputType.name,
                              controller: _opt2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Name!';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                              decoration:  InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10,30,30,0),
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: appColor, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              controller: _opt3,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Password!';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                              decoration:  InputDecoration(
                                contentPadding:
                                  EdgeInsets.fromLTRB(10,30,30,0),
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: appColor, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        _isloading
                            ? const Center(
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Center(
                                child: SizedBox(
                                  width: 300,
                                  height: 48,
                                  child: MaterialButton(
                                    onPressed: () {
                                      _submitform(context);
                                    },
                                    color: appColor,
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "SignUp",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
                children:[
                  Text('Already have an account?'),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyStatefulWidget()),
                      );
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            
          ],
        ),
      ),
    );
  }
}
