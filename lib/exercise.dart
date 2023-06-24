import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Coach.dart';
//import 'package:get/get.dart';
//import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//import 'package:get/get.dart';

final _firestore = FirebaseFirestore.instance;
String? name;
String? exerciseType;
String? primary;
String? secondary;
String? videolink;

//String _filter = '';

class Exerciselibrary extends StatefulWidget {
  //const exercise({super.key});
  final String coachId;

  const Exerciselibrary({required this.coachId});

  @override
  State<Exerciselibrary> createState() => _ExerciselibraryState(coachId);
}

class _ExerciselibraryState extends State<Exerciselibrary> {
  final String coachId;

  List<Map<String, dynamic>> _data = [];

  _ExerciselibraryState(this.coachId);
  void initState() {
    super.initState();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('exerciseLibrary')
        .where('coachId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      setState(() {
        _data = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[850],
              height: double.infinity,
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 25),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXERCISE LIBRARY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            'Build and manage the master exercise library for your account so you can build training programs',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 200),
                          child: ElevatedButton.icon(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 3)),
                            onPressed: () {
                              showDialogWidget(context);
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Add Exercise   ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 120),
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 270,
                          ),
                          // TextButton(
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, '/exercise');
                          //     },
                          //     child: Text('click')),
                          // TextButton(
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, ReportScreen.id);
                          //     },
                          //     child: Text('report'))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 160, horizontal: 35),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                "Exercise Name",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Video",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Instruction",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Primary muscle",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Secondary muscle",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Exercise type",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows: _data
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        data['name'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Icon(
                                        Icons.video_call_sharp,
                                        color: Colors.green,
                                      ),
                                    ),
                                    DataCell(
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        data['primary'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        data['secondary'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        data['exerciseType'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  showDialogWidget(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _typeController = TextEditingController();
    final TextEditingController _primaryController = TextEditingController();
    final TextEditingController _secondaryController = TextEditingController();
    final TextEditingController _urlController = TextEditingController();

    void _addExercise() {
      if (_formKey.currentState!.validate()) {
        String name = _nameController.text;
        String exerciseType = _typeController.text;
        String primary = _primaryController.text;
        String secondary = _secondaryController.text;
        String videolink = _urlController.text;

        FirebaseFirestore.instance.collection('exerciseLibrary').add({
          'coachId':
              Provider.of<CoachProvider>(context, listen: false).getcoach().id,
          'name': name,
          'exerciseType': exerciseType,
          'primary': primary,
          'secondary': secondary,
          'videolink': videolink,
        }).then((value) {
          String exerciseId = value.id; // Retrieve the generated document ID
          value.update(
              {'id': exerciseId}); // Update the document with the 'id' field
          _nameController.clear();
          _typeController.clear();
          _primaryController.clear();
          _secondaryController.clear();
          _urlController.clear();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exercise Created'),
                content: Text('The exercise has been created successfully.'),
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
        }).catchError((error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('An error occurred while adding the exercise.'),
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
        });
      }
    }

    AlertDialog alert = AlertDialog(
      key: _formKey,
      backgroundColor: Colors.grey[850],
      title: Text(
        'Add Variation Movement',
        style: TextStyle(color: Colors.green),
      ),
      content: Container(
        width: 450,
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Colors.grey[850],
              ),
              width: 350,
              height: 40,
              child: TextFormField(
                controller: _nameController,
                onChanged: (value) {
                  name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Exercise Name',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exercise Type',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    'Primary Muscle',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    'Secondary Muscle',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.grey[850],
                    ),
                    width: 190,
                    height: 33,
                    child: TextFormField(
                      controller: _typeController,
                      onChanged: (value) {
                        exerciseType = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'None',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter exercise type';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.grey[850],
                    ),
                    width: 190,
                    height: 33,
                    child: TextFormField(
                      controller: _primaryController,
                      onChanged: (value) {
                        primary = value;
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'None',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_down))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the primary exercise ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.grey[850],
                    ),
                    width: 190,
                    height: 33,
                    child: TextFormField(
                      controller: _secondaryController,
                      onChanged: (value) {
                        secondary = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'None',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the secondary exercise';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Exercise URL',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Colors.green,
              ),
              width: 300,
              height: 40,
              child: TextFormField(
                controller: _urlController,
                onChanged: (value) {
                  videolink = value;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'YouTube,etc.',
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.youtube_searched_for)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter The URL';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Instructions",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.grey[850],
                    ),
                    width: 580,
                    height: 130,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter some information for your athletes',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            )),
        SizedBox(
          width: 450,
        ),
        TextButton(
            onPressed: () {
              _nameController.clear();
              _typeController.clear();
              _primaryController.clear();
              _secondaryController.clear();
              _urlController.clear();

              FirebaseFirestore.instance.collection('exerciseLibrary').add({
                'coachId': coachId,
                'name': name,
                'exerciseType': exerciseType,
                'primary': primary,
                'secondary': secondary,
                'videolink': videolink,
              }).then((value) {
                String exerciseId =
                    value.id; // Retrieve the generated document ID
                value.update({'id': exerciseId});
              });
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.green),
            )),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
