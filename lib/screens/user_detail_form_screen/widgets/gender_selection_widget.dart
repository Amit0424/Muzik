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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<Gender>(
          activeColor: redColor,
          value: Gender.male,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
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
