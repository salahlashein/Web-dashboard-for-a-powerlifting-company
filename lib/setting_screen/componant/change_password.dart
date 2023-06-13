// TODO Implement this library.
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  final bool isChangePassword;
  const ChangePassword({super.key, required this.isChangePassword});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController changePasswordController = TextEditingController();
  TextEditingController createnNewPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xff454545),
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.isChangePassword == true
                  ? "Current Password"
                  : 'Create New Password'),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 55,
                child: TextField(
                  controller: changePasswordController,
                  keyboardType: widget.isChangePassword == true
                      ? TextInputType.text
                      : TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: widget.isChangePassword == true ? "" : '',
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
              Text(widget.isChangePassword == true
                  ? "Create New Password"
                  : 'Password'),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 55,
                child: TextField(
                  controller: createnNewPasswordController,
                  keyboardType: widget.isChangePassword == true
                      ? TextInputType.text
                      : TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: widget.isChangePassword == true ? "" : '',
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
              Text(widget.isChangePassword == true
                  ? "Confirm New Password"
                  : 'Password'),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 55,
                child: TextField(
                  controller: confirmNewPasswordController,
                  keyboardType: widget.isChangePassword == true
                      ? TextInputType.text
                      : TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: widget.isChangePassword == true ? "" : '',
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
              ElevatedButton(
                onPressed: () {},
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
        ],
      ),
    );
  }
}
