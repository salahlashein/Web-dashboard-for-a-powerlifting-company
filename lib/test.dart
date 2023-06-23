import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Coach.dart';

class CardScreen extends StatefulWidget {
  final String? coachId;

  CardScreen({this.coachId});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final programsCollection = FirebaseFirestore.instance.collection('program');
  final blocksCollection = FirebaseFirestore.instance.collection('block');
  final daysCollection = FirebaseFirestore.instance.collection('day');
  final workoutsCollection = FirebaseFirestore.instance.collection('workout');
  final exerciseLibraryCollection =
      FirebaseFirestore.instance.collection('exerciseLibrary');

  final blockNameController = TextEditingController();
  final dayNameController = TextEditingController();
  String? selectedExercise;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    blockNameController.dispose();
    dayNameController.dispose();
    super.dispose();
  }

  Future<void> addSet(String workoutId, BuildContext context) async {
    final repsController = TextEditingController();
    final intensityController = TextEditingController();
    final loadController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Set'),
          content: Column(
            children: [
              TextField(
                controller: repsController,
                decoration: InputDecoration(hintText: "Reps"),
              ),
              TextField(
                controller: intensityController,
                decoration: InputDecoration(hintText: "Intensity"),
              ),
              TextField(
                controller: loadController,
                decoration: InputDecoration(hintText: "Load"),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Done'),
              onPressed: () {
                final reps = repsController.text;
                final intensity = intensityController.text;
                final load = loadController.text;

                FirebaseFirestore.instance
                    .collection('workouts')
                    .doc(workoutId)
                    .update({
                  'data': FieldValue.arrayUnion([
                    {
                      'reps': reps,
                      'intensity': intensity,
                      'load': load,
                    }
                  ])
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addBlock(String programId, BuildContext context) {
    String blockId = FirebaseFirestore.instance.collection('block').doc().id;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Block'),
          content: TextField(
            controller: blockNameController,
            decoration: InputDecoration(hintText: "Block name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('block')
                    .doc(blockId)
                    .set({
                      'id': blockId, // Store the generated block ID
                      'programId': programId,
                      'name': blockNameController.text,
                      // Add other block details here
                    })
                    .then((value) => print("Block Added"))
                    .catchError(
                        (error) => print("Failed to add block: $error"));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addDay(String blockId) async {
    String dayId = FirebaseFirestore.instance.collection('day').doc().id;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add a new day'),
        content: TextField(
          controller: dayNameController,
          decoration: const InputDecoration(hintText: "Day name"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('day')
                  .doc(dayId)
                  .set({
                    'id': dayId, // Store the generated block ID
                    'blockId': blockId,
                    'name': dayNameController.text,
                    // Add other block details here
                  })
                  .then((value) => print("day Added"))
                  .catchError((error) => print("Failed to add block: $error"));
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void addWorkout(String dayId) async {
    String workoutId =
        FirebaseFirestore.instance.collection('workout').doc().id;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? selectedExercise;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add a new workout'),
              content: StreamBuilder<List<ExerciseData>>(
                stream: getExercises(widget.coachId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ExerciseData>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    final exerciseList = snapshot.data ?? [];

                    return DropdownButton<String>(
                      value: selectedExercise,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedExercise = newValue;
                        });
                      },
                      items: exerciseList.map<DropdownMenuItem<String>>(
                        (ExerciseData exercise) {
                          return DropdownMenuItem<String>(
                            value: exercise.id,
                            child: Text(exercise.name),
                          );
                        },
                      ).toList(),
                    );
                  }
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic to add a workout to the 'workout' collection with the 'dayId' and 'selectedExercise'
                    FirebaseFirestore.instance
                        .collection('workout')
                        .doc(workoutId)
                        .set({
                      'id': workoutId, // Store the generated workout ID
                      'dayId': dayId,
                      'exerciseId': selectedExercise ?? '',
                      // Add other workout details here
                    }).then((value) {
                      print("Workout Added");
                      Navigator.pop(context);
                      setState(() {
                        // Trigger a rebuild by calling setState
                      });
                    }).catchError(
                            (error) => print("Failed to add workout: $error"));
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Stream<List<CardData>> getPrograms(String? coachId) {
    final query = programsCollection.where('coachId', isEqualTo: coachId);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        var cardData = CardData.fromJson(data);
        print(
            'Program: ${cardData.name}'); // Print program name to the terminal
        return cardData;
      }).toList();
    });
  }

  Future<void> addProgram(String name) async {
    await programsCollection.add({
      'name': name,
      'coachId': Provider.of<CoachProvider>(context, listen: false).getcoach(),
      // Add other necessary fields here.
    });
  }

  Stream<List<BlockData>> getBlocks(String programId) {
    final query = blocksCollection.where('programId', isEqualTo: programId);

    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.size == 0) {
        // No documents found, return an empty list
        return [];
      } else {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          var blockData = BlockData.fromJson(data);
          print('Block: ${blockData.name}');
          return blockData;
        }).toList();
      }
    });
  }

  Stream<List<DayData>> getDays(String blockId) {
    final query = daysCollection.where('blockId', isEqualTo: blockId);

    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.size == 0) {
        // No documents found, return an empty list
        return [];
      } else {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          var dayData = DayData.fromJson(data);
          print('Day: ${dayData.name}');
          return dayData;
        }).toList();
      }
    });
  }

  Future<List<WorkoutData>> getWorkouts(String dayId) async {
    final query =
        await workoutsCollection.where('dayId', isEqualTo: dayId).get();

    if (query.size == 0) {
      // No documents found, return an empty list
      return [];
    } else {
      List<WorkoutData> workoutList = [];

      for (var doc in query.docs) {
        final data = doc.data();
        var workoutData = WorkoutData.fromJson(data);

        // Fetch exercise name based on exerciseId
        final exerciseId = workoutData.exerciseId;
        final name = await fetchExerciseName(exerciseId);

        // Update workoutData with exercise name
        workoutData.exerciseName = name;

        workoutList.add(workoutData);
      }

      // Print the list of objects with exercise names
      print('Workout List:');
      workoutList.forEach((workout) {
        print('Exercise Name: ${workout.exerciseName}');
      });

      return workoutList;
    }
  }

  Future<String> fetchExerciseName(String exerciseId) async {
    print('Fetching exercise for dayId: $exerciseId'); // Added for debugging
    final docSnapshot = await exerciseLibraryCollection.doc(exerciseId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final exerciseName = data?['name'] as String? ?? '';
      print(exerciseName);
      return exerciseName;
    } else {
      return '';
    }
  }

  Stream<List<ExerciseData>> getExercises(String? coachId) {
    final query =
        exerciseLibraryCollection.where('coachId', isEqualTo: coachId);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        var exerciseData = ExerciseData.fromJson(data);
        print(
            'Exercise: ${exerciseData.name}'); // Print exercise name to the terminal
        return exerciseData;
      }).toList();
    });
  }

  Future<void> _showAddProgramDialog() async {
    String programName = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text('Add new program'),
          content: TextField(
            onChanged: (value) {
              programName = value;
            },
            decoration: InputDecoration(hintText: "Enter program name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                addProgram(programName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return StreamBuilder<List<CardData>>(
      stream: getPrograms(widget.coachId),
      builder: (BuildContext context, AsyncSnapshot<List<CardData>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final cardList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: cardList.length + 1,
            itemBuilder: (context, index) {
              if (index == cardList.length) {
                // ... Your code for adding a program ...
              } else {
                final programId = cardList[index].id;

                return Card(
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.black,
                    backgroundColor: Colors.black,
                    title: Text(cardList[index].name),
                    children: <Widget>[
                      StreamBuilder<List<BlockData>>(
                        stream: getBlocks(programId),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<BlockData>> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            final blockList = snapshot.data ?? [];

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: blockList.length,
                              itemBuilder: (context, index) {
                                final blockId = blockList[index].id;

                                return ExpansionTile(
                                  backgroundColor:
                                      Color.fromARGB(255, 111, 111, 111),
                                  title: Text(blockList[index].name),
                                  children: <Widget>[
                                    StreamBuilder<List<DayData>>(
                                      stream: getDays(blockId),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<DayData>>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else {
                                          final dayList = snapshot.data ?? [];

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: dayList.length,
                                            itemBuilder: (context, index) {
                                              final dayId = dayList[index].id;

                                              return ExpansionTile(
                                                backgroundColor: Colors.grey,
                                                title:
                                                    Text(dayList[index].name),
                                                children: <Widget>[
                                                  FutureBuilder<
                                                      List<WorkoutData>>(
                                                    future: getWorkouts(dayId),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                List<
                                                                    WorkoutData>>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        print(
                                                            'Error in getWorkouts: ${snapshot.error}');
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else {
                                                        final workoutList =
                                                            snapshot.data ?? [];

                                                        return ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: workoutList
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final workout =
                                                                workoutList[
                                                                    index];
                                                            return ExpansionTile(
                                                              title: Text(workout
                                                                      .exerciseName ??
                                                                  ''),
                                                              children: workout
                                                                  .data
                                                                  .map(
                                                                      (dataMap) {
                                                                final load =
                                                                    dataMap['load']
                                                                        as String;
                                                                final intensity =
                                                                    dataMap['intensity']
                                                                        as String;
                                                                final reps =
                                                                    dataMap['reps']
                                                                        as int;
                                                                return ListTile(
                                                                  title: Text(
                                                                      'Load: $load, Intensity: $intensity, Reps: $reps'),
                                                                );
                                                              }).toList(),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        addWorkout(dayId),
                                                    child: Text('Add Workout'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () => addDay(blockId),
                                      child: Text('Add Day'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                      ElevatedButton(
                        onPressed: () => addBlock(programId, context),
                        child: Text('Add Block'),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class CardData {
  final String id;
  final String name;

  CardData({required this.name, required this.id});

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class BlockData {
  final String id;
  final String name;

  BlockData({required this.name, required this.id});

  factory BlockData.fromJson(Map<String, dynamic> json) {
    return BlockData(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class DayData {
  final String id;
  final String name;

  DayData({required this.name, required this.id});

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class WorkoutData {
  final String id;
  final String exerciseId;
  String? exerciseName;
  final List<Map<String, dynamic>> data;

  WorkoutData(
      {required this.exerciseId,
      required this.id,
      this.exerciseName,
      required this.data});

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      data: List<Map<String, dynamic>>.from(json['data'] as List),
    );
  }
}

class ExerciseData {
  final String id;
  final String name;

  ExerciseData({
    required this.id,
    required this.name,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
