import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../main.dart';
import '../../../utils/get_user_details.dart';

googleSignIn(Map location) async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    final listenersData =
        await fireStore.collection('listeners').doc(userId()).get();
    if (!listenersData.exists) {
      await fireStore.collection('listeners').doc(userId()).set({
        'profileUrl': userCredential.user!.photoURL ??
            'https://firebasestorage.googleapis.com/v0/b/muzik-c6b63.appspot.com/o/defaultImages%2Fprofile%2Fboy_profile.png?alt=media&token=e24891e5-4711-4d55-a1ea-097253247e8e',
        'name': userCredential.user!.displayName ?? 'Anonymous',
        'email': userCredential.user?.email ?? 'mail@website.com',
        'fcmToken': '',
        'gender': 'male',
        'latitude': location['latitude'] ?? 26.8255886,
        'longitude': location['longitude'] ?? 75.7923313,
        'dateOfBirth': DateTime.now(),
        'accountCreatedDate': DateTime.now(),
        'lastOnline': DateTime.now(),
        'phone': userCredential.user!.phoneNumber.toString(),
      });
    }
  } catch (error) {
    log('error while google logIn: ${error.toString()}');
  }
}
