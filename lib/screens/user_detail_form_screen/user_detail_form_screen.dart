import 'dart:developer';

import 'package:android_muzik/screens/user_detail_form_screen/widgets/gender_selection_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../main.dart';
import '../../providers/loading_provider.dart';
import '../../providers/location_provider.dart';
import '../../utils/get_user_details.dart';
import '../../utils/take_image.dart';
import '../../widgets/loading_widget.dart';
import '../profile_screen/models/profile_model.dart';
import '../profile_screen/providers/gender_selection_provider.dart';
import '../profile_screen/providers/profile_provider.dart';

class UserDetailFormScreen extends StatefulWidget {
  const UserDetailFormScreen({super.key, required this.buttonName});
  final String buttonName;

  @override
  State<UserDetailFormScreen> createState() => _UserDetailFormScreenState();
}

class _UserDetailFormScreenState extends State<UserDetailFormScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? pickedDate = DateTime.now();
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    storeData();
    _emailController.text = getCurrentUserEmail();
  }

  storeData() async {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context, listen: false);
    final profile = profileProvider.profileModelMap;
    final listenersData =
        await fireStore.collection('listeners').doc(userId()).get();
    if (listenersData.exists) {
      _nameController.text = profile['name'];
      _phoneController.text = profile['phone'];
      _dateController.text = profile['dateOfBirth'];
      genderSelectionProvider.setGender(profile['gender']);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    Gender gender = genderSelectionProvider.selectedGender;
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          'Profile',
          style: appBarTitleStyle(context),
        ),
        actions: widget.buttonName == 'Update'
            ? [
                IconButton(
                    onPressed: () async {
                      if (loadingProvider.isGoogleLogin) {
                        await GoogleSignIn().signOut();
                      } else {
                        await firebaseAuth.signOut();
                      }
                    },
                    icon: Icon(
                      Icons.logout,
                      color: iconColor,
                    ))
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/pngs/${gender == Gender.female ? 'girl' : gender == Gender.male ? 'boy' : 'emoji'}_profile.png'),
                    radius: screenHeight(context) * 0.07,
                    backgroundColor: Colors.transparent,
                    foregroundImage: profileImageUrl != ''
                        ? CachedNetworkImageProvider(profileImageUrl)
                        : profileProvider.profileModelMap['profileUrl'] !=
                                    null &&
                                profileProvider.profileModelMap['profileUrl'] !=
                                    ''
                            ? CachedNetworkImageProvider(
                                profileProvider.profileModelMap['profileUrl'])
                            : null,
                  ),
                  loadingProvider.isImageUploading
                      ? Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: LoadingWidget(color: matteBlackColor),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              TextButton(
                  onPressed: () async {
                    loadingProvider.setIsImageUploading(true);
                    profileImageUrl = await takeImage(ImageSource.gallery);

                    loadingProvider.setIsImageUploading(false);
                  },
                  child: Text(
                    'Change photo',
                    style: TextStyle(
                      color: darkYellowColor,
                    ),
                  )),
              TextFormField(
                decoration: formInputDecoration('Name', 'Enter your full name'),
                cursorColor: textHeadingColor,
                controller: _nameController,
                style: TextStyle(color: textHeadingColor),
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  _checkAllFieldCompleted();
                },
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              TextFormField(
                decoration:
                    formInputDecoration('Mobile', 'Enter your phone number')
                        .copyWith(counterText: ''),
                cursorColor: textHeadingColor,
                controller: _phoneController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                style: TextStyle(color: textHeadingColor),
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  _checkAllFieldCompleted();
                },
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              TextFormField(
                decoration:
                    formInputDecoration('Email', 'Enter your name').copyWith(
                  suffixIcon: Icon(
                    Icons.check,
                    color: redColor,
                  ),
                ),
                cursorColor: textHeadingColor,
                controller: _emailController,
                readOnly: true,
                style: TextStyle(color: textHeadingColor),
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                      color: textHeadingColor,
                      fontSize: screenHeight(context) * 0.018,
                    ),
                  ),
                ],
              ),
              const GenderSelectionWidget(),
              SizedBox(height: screenHeight(context) * 0.02),
              TextFormField(
                controller: _dateController,
                decoration: formInputDecoration('Birth Date', '').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: textSubHeadingColor,
                    ),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                style: TextStyle(color: textHeadingColor),
                cursorColor: textHeadingColor,
                keyboardType: TextInputType.datetime,
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
                onTap: () => _selectDate(context),
                onChanged: (value) {
                  _checkAllFieldCompleted();
                },
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              ElevatedButton(
                onPressed: _saveDataToDB,
                style: registerButtonStyle(
                  context,
                  loadingProvider.isAllFieldCompleted
                      ? redColor
                      : Colors.transparent,
                  redColor,
                ),
                child: loadingProvider.isDataUploadingToDB
                    ? LoadingWidget(color: blackColor)
                    : Text(
                        widget.buttonName,
                        style: TextStyle(
                          color: loadingProvider.isAllFieldCompleted
                              ? blackColor
                              : textHeadingColor,
                          fontSize: screenWidth(context) * 0.045,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    pickedDate = picked;
    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
      _dateController.text = formattedDate;
      _checkAllFieldCompleted();
    }
  }

  void _checkAllFieldCompleted() {
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);
    log('name: ${_nameController.text}, phone: ${_phoneController.text}, date: ${_dateController.text}');
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.length == 10 &&
        _dateController.text.length == 10) {
      loadingProvider.setIsAllFieldCompleted(true);
    } else {
      loadingProvider.setIsAllFieldCompleted(false);
    }
  }

  void _saveDataToDB() async {
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context, listen: false);
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final gender = genderSelectionProvider.selectedGender;
    loadingProvider.setIsDataUploadingToDB(true);
    if (loadingProvider.isAllFieldCompleted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      final listenersData =
          await fireStore.collection('listeners').doc(userId()).get();

      if (listenersData.exists) {
        await fireStore.collection('listeners').doc(userId()).update({
          'profileUrl': profileImageUrl,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'gender': gender == Gender.other
              ? 'other'
              : gender == Gender.female
                  ? 'female'
                  : 'male',
          'dateOfBirth': _dateController.text,
        });
      } else {
        loadingProvider.setIsGoogleLogin(false);
        await fireStore.collection('listeners').doc(userId()).set({
          'profileUrl': profileImageUrl,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'gender': gender == Gender.other
              ? 'other'
              : gender == Gender.female
                  ? 'female'
                  : 'male',
          'dateOfBirth': _dateController.text,
          'accountCreatedDate': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          'fcmToken': '',
          'lastOnline': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          'latitude': locationProvider.location['latitude'],
          'longitude': locationProvider.location['longitude'],
        });
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Field is empty',
        style: TextStyle(
          color: textHeadingColor,
        ),
      )));
    }
    loadingProvider.setIsDataUploadingToDB(false);
  }
}
