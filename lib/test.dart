import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Athlete.dart';
import 'package:web_dashboard/models/Coach.dart';
import 'package:web_dashboard/models/Program.dart';
import 'package:web_dashboard/models/block.dart';
import 'package:web_dashboard/models/createprogrammodels.dart';
import 'package:web_dashboard/providers/ProgramDataProvider.dart';
import 'package:web_dashboard/services/block_service.dart';
import 'package:web_dashboard/services/day_service.dart';

import 'package:web_dashboard/services/exercise_service.dart';
import 'package:web_dashboard/services/program_service.dart';
import 'package:web_dashboard/services/sets_service.dart';
import 'package:web_dashboard/services/userservice.dart';
import 'package:web_dashboard/services/workout_service.dart';

import 'models/exercise.dart';

class ProgramScreen extends StatelessWidget {
  final TextEditingController programNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = context.read<ExerciseProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Program Screen'),
      ),
      body: Column(
        children: [
          StreamBuilder<List<Athlete>>(
            stream: context
                .read<UserService>()
                .getAthletes(context.read<CoachProvider>().getcoach().id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text('Program Name'),
                    TextFormField(
                      controller: programNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter program name',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Choose an athlete'),
                    DropdownButton<String>(
                      value: snapshot.data!
                              .map((athlete) => athlete.id)
                              .contains(
                                  context.watch<ExerciseProvider>().athleteId)
                          ? context.watch<ExerciseProvider>().athleteId
                          : null,
                      hint: Text('Please choose an athlete'),
                      isExpanded: true,
                      items: snapshot.data!
                          .map<DropdownMenuItem<String>>((Athlete athlete) {
                        return DropdownMenuItem<String>(
                          value: athlete.id,
                          child:
                              Text(athlete.firstName + ' ' + athlete.lastName),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          context
                              .read<ExerciseProvider>()
                              .setAthleteId(newValue);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<ExerciseProvider>(
              builder: (context, exerciseProvider, _) => ListView.builder(
                itemCount: exerciseProvider.blocks.length,
                itemBuilder: (ctx, index) => BlockCard(blockIndex: index),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: context.read<ExerciseProvider>().addBlock,
            child: Icon(Icons.add),
            tooltip: 'Add Block',
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              try {
                String programName = programNameController.text;
                String? athleteId = exerciseProvider.athleteId;

                Program program = Program(
                  coachId: context.read<CoachProvider>().getcoach().id,
                  name: programName,
                  athleteId: athleteId,
                  // Add other relevant data to the program object
                );

                String programId =
                    await context.read<ProgramService>().addProgram(program);

                context.read<ProgramDataProvider>().programId = programId;
                // Perform any other actions or navigation
                // ...
              } catch (e) {
                print('Error when adding program: $e');
              }
            },
            child: Icon(Icons.check),
            tooltip: 'Send Program',
          ),
        ],
      ),
    );
  }
}

class BlockCard extends StatelessWidget {
  final int blockIndex;
  final TextEditingController blockNameController = TextEditingController();

  BlockCard({required this.blockIndex});

  @override
  Widget build(BuildContext context) {
    final exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);

    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) {
        var block = exerciseProvider.blocks[blockIndex];
        return Card(
          color: Colors.yellow,
          child: Column(
            children: [
              Text('Block'),
              TextFormField(
                controller: blockNameController,
                decoration: InputDecoration(
                  hintText: 'Enter block name',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: block.days.length,
                itemBuilder: (ctx, index) =>
                    DayCard(blockIndex: blockIndex, dayIndex: index),
              ),
              ElevatedButton(
                onPressed: () async {
                  Block_p newBlock = Block_p(
                    id: Uuid().v4(), // Create a v4 UUID here.
                    name: blockNameController.text,
                    programId: exerciseProvider.athleteId,
                  );
                  exerciseProvider.addBlockId(blockIndex, newBlock.id!);
                  exerciseProvider.addDay(blockIndex, Uuid().v4());

                  // Here we add the block to Firestore
                  String blockId = await context.read<BlockService>().addBlock(
                      context.read<ProgramDataProvider>().programId, newBlock);

                  print(
                      'Added block with id $blockId to Firestore'); // Optional: Print the ID of the block added to Firestore for debugging purposes.
                },
                child: Text('Add Day'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildTextFormField(String? labelText) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
    ),
  );
}

class DayCard extends StatelessWidget {
  final int blockIndex;
  final int dayIndex;

  DayCard({required this.blockIndex, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, _) {
        var day = exerciseProvider.blocks[blockIndex].days[dayIndex];
        return Card(
          color: Colors.green,
          child: Column(
            children: [
              Text('Day ${dayIndex + 1}'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: day.workouts.length,
                itemBuilder: (ctx, index) => WorkoutCard(
                    blockIndex: blockIndex,
                    dayIndex: dayIndex,
                    workoutIndex: index),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? blockId = exerciseProvider.blocks[blockIndex].id;
                  if (blockId != null) {
                    Workout_p newWorkout = Workout_p(
                      id: Uuid().v1(), // Create a v1 UUID here.
                      dayId: blockId,
                    );
                    exerciseProvider.addDayId(
                        blockIndex, dayIndex, newWorkout.id!);
                    exerciseProvider.addWorkout(
                        blockIndex, dayIndex, newWorkout);

                    // Here we add the workout to Firestore

                    print(
                        'Added workout with id $newWorkout.id to Firestore'); // Optional: Print the ID of the workout added to Firestore for debugging purposes.
                  } else {
                    print('Block ID is null. Could not add Workout.');
                  }
                },
                child: Text('Add Workout'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final int blockIndex;
  final int dayIndex;
  final int workoutIndex;

  WorkoutCard({
    required this.blockIndex,
    required this.dayIndex,
    required this.workoutIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Access the WorkoutService instance
    final workoutService = Provider.of<WorkoutService>(context, listen: false);
    // Access the ExerciseProvider instance
    final exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);

    return FutureBuilder<List<Exercise>>(
      future: context
          .read<ExerciseService>()
          .getExercisesForCoach(context.read<CoachProvider>().getcoach().id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        return Consumer<ExerciseProvider>(
          builder: (context, exerciseProvider, _) {
            var selectedWorkout = exerciseProvider
                .blocks[blockIndex].days[dayIndex].workouts[workoutIndex];

            return Card(
              color: Colors.blue,
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedWorkout.selectedExercise == null ||
                            snapshot.data!
                                    .where((exercise) =>
                                        exercise.name ==
                                        selectedWorkout.selectedExercise)
                                    .length ==
                                0
                        ? null
                        : selectedWorkout.selectedExercise,
                    hint: Text('Please choose a workout'),
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((Exercise exercise) {
                      return DropdownMenuItem<String>(
                        value: exercise.name,
                        child: Text(exercise.name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        final selectedExercise = snapshot.data!.firstWhere(
                          (exercise) => exercise.name == newValue,
                          orElse: () {
                            throw Exception(
                                'No exercise with name $newValue found.');
                          },
                        );
                        selectedWorkout.setSelectedExercise(
                            selectedExercise.name, selectedExercise.id);
                        exerciseProvider
                            .notifyListeners(); // Notify listeners to update the UI
                      }
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedWorkout.sets.length,
                    itemBuilder: (ctx, index) => SetCard(
                      blockIndex: blockIndex,
                      set: selectedWorkout.sets[index],
                      dayIndex: dayIndex,
                      workoutIndex: workoutIndex,
                      setIndex: index,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Create a new set and add it to the selectedWorkout
                      setExersice_p newSet = setExersice_p(
                        id: Uuid().v1(),
                        reps: '',
                        intensity: '',
                        notes: '',
                      );
                      selectedWorkout.addSet(
                          newSet); // You need to implement this method inside the Workout_p class

                      exerciseProvider.blocks[blockIndex].days[dayIndex]
                          .workouts[workoutIndex]
                          .addSet(newSet);

                      // Update the Workout in Firestore
                      workoutService.updateWorkout(
                          selectedWorkout); // You need to ensure that the Workout class (and its toJson method) supports saving sets

                      // Notify listeners to update the UI
                    },
                    child: Text('Add Set'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class SetCard extends StatelessWidget {
  final setExersice_p set;
  final int blockIndex;
  final int dayIndex;
  final int workoutIndex;
  final int setIndex;

  SetCard({
    required this.blockIndex,
    required this.dayIndex,
    required this.workoutIndex,
    required this.set,
    required this.setIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Column(
        children: [
          buildTextFormField('Reps', set.reps),
          buildTextFormField('Intensity', set.intensity),
          buildTextFormField('Notes', set.notes),
          ElevatedButton(
            onPressed: () async {
              String? athleteId = context.read<ExerciseProvider>().athleteId;
              // Here, instead of getting the workoutId from the WorkoutService,
              // you could get it directly from the Workout object that is associated with this SetCard
              String? workoutId = set.workoutId;
              try {
                await context
                    .read<SetsService>()
                    .addSet(athleteId, workoutId, set);
                print("Set added to Firestore");
              } catch (e) {
                print("Failed to add set: $e");
              }
            },
            child: Text('Save Set'),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(String labelText, String? initialValue) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      initialValue: initialValue,
      onChanged: (value) {
        if (labelText == 'Reps') {
          set.reps = value;
        } else if (labelText == 'Intensity') {
          set.intensity = value;
        } else if (labelText == 'Notes') {
          set.notes = value;
        }
      },
    );
  }
}
