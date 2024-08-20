import 'package:android_muzik/providers/loading_provider.dart';
import 'package:android_muzik/providers/location_provider.dart';
import 'package:android_muzik/providers/music_provider.dart';
import 'package:android_muzik/providers/spotify_provider.dart';
import 'package:android_muzik/screens/profile_authentication_screen/profile_authentication_screen.dart';
import 'package:android_muzik/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:android_muzik/screens/profile_screen/providers/profile_provider.dart';
import 'package:android_muzik/screens/welcome_screen/welcome_screen.dart';
import 'package:android_muzik/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/styling.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseStorage = FirebaseStorage.instance;
final fireStore = FirebaseFirestore.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoadingProvider()),
    ChangeNotifierProvider(create: (context) => LocationProvider()),
    ChangeNotifierProvider(create: (context) => GenderSelectionProvider()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => MusicProvider()),
    ChangeNotifierProvider(create: (context) => SpotifyProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muzik',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: matteBlackColor),
          useMaterial3: true,
          fontFamily: 'inter'),
      home: AuthService().handleAuth(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthService {
  //Handles Authentication
  handleAuth() {
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const WelcomeScreen();
          } else {
            return const ProfileAuthenticationScreen();
          }
        } else {
          return Scaffold(
            backgroundColor: blackColor,
            body: Center(child: LoadingWidget(color: yellowColor)),
          );
        }
      },
    );
  }
}
