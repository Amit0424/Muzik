import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../main.dart';
import '../../utils/get_user_details.dart';
import '../../widgets/loading_widget.dart';
import '../profile_screen/models/profile_model.dart';
import '../profile_screen/providers/gender_selection_provider.dart';
import '../profile_screen/providers/profile_provider.dart';
import '../songs_screen/songs_screen.dart';
import '../user_detail_form_screen/user_detail_form_screen.dart';

class ProfileAuthenticationScreen extends StatelessWidget {
  const ProfileAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context, listen: false);
    return StreamBuilder(
        stream: fireStore.collection('listeners').doc(userId()).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;

            if (documentSnapshot.exists) {
              ProfileModel profileModel =
                  ProfileModel.fromDocument(documentSnapshot);
              profileProvider.setProfileModelMap(profileModel);
              genderSelectionProvider
                  .setDBGender(profileProvider.profileModelMap.gender);
              return const SongsScreen();
            }
            return const UserDetailFormScreen(buttonName: 'Save');
          }
          return Scaffold(
            backgroundColor: blackColor,
            body: Center(child: LoadingWidget(color: redColor)),
          );
        });
  }
}
