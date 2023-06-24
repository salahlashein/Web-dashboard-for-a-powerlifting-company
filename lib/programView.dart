import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Athlete.dart';
import 'package:web_dashboard/models/Coach.dart';

class ProgramView extends StatefulWidget {
  final String? coachId;
  String? selectedAthlete;
  final Athlete athlete;

  ProgramView({this.coachId, required this.athlete});

  @override
  _ProgramViewState createState() => _ProgramViewState(athlete: athlete);
}

class _ProgramViewState extends State<ProgramView> {
  final Athlete athlete;
  _ProgramViewState({required this.athlete});

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

  Stream<List<CardData>> getPrograms(String? coachId) {
    final query = programsCollection.where('athleteId', isEqualTo: coachId);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Program updates  ${athlete.firstName}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF09b599),
      ),
      body: StreamBuilder<List<CardData>>(
        stream: getPrograms(athlete.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<CardData>> snapshot) {
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
                  return Card();
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
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 61, 61, 61),
                                                  title:
                                                      Text(dayList[index].name),
                                                  children: <Widget>[
                                                    // workoutData

                                                    StreamBuilder<
                                                        List<WorkoutData>>(
                                                      stream:
                                                          getWorkouts(dayId),
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
                                                              final workoutId =
                                                                  workoutList[
                                                                          index]
                                                                      .id;

                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    ExpansionTile(
                                                                  backgroundColor:
                                                                      Color.fromARGB(
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
                                                                        } else if (snapshot.connectionState ==
                                                                            ConnectionState.waiting) {
                                                                          return CircularProgressIndicator();
                                                                        } else {
                                                                          final setsList =
                                                                              snapshot.data ?? [];

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
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
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
      ),
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
