import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Coach.dart';
import 'package:web_dashboard/services/exercise_service.dart';
import 'package:web_dashboard/services/userservice.dart';

import 'models/exercise.dart';

class ProgramScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) => Scaffold(
        body: ListView.builder(
          itemCount: exerciseProvider.blocks.length,
          itemBuilder: (ctx, index) => BlockCard(blockIndex: index),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: exerciseProvider.addBlock,
          child: Icon(
            Icons.add,
          ),
          tooltip: 'Add block',
        ),
      ),
    );
  }
}

class BlockCard extends StatelessWidget {
  final int blockIndex;

  BlockCard({required this.blockIndex});

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    UserService userService = UserService(); // Make sure it's instantiated
    final coachProvider = Provider.of<CoachProvider>(context);
    final coach = coachProvider.coach;

    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) {
        var block = exerciseProvider.blocks[blockIndex];
        return Card(
          color: Colors.yellow,
          child: Column(
            children: [
              Text('Block'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: block.days.length,
                itemBuilder: (ctx, index) =>
                    DayCard(blockIndex: blockIndex, dayIndex: index),
              ),
              ElevatedButton(
                onPressed: () {
                  exerciseProvider.addDay(blockIndex);
                  print(coach.id);
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

class DayCard extends StatelessWidget {
  final int blockIndex;
  final int dayIndex;

  DayCard({required this.blockIndex, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) {
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
                onPressed: () => exerciseProvider.addWorkout(
                  blockIndex,
                  dayIndex,
                ),
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
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    UserService userService = UserService(); // Make sure it's instantiated
    final coachProvider = Provider.of<CoachProvider>(context);
    final coach = coachProvider.coach;

    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) => Card(
        color: Colors.blue,
        child: Column(
          children: [
            FutureBuilder<List<Exercise>>(
              future: Exercise_service().getExercisesForCoach(coach.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Exercise> exercises = snapshot.data ?? [];

                  return DropdownButton<String>(
                    value: exerciseProvider.currentWorkout,
                    items: exercises.map<DropdownMenuItem<String>>((exercise) {
                      return DropdownMenuItem<String>(
                        value: exercise.name,
                        child: Text(exercise.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        exerciseProvider.updateWorkout(value!),
                  );
                }
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: exerciseProvider.sets.length,
              itemBuilder: (ctx, index) => SetCard(),
            ),
            ElevatedButton(
              onPressed: () {
                print(coach.id);
                exerciseProvider.addSet(blockIndex, dayIndex, workoutIndex);
              },
              child: Text('Add Set'),
            ),
          ],
        ),
      ),
    );
  }
}

class SetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) => Card(
        color: Colors.red,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Reps',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Intensity',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Notes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
