import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                onPressed: () => exerciseProvider.addDay(blockIndex),
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

  WorkoutCard(
      {required this.blockIndex,
      required this.dayIndex,
      required this.workoutIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) {
        var workout = exerciseProvider
            .blocks[blockIndex].days[dayIndex].workouts[workoutIndex];
        return Card(
          color: Colors.blue,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'workout name',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: workout.sets.length,
                itemBuilder: (ctx, index) => SetCard(
                    blockIndex: blockIndex,
                    dayIndex: dayIndex,
                    workoutIndex: workoutIndex,
                    setIndex: index),
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
  final int blockIndex;
  final int dayIndex;
  final int workoutIndex;
  final int setIndex;

  SetCard(
      {required this.blockIndex,
      required this.dayIndex,
      required this.workoutIndex,
      required this.setIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
      builder: (ctx, exerciseProvider, _) {
        var set = exerciseProvider.blocks[blockIndex].days[dayIndex]
            .workouts[workoutIndex].sets[setIndex];
        return Card(
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
        );
      },
    );
  }
}
