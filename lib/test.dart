import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/services/program_service.dart';
import 'package:web_dashboard/services/userservice.dart';

import 'models/Program.dart';

class AddProgramWidget extends StatefulWidget {
  @override
  _AddProgramWidgetState createState() => _AddProgramWidgetState();
}

class _AddProgramWidgetState extends State<AddProgramWidget> {
  String _coachName = '';
  String _coachID = '';
  final ProgramService _programService = ProgramService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _coachIdController = TextEditingController();
  final TextEditingController _athleteIdController = TextEditingController();
  final TextEditingController _programIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCoachName();
  }

  Future<void> _loadCoachName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String coachId = user.uid;
        String coachName = await UserService().getCoachName(coachId);
        setState(() {
          _coachName = coachName;
          _coachID = coachId;
        });
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _coachIdController.dispose();
    _athleteIdController.dispose();
    _programIdController.dispose();
    super.dispose();
  }

  void _addProgram() {
    String name = _nameController.text;
    String coachId = _coachIdController.text;
    String athleteId = _athleteIdController.text;
    String programId = _programIdController.text;

    Program newProgram = Program(
      id: programId,
      name: name,
      coachId: coachId,
      athleteId: athleteId,
    );

    _programService.deleteProgram(newProgram);
    // Handle success or error cases when adding a program
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Program Name',
          ),
        ),
        TextField(
          controller: _coachIdController,
          decoration: InputDecoration(
            labelText: 'Coach ID',
          ),
        ),
        TextField(
          controller: _athleteIdController,
          decoration: InputDecoration(
            labelText: 'Athlete ID',
          ),
        ),
        TextField(
          controller: _programIdController,
          decoration: InputDecoration(
            labelText: 'program ID',
          ),
        ),
        ElevatedButton(
          onPressed: _addProgram,
          child: Text('Add Program'),
        ),
      ],
    );
  }
}

class _coachName {}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Program'),
      ),
      body: AddProgramWidget(),
    );
  }
}
