import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

String _userId = '';
String userId() {
  if (firebaseAuth.currentUser?.uid != null) {
    if (_userId == '') {
      _userId = firebaseAuth.currentUser!.uid;
    }
    return _userId;
  }
  return _userId;
}

void resetUserId(String id) {
  _userId = id;
  log(_userId);
}

String getCurrentUserEmail() {
  final User? user = firebaseAuth.currentUser;

  if (user != null) {
    String? email = user.email;
    return email ?? 'mail@website.com';
  } else {
    return 'mail@website.com';
  }
}
