import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'componant/edit_email.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int selectedIndex = 0;
  List<Widget> screens = [
    const EditEmail(isEditProfile: true),
    const EditEmail(isEditProfile: false),
    const Center(child: Text('page3')),
    const Center(child: Text('page4')),
    const Center(child: Text('page5')),
  ];
  @override
  Widget build(BuildContext context) {
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
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: const [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://i.scdn.co/image/ab6765630000ba8a66ffe9bced4f416322aaa4c4'),
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Zao Strength',
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
            Expanded(flex: 5, child: screens[selectedIndex]),
          ],
        ),
      ),
    );
  }
}
