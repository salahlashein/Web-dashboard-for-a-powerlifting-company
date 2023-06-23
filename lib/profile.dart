import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/models/Athlete.dart';

class ProfileScreen extends StatefulWidget {
  final Athlete athlete;

  ProfileScreen({required this.athlete});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _showTable;
  String? _Name;
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _showTable = false;
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    FirebaseFirestore.instance
        .collection('Athletes')
        .where('coachId', isEqualTo: userId)
        .where('firstName', isNotEqualTo: null)
        .get()
        .then((snapshot) {
      print('Documents found: ${snapshot.docs.length}');
      if (snapshot.docs.isNotEmpty) {
        print('Document data: ${snapshot.docs.first.data()}');
        setState(() {
          _Name = snapshot.docs.first.data()['firstName'];
        });
      }
    });

    FirebaseFirestore.instance
        .collection('exerciseLibrary')
        .get()
        .then((snapshot) {
      setState(() {
        _data = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  void _deleteCoachId() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('coaches')
        .where('coachId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.delete();
      }
    });

    setState(() {
      _Name = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Color.fromARGB(255, 9, 181, 152),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_Name'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Exercise Library'),
                        onPressed: () {
                          setState(() {
                            _showTable = true;
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _deleteCoachId,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                          ),
                          child: Text('End Training'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _showTable,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Primary')),
                      DataColumn(label: Text('Secondary')),
                    ],
                    rows: _data
                        .map(
                          (data) => DataRow(
                            cells: [
                              DataCell(Text(data['name'])),
                              DataCell(Text(data['primary'])),
                              DataCell(Text(data['secondary'])),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
