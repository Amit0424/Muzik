import 'package:android_muzik/providers/loading_provider.dart';
import 'package:android_muzik/screens/profile_screen/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/styling.dart';
import '../../profile_screen/models/profile_model.dart';
import '../../profile_screen/providers/gender_selection_provider.dart';

class GenderSelectionWidget extends StatelessWidget {
  const GenderSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<Gender>(
          activeColor: redColor,
          value: Gender.male,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
            if (genderSelectionProvider.selectedGender !=
                profileProvider.profileModelMap.gender) {
              loadingProvider.setIsAllFieldCompleted(true);
            } else {
              loadingProvider.setIsAllFieldCompleted(false);
            }
          },
        ),
        Text(
          'Male',
          style: TextStyle(color: textHeadingColor),
        ),
        SizedBox(width: screenWidth(context) * 0.06),
        Radio<Gender>(
          activeColor: redColor,
          value: Gender.female,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
            if (genderSelectionProvider.selectedGender !=
                profileProvider.profileModelMap.gender) {
              loadingProvider.setIsAllFieldCompleted(true);
            } else {
              loadingProvider.setIsAllFieldCompleted(false);
            }
          },
        ),
        Text(
          'Female',
          style: TextStyle(color: textHeadingColor),
        ),
        SizedBox(width: screenWidth(context) * 0.06),
        Radio<Gender>(
          activeColor: redColor,
          value: Gender.other,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
            if (genderSelectionProvider.selectedGender !=
                profileProvider.profileModelMap.gender) {
              loadingProvider.setIsAllFieldCompleted(true);
            } else {
              loadingProvider.setIsAllFieldCompleted(false);
            }
          },
        ),
        Text(
          'Other',
          style: TextStyle(color: textHeadingColor),
        ),
      ],
    );
  }
}
