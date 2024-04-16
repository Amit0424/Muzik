import 'package:android_muzik/screens/profile_screen/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel _profileModelMap = ProfileModel(
    email: '',
    phone: '',
    profileUrl: '',
    name: '',
    dateOfBirth: '',
    accountCreatedDate: '',
    lastOnline: '',
    latitude: 0.00,
    longitude: 0.00,
    fcmToken: '',
    gender: Gender.male,
  );

  setProfileModelMap(ProfileModel profileModelMap) {
    _profileModelMap = profileModelMap;
  }

  ProfileModel get profileModelMap => _profileModelMap;
}
