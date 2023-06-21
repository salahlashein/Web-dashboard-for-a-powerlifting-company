// TODO Implement this library.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import 'package:web_dashboard/services/userservice.dart';

import '../setting.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController changePasswordController = TextEditingController();
  TextEditingController createnNewPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Future<void> _changePass() async {
    setState(() {
      isLoadingUpdate = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await UserService()
            .changePassword(
                currentPass: changePasswordController.text,
                newPass: createnNewPasswordController.text,
                reNewPass: confirmNewPasswordController.text)
            .then((value) {
          if (value == true) {
            setState(() {
              isLoadingUpdate = false;
              Get.snackbar('Updated', "Password updated successfuly",
                  backgroundColor: Colors.green);
            });
          } else {
            setState(() {
              isLoadingUpdate = false;
              Get.snackbar('Error', "The current password is wong, try agin!",
                  backgroundColor: Colors.red);
            });
          }
        });
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xff454545),
          borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Current Password"),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 55,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, fill out this field !';
                  }
                  return null;
                },
                controller: changePasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xff5bc500),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
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
            Text("Create New Password"),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 55,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, fill out this field !';
                  } else if (value != confirmNewPasswordController.text) {
                    return 'The new password and the confirm is not the same';
                  }
                  return null;
                },
                controller: createnNewPasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Color(0xff5bc500),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
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
            Text("Confirm New Password"),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 55,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, fill out this field !';
                  } else if (value != createnNewPasswordController.text) {
                    return 'The new password and the confirm is not the same';
                  }
                  return null;
                },
                controller: confirmNewPasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Color(0xff5bc500),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
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
                        _changePass().then((value) {
                          // html.window.location.reload();
                        });
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
