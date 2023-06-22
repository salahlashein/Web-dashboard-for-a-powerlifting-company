import 'package:flutter/material.dart';

class ProgramDataProvider with ChangeNotifier {
  String _programId = '';
  String? _blockId;

  String? get blockId => _blockId;

  void setBlockId(String? value) {
    _blockId = value;
    notifyListeners(); // to notify all listeners about the change
  }

  set programId(String newProgramId) {
    _programId = newProgramId;
    notifyListeners();
  }

  String get programId => _programId;
}
