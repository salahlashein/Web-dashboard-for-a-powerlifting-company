import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:web_dashboard/services/userservice.dart';

import 'athleteoverview.dart';
import 'chatPage.dart';
import 'exercise.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  String _coachName = '';

  final List<Widget> _widgetOptions = <Widget>[
    exercise(),
    Text('Templates Page', style: TextStyle(color: Colors.white)),
    HomePage(),
    Text('Athlete List Page', style: TextStyle(color: Colors.white)),
    chatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCoachName();
  }

  Future<void> _loadCoachName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String coachId = user.uid;
        String coachName = await UserService().getCoachName(coachId);
        setState(() {
          _coachName = coachName;
        });
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  void _showAddAthleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String athleteEmail = '';
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: 450.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your athlete\'s email',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    athleteEmail = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter athlete\'s email',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _createAthleteAccount(athleteEmail);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 9, 181, 152),
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text(
                    'Add Athlete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createAthleteAccount(String athleteEmail) async {
    try {
      final String code = _generateRandomCode();
      await FirebaseFirestore.instance
          .collection('Athletes')
          .doc(athleteEmail)
          .set({
        'randomCode': code,
      });

      // Show dialog with the generated code
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Athlete Added'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('The athlete has been successfully added.'),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Random Code:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        // Copy the code to the clipboard
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Code copied to clipboard'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  code,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      print('Athlete account created successfully');
    } catch (e) {
      print('Error creating athlete account: $e');
    }
  }

  String _generateRandomCode() {
    final random = Random();
    final code = List.generate(6, (index) => random.nextInt(10)).join();
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 50, 48),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _showAddAthleteDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 9, 181, 152),
              ),
              child: Text('Add athlete'),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your action for notification icon here
              },
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.white,
              // Add your profile picture logic here
              // Example:
              // backgroundImage: NetworkImage('https://example.com/profile-image.jpg'),
            ),
            SizedBox(width: 10),
            Text(_coachName, style: TextStyle(color: Colors.white)),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Color.fromARGB(255, 50, 50, 48),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.library_books, color: Colors.white),
                selectedIcon: Icon(
                  Icons.library_books,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text(
                  'Exercise Library',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.layers, color: Colors.white),
                selectedIcon: Icon(
                  Icons.layers,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text(
                  'Templates',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people, color: Colors.white),
                selectedIcon: Icon(
                  Icons.people,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text(
                  'Athlete Overview',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list, color: Colors.white),
                selectedIcon: Icon(
                  Icons.list,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text(
                  'Athlete List',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat, color: Colors.white),
                selectedIcon: Icon(
                  Icons.chat,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text(
                  'Chat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
