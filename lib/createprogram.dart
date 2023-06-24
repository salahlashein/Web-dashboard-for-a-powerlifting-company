import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Athlete.dart';
import 'package:web_dashboard/models/Coach.dart';

class CardScreen extends StatefulWidget {
  final String? coachId;
  String? selectedAthlete;

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
  final setsCollection = FirebaseFirestore.instance.collection('sets');

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

  Stream<List<Athlete>> getAthletes(String? coachId) {
    final athletesCollection =
        FirebaseFirestore.instance.collection('Athletes');
    final query = athletesCollection.where('coachId', isEqualTo: coachId);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Athlete.fromJson(data);
      }).toList();
    });
  }

  void _showAddAthleteDialog(String programId, String coachId) async {
    // Fetch the athletes when function is called
    List<Athlete> athletes = await getAthletes(coachId).first;
    String? selectedAthleteId;

    // Show dialog with dropdown menu
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Athlete'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedAthleteId,
                items: athletes.map((Athlete athlete) {
                  return DropdownMenuItem<String>(
                    value: athlete.id,
                    child: Text(athlete.firstName + ' ' + athlete.lastName),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAthleteId = newValue;
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Save the selected athlete's ID to Firestore when 'Done' is pressed
                updateAthleteIdForProgram(programId, selectedAthleteId);
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateAthleteIdForProgram(String programId, String? athleteId) {
    return FirebaseFirestore.instance
        .collection('program')
        .doc(programId)
        .update({'athleteId': athleteId});
  }

  Future<void> _showAddSetDialog(String workoutId) async {
    String reps = '';
    String load = '';
    String intensity = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text('Add new set'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  reps = value;
                },
                decoration: InputDecoration(hintText: "Enter reps"),
              ),
              TextField(
                onChanged: (value) {
                  load = value;
                },
                decoration: InputDecoration(hintText: "Enter load"),
              ),
              TextField(
                onChanged: (value) {
                  intensity = value;
                },
                decoration: InputDecoration(hintText: "Enter intensity"),
              ),
            ],
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
                addSet(workoutId, reps, load, intensity);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addSet(
      String workoutId, String reps, String load, String intensity) async {
    var newSet = setsCollection.doc();
    await newSet.set({
      'id': newSet.id,
      'workoutId': workoutId,
      'reps': reps,
      'load': load,
      'intensity': intensity
    });
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

  Stream<List<SetsData>> getSetsForWorkout(String workoutId) {
    final query = setsCollection.where('workoutId', isEqualTo: workoutId);

    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.size == 0) {
        // No documents found, return an empty list
        return [];
      } else {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          var setData = SetsData.fromJson(data);
          print('Set: ${setData.reps}');
          return setData;
        }).toList();
      }
    });
  }

  Future<void> addProgram(String name) async {
    DocumentReference docRef = await programsCollection.add({
      'name': name,
      'athleteId': '',
      'coachId':
          Provider.of<CoachProvider>(context, listen: false).getcoach().id,
      // Add other necessary fields here.
    });

    await docRef.update({'id': docRef.id});
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

  Stream<List<WorkoutData>> getWorkouts(String dayId) {
    final query =
        workoutsCollection.where('dayId', isEqualTo: dayId).snapshots();

    return query.asyncMap((querySnapshot) async {
      final List<WorkoutData> workoutList =
          []; // Declare workoutList with type <WorkoutData>

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final workoutData = WorkoutData.fromJson(data);

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
    });
  }

  Future<String> fetchExerciseName(String exerciseId) async {
    print(
        'Fetching exercise for exerciseId: $exerciseId'); // Added for debugging
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CardData>>(
      stream: getPrograms(
          Provider.of<CoachProvider>(context, listen: false).getcoach().id),
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
                return Card(
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 82, 82, 82),
                    title: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onTap: _showAddProgramDialog,
                  ),
                );
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
                                    // day stream

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
                                                backgroundColor: Color.fromARGB(
                                                    255, 61, 61, 61),
                                                title:
                                                    Text(dayList[index].name),
                                                children: <Widget>[
                                                  // workoutData

                                                  StreamBuilder<
                                                      List<WorkoutData>>(
                                                    stream: getWorkouts(dayId),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                List<
                                                                    WorkoutData>>
                                                            snapshot) {
                                                      if (snapshot.hasError) {
                                                        print(
                                                            'Error in getWorkouts: ${snapshot.error}');
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator();
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
                                                            final workoutId =
                                                                workoutList[
                                                                        index]
                                                                    .id;

                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  ExpansionTile(
                                                                backgroundColor:
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            41,
                                                                            41,
                                                                            41),
                                                                title: Text(
                                                                    workoutList[index]
                                                                            .exerciseName ??
                                                                        ''),
                                                                children: <Widget>[
                                                                  StreamBuilder<
                                                                      List<
                                                                          SetsData>>(
                                                                    stream: getSetsForWorkout(
                                                                        workoutId),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        AsyncSnapshot<List<SetsData>>
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Text(
                                                                            'Error: ${snapshot.error}');
                                                                      } else if (snapshot
                                                                              .connectionState ==
                                                                          ConnectionState
                                                                              .waiting) {
                                                                        return CircularProgressIndicator();
                                                                      } else {
                                                                        final setsList =
                                                                            snapshot.data ??
                                                                                [];

                                                                        return ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              setsList.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return ListTile(
                                                                                title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Text("Reps: ${setsList[index].reps}"),
                                                                              Text("Load: ${setsList[index].load}"),
                                                                              Text("Intensity: ${setsList[index].intensity}")
                                                                            ]));
                                                                          },
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed: () =>
                                                                        _showAddSetDialog(
                                                                            workoutId),
                                                                    child: Text(
                                                                        'Add Set'),
                                                                  ),
                                                                ],
                                                              ),
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
                      ElevatedButton(
                        onPressed: () => _showAddAthleteDialog(
                            programId, 'ZpwXWSQI4qPmslV8TNRtSWzwKLa2'),
                        child: Text('Add Athlete'),
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

  WorkoutData({required this.exerciseId, required this.id, this.exerciseName});

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
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

class SetsData {
  final String id;
  final String reps;
  final String load;
  final String intensity;
  final String notes;

  SetsData({
    required this.id,
    required this.reps,
    required this.load,
    required this.intensity,
    required this.notes,
  });

  factory SetsData.fromJson(Map<String, dynamic> json) {
    return SetsData(
      id: json['id'] ?? '',
      reps: json['reps'] ?? '',
      load: json['load'] ?? '',
      intensity: json['intensity'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reps': reps,
      'load': load,
      'intensity': intensity,
      'notes': notes,
    };
  }
}
