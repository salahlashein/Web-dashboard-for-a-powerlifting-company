import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/userdata.dart';
import '../services/userservice.dart';
import 'manage_billing.dart';
import 'componant/change_password.dart';
import 'componant/edit_email.dart';
import 'coach_billing.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

bool isLoadingUpdate = false;

class _SettingScreenState extends State<SettingScreen> {
  String _coachName = '';
  List<CoachBillingModel> _coachBilling = [];
  List<ManageBillingModel> _manageBilling = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UploadTask uploadTask;
  FirebaseStorage storage = FirebaseStorage.instance;
  UserDataModel userData = UserDataModel(
      firstName: 'firstName', lastName: 'lastName', email: 'email');
  @override
  void initState() {
    super.initState();
    _loadCoachName();
  }

  bool isLoading = false;
  bool isLoadingImage = false;

  Future<void> _loadCoachName() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      log(user.toString());
      log(user!.uid.toString());
      if (user != null) {
        var snapshot =
            await _firestore.collection('Coaches').doc(user.uid).get();
        if (snapshot.exists) {
          setState(() {
            userData = UserDataModel.fromJson(snapshot.data()!);
            isLoading = false;
          });
          await _loadCoachBilling();
        }
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  Future<void> _loadCoachBilling() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String coachId = user.uid;
        List<CoachBillingModel> coachBilling =
            await UserService().getCoachCoachBilling(coachId);
        setState(() {
          _coachBilling = coachBilling;
          isLoading = false;
        });
        await _loadManageBilling();
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  Future<void> _loadManageBilling() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String coachId = user.uid;
        List<ManageBillingModel> manageBilling =
            await UserService().getCoachManageBilling(coachId);
        setState(() {
          _manageBilling = manageBilling;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  PlatformFile? _imageFile;
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      setState(() {
        isLoadingImage = true;
        _imageFile = result.files.first;
      });
      selectFile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  selectFile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Reference _reference = storage.ref().child('images/${_imageFile!.name}');
      _reference
          .putData(
        await _imageFile!.bytes!,
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((valuee) {
          _firestore
              .collection('Coaches')
              .doc(user.uid)
              .update({"imagePath": valuee}).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image Updated Successfuly!'),
                backgroundColor: Colors.green,
              ),
            );
            _loadCoachName();
            setState(() {
              isLoadingImage = false;
            });
          }).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          });
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        });
      });
    }
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      EditEmail(isEditProfile: true, userDataModel: userData),
      EditEmail(isEditProfile: false, userDataModel: userData),
      ChangePassword(),
      CoachBilling(coachBillingModel: _coachBilling),
      ManageBilling(manageBillingModel: _manageBilling),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const Text(
                    'PROFILE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(userData.imagePath ==
                                      null ||
                                  userData.imagePath == " "
                              ? 'https://i.scdn.co/image/ab6765630000ba8a66ffe9bced4f416322aaa4c4'
                              : userData.imagePath!),
                          child: isLoadingImage == true
                              ? CircularProgressIndicator(
                                  color: Color(0xff5bc500),
                                )
                              : null,
                        ),
                        CircleAvatar(
                          radius: 10,
                          child: Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.white,
                          ),
                          backgroundColor: Color(0xff5bc500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData.firstName + ' ' + userData.lastName,
                    style: TextStyle(
                        color: Color(0xff5bc500),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'ACCOUNT SETTINGS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: selectedIndex == 0
                                  ? const Color(0xff5bc500)
                                  : Colors.grey.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Text(
                            'Change Email',
                            style: TextStyle(
                                color: selectedIndex == 1
                                    ? const Color(0xff5bc500)
                                    : Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = 2;
                            });
                          },
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                                color: selectedIndex == 2
                                    ? const Color(0xff5bc500)
                                    : Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = 3;
                            });
                          },
                          child: Text(
                            'Coach Billig',
                            style: TextStyle(
                                color: selectedIndex == 3
                                    ? const Color(0xff5bc500)
                                    : Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = 4;
                            });
                          },
                          child: Text(
                            'Manage Billing',
                            style: TextStyle(
                                color: selectedIndex == 4
                                    ? const Color(0xff5bc500)
                                    : Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: isLoading == false
                    ? screens[selectedIndex]
                    : Center(
                        child: CircularProgressIndicator(),
                      )),
          ],
        ),
      ),
    );
  }
}
