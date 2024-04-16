import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class GenderSelectionProvider with ChangeNotifier {
  Gender _selectedGender = Gender.male;

  setGender(Gender gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  setDBGender(Gender gender) {
    _selectedGender = gender;
  }

  get selectedGender => _selectedGender;
}
