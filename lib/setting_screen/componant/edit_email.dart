import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/userdata.dart';
import '../../services/userservice.dart';
import '../setting.dart';
import 'dart:html' as html;

class EditEmail extends StatefulWidget {
  final bool isEditProfile;
  final userDataModel;
  const EditEmail(
      {super.key, required this.isEditProfile, required this.userDataModel});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  var formKey = GlobalKey<FormState>();
  Future<void> _updateCoachName() async {
    setState(() {
      isLoadingUpdate = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await UserService().updateCoachNameEmail(
            coachId: user.uid,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: emailController.text);
        setState(() {
          isLoadingUpdate = false;
          Get.snackbar('Updated', 'Update Successfull');
        });
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  Future<void> _updateCoachEmail() async {
    var email = emailController.text;
    setState(() {
      isLoadingUpdate = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;

// Verify current password
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user!.email!, password: passwordController.text);
      if (result.user != null) {
        await UserService().updateCoachNameEmail(
            coachId: result.user!.uid,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: email);
        setState(() {
          isLoadingUpdate = false;
          Get.snackbar('Updated', 'Update Successfull');
        });
        print('email Success***************');
      }
    } catch (e) {
      print('Error loading coach email: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    emailController = TextEditingController(text: widget.userDataModel.email);
    passwordController = TextEditingController(text: '');
    firstNameController =
        TextEditingController(text: widget.userDataModel.firstName);
    lastNameController =
        TextEditingController(text: widget.userDataModel.lastName);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xff454545),
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height / 2,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.isEditProfile == true ? "First Name" : 'Email'),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 55,
              child: TextFormField(
                controller: widget.isEditProfile != true
                    ? emailController
                    : firstNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, fill out this field !';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: widget.isEditProfile == true
                      ? "First Name"
                      : 'Email@gmail.com',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xff5bc500),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(widget.isEditProfile == true ? "Last Name" : 'Password'),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 55,
              child: TextFormField(
                controller: widget.isEditProfile == true
                    ? lastNameController
                    : passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, fill out this field !';
                  }
                  return null;
                },
                keyboardType: widget.isEditProfile == true
                    ? TextInputType.text
                    : TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: widget.isEditProfile == true ? "Last Name" : '',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xff5bc500),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            isLoadingUpdate == true
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (widget.isEditProfile == true) {
                          _updateCoachName().then((value) {
                            html.window.location.reload();
                          });
                        } else {
                          _updateCoachEmail().then((value) {
                            html.window.location.reload();
                          });
                        }
                      } else {
                        Get.snackbar('Error', 'Something went wrong !');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size(150.0, 70.0),
                      backgroundColor: const Color(0xff5bc500),
                    ),
                    child: const Text(
                      'Save Change',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
