import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:web_dashboard/services/userservice.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  String _coachName = '';

  final List<Widget> _widgetOptions = <Widget>[
    Text('Exercise Library Page', style: TextStyle(color: Colors.white)),
    Text('Templates Page', style: TextStyle(color: Colors.white)),
    Text('Athlete Overview Page', style: TextStyle(color: Colors.white)),
    Text('Athlete List Page', style: TextStyle(color: Colors.white)),
    Text('Chat Page', style: TextStyle(color: Colors.white)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCoachName(); // Replace with your EmailJS user ID
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
              horizontal: 16.0), // Adjust the horizontal padding
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: 450.0, // Set a specific width for the dialog
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your athlete\'s email to send the code',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                TextFormField(
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
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 9, 181, 152),
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text(
                    'Send Invitation',
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

  String _generateRandomCode() {
    final random = Random();
    final code = List.generate(6, (_) => random.nextInt(10)).join();
    return code;
  }

  Future<void> _createAthleteAccount(String email, String code) async {
    await FirebaseFirestore.instance.collection('Athletes').doc(email).set({
      'randomCode': code,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showAddAthleteDialog(context);
                  },
                  child: Text(
                    'Add Athlete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
        title: Text(
          'Welcome $_coachName',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 9, 181, 152),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Exercise Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Athlete Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_people),
            label: 'Athlete List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
