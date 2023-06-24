import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/athleatesList.dart';
import 'package:web_dashboard/models/Coach.dart';
import 'package:web_dashboard/services/userservice.dart';
import 'package:web_dashboard/createprogram.dart';

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
  String _coachID = '';
  late final String coachId;
  User? user = FirebaseAuth.instance.currentUser;
  final List<Widget> _widgetOptions = <Widget>[
    Exerciselibrary(coachId: ''),
    CardScreen(),
    CalendarScreen(),
    AthletesGrid(),
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
    coachId = Provider.of<CoachProvider>(context, listen: false).getcoach().id;
    _widgetOptions[0] = Exerciselibrary(coachId: coachId);
  }

  Future<void> _loadCoachName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String coachId = user.uid;
        String coachName = await UserService().getCoachName(coachId);
        setState(() {
          _coachName = coachName;
          _coachID = coachId;
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
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    _createAthleteAccount(athleteEmail, _coachID);
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

  Future<void> _createAthleteAccount(
      String athleteEmail, String coachId) async {
    try {
      final String code = _generateRandomCode();
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('Athletes').doc();
      final String docId = docRef.id;

      await docRef.set({
        'id': docId,
        'randomCode': code,
        'coachId': coachId,
      });

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
              onPressed: () {},
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
                label: Text('Training', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
                selectedIcon: Icon(
                  Icons.chat_bubble_outline,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Chat', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today_outlined, color: Colors.white),
                selectedIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Calendar', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.groups, color: Colors.white),
                selectedIcon: Icon(
                  Icons.groups,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Athletes', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.message_outlined, color: Colors.white),
                selectedIcon: Icon(
                  Icons.message_outlined,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Messages', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
