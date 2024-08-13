import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female, other }

Gender genderSelection(String gender) {
  switch (gender) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'other':
      return Gender.other;
    default:
      return Gender.male;
  }
}

class ProfileModel {
  String name;
  String email;
  String phone;
  String profileUrl;
  String dateOfBirth;
  DateTime accountCreatedDate;
  DateTime lastOnline;
  double latitude;
  double longitude;
  String fcmToken;
  Gender gender;

  ProfileModel({
    required this.email,
    required this.phone,
    required this.profileUrl,
    required this.name,
    required this.dateOfBirth,
    required this.accountCreatedDate,
    required this.lastOnline,
    required this.latitude,
    required this.longitude,
    required this.fcmToken,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
      'fcmToken': fcmToken,
      'latitude': latitude,
      'phone': phone,
      'longitude': longitude,
      'dateOfBirth': dateOfBirth,
      'accountCreatedDate': accountCreatedDate,
      'lastOnline': lastOnline,
      'gender': gender,
    };
  }

  factory ProfileModel.fromDocument(DocumentSnapshot snapshot) {
    final map = snapshot;

    final email = map['email'] as String?;
    final name = map['name'] as String?;
    final phone = map['phone'] as String?;
    final profileUrl = map['profileUrl'] as String?;
    final dateOfBirth = map['dateOfBirth'];
    final accountCreatedDate = map['accountCreatedDate'].toDate();
    final lastOnline = map['lastOnline'].toDate();
    final latitude = map['latitude'];
    final longitude = map['longitude'];
    final fcmToken = map['fcmToken'] as String;
    final gender = map['gender'] as String;

    return ProfileModel(
      email: email ?? 'mail@website.com',
      name: name ?? 'Anonymous',
      phone: phone ?? '+911234567890',
      profileUrl: profileUrl ??
          'https://firebasestorage.googleapis.com/v0/b/muzik-c6b63.appspot.com/o/defaultImages%2Fprofile%2Fboy_profile.png?alt=media&token=e24891e5-4711-4d55-a1ea-097253247e8e',
      dateOfBirth: dateOfBirth,
      accountCreatedDate: accountCreatedDate,
      lastOnline: lastOnline,
      longitude: longitude ?? 0.0,
      latitude: latitude ?? 0.0,
      fcmToken: fcmToken,
      gender: genderSelection(gender),
    );
  }
}
