import 'package:android_muzik/screens/songs_screen/utils/bottom_navigation_bar_list.dart';
import 'package:android_muzik/screens/songs_screen/utils/dash_board_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../main.dart';
import '../../providers/location_provider.dart';
import '../../utils/get_location.dart';
import '../../utils/get_user_details.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  static String routeName = '/songs_screen';

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  int currentIndex = 3;

  @override
  void initState() {
    super.initState();
    sendLiveDataToDB();
  }

  sendLiveDataToDB() async {
    final LocationProvider locationProvider =
        Provider.of(context, listen: false);
    locationProvider.setLocation(await getLocation(context));
    await fireStore.collection('listeners').doc(userId()).update({
      'lastOnline': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'latitude': locationProvider.location['latitude'],
      'longitude': locationProvider.location['longitude'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: dashBoardList()[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: blackColor,
        selectedItemColor: yellowColor,
        selectedFontSize: screenWidth(context) * 0.03,
        unselectedItemColor: iconColor,
        unselectedFontSize: screenWidth(context) * 0.03,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: bottomNavigationBarList(context, currentIndex),
      ),
    );
  }
}
