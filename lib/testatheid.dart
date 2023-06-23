import 'package:flutter/material.dart';
import 'package:web_dashboard/models/Athlete.dart';

class ProfilePage extends StatelessWidget {
  final Athlete athlete;

  ProfilePage({required this.athlete});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${athlete.firstName} ${athlete.lastName}'),
            Text('Bench: ${athlete.bench}'),
            Text('Deadlift: ${athlete.deadlift}'),
            Text('Squat: ${athlete.squat}'),
            Text('Email: ${athlete.email}'),
          ],
        ),
      ),
    );
  }
}
