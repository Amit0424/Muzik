// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  Map _profileModelMap = {};
  // late UserCredential _userCredential;

  setProfileModelMap(Map profileModelMap) {
    _profileModelMap = profileModelMap;
  }

  // setUserCredentials(UserCredential userCredential) {
  //   _userCredential = userCredential;
  //   notifyListeners();
  // }

  get profileModelMap => _profileModelMap;
  // get userCredentials => _userCredential;
}
