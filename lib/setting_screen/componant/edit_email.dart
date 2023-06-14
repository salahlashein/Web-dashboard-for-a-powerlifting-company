import 'package:flutter/material.dart';

import '../../models/userdata.dart';

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

  @override
  Widget build(BuildContext context) {
    emailController = TextEditingController(
        text: widget.isEditProfile == true
            ? widget.userDataModel.firstName
            : widget.userDataModel.email);
    passwordController = TextEditingController(
        text:
            widget.isEditProfile == true ? widget.userDataModel.lastName : '');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xff454545),
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height / 2,
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
            child: TextField(
              controller: emailController,
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
            child: TextField(
              controller: passwordController,
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
    );
  }
}
