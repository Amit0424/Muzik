import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../providers/loading_provider.dart';
import '../../../widgets/custom_snackbar.dart';

final RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp passwordRegExp =
    RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

emailSignUp(BuildContext context, String email, String password) async {
  final LoadingProvider loadingProvider =
      Provider.of<LoadingProvider>(context, listen: false);

  if (!emailRegExp.hasMatch(email) && !emailRegExp.hasMatch(password)) {
    showingSnackBar(context, 'Try Again!', 'Enter valid email and password');
  } else if (!emailRegExp.hasMatch(email) || email.isEmpty) {
    showingSnackBar(context, 'Try Again!', 'Enter valid email');
  } else if (!passwordRegExp.hasMatch(password) || password.isEmpty) {
    showingSnackBar(context, 'Try Again!', 'Enter valid password');
  }

  try {
    loadingProvider.isRegister
        ? await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
        : await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
  } catch (error) {
    log('Error while login: $error');
    showingSnackBar(context, 'Try Again!', 'Invalid Credentials');
  }
}

showingSnackBar(BuildContext context, String heading, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: CustomSnackbar(
        heading: heading,
        content: content,
      ),
    ),
  );
  return;
}
