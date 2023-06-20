import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/exercise.dart';
import 'package:web_dashboard/models/Coach.dart';
import 'package:web_dashboard/models/set.dart';
import 'package:web_dashboard/services/exercise_service.dart';
import 'package:web_dashboard/services/userservice.dart';

import 'models/exercise.dart';

class ProgramScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, _) => ListView.builder(
          itemCount: exerciseProvider.blocks.length,
          itemBuilder: (ctx, index) => BlockCard(blockIndex: index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: context.read<ExerciseProvider>().addBlock,
        child: Icon(Icons.add),
        tooltip: 'Add block',
      ),
    );
  }
}

class BlockCard extends StatelessWidget {
  final int blockIndex;

  BlockCard({required this.blockIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) {
        var block = exerciseProvider.blocks[blockIndex];
        return Card(
          color: Colors.yellow,
          child: Column(
            children: [
              Text('Block'),
              buildTextFormField('Name'),
              buildTextFormField('Description'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: block.days.length,
                itemBuilder: (ctx, index) =>
                    DayCard(blockIndex: blockIndex, dayIndex: index),
              ),
              ElevatedButton(
                onPressed: () => exerciseProvider.addDay(blockIndex),
                child: Text('Add Day'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTextFormField(String labelText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
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
                onPressed: () =>
                    exerciseProvider.addWorkout(blockIndex, dayIndex),
                child: Text('Add Workout'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// The WorkoutCard and SetCard widgets should follow the same pattern as DayCard
class WorkoutCard extends StatelessWidget {
  final int blockIndex;
  final int dayIndex;
  final int workoutIndex;

  WorkoutCard(
      {required this.blockIndex,
      required this.dayIndex,
      required this.workoutIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, _) {
        var workout = exerciseProvider
            .blocks[blockIndex].days[dayIndex].workouts[workoutIndex];
        return Card(
          color: Colors.blue,
          child: Column(
            children: [
              DropdownButton<String>(
                value: workout.selectedExercise,
                hint: Text('Please choose a workout'),
                items: exerciseProvider.exercises
                    .map<DropdownMenuItem<String>>((Exercise exercise) {
                  return DropdownMenuItem<String>(
                    value: exercise.name,
                    child: Text(exercise.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    workout.selectedExercise = newValue;
                  }
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: workout.sets.length,
                itemBuilder: (ctx, index) => SetCard(
                  set: workout.sets[index] as setExersice,
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    exerciseProvider.addSet(blockIndex, dayIndex, workoutIndex),
                child: Text('Add Set'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SetCard extends StatelessWidget {
  final setExersice set;

  SetCard({required this.set});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Column(
        children: [
          buildTextFormField('Reps', set.reps),
          buildTextFormField('Intensity', set.intensity),
          buildTextFormField('Notes', set.notes),
        ],
      ),
    );
  }

  Widget buildTextFormField(String labelText, String initialValue) {
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
