import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      'coachId': widget.coachId,
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

  Future<void> _showAddProgramDialog() async {
    String programName = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
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
                return Card(
                  child: ListTile(
                    tileColor: Colors.black,
                    title: Icon(Icons.add),
                    onTap: _showAddProgramDialog,
                  ),
                );
              } else {
                final programId = cardList[index].id;

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.black,
                        title: Text(cardList[index].name),
                      ),
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

                                return Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        tileColor:
                                            Color.fromARGB(255, 111, 111, 111),
                                        title: Text(blockList[index].name),
                                      ),
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

                                                return Card(
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        tileColor:
                                                            Color.fromARGB(255,
                                                                61, 61, 61),
                                                        title: Text(
                                                            dayList[index]
                                                                .name),
                                                      ),
                                                      FutureBuilder<
                                                          List<WorkoutData>>(
                                                        future:
                                                            getWorkouts(dayId),
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
                                                                snapshot.data ??
                                                                    [];

                                                            return ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  workoutList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      ListTile(
                                                                    tileColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            41,
                                                                            41,
                                                                            41),
                                                                    title: Text(
                                                                        workoutList[index].exerciseName ??
                                                                            ''),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
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
