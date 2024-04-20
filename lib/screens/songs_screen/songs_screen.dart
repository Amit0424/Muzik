import 'package:android_muzik/screens/songs_screen/utils/bottom_navigation_bar_list.dart';
import 'package:android_muzik/screens/songs_screen/utils/dash_board_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../main.dart';
import '../../providers/location_provider.dart';
import '../../providers/music_provider.dart';
import '../../utils/get_location.dart';
import '../../utils/get_user_details.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  static String routeName = '/songs_screen';

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    sendLiveDataToDB();
  }

  sendLiveDataToDB() async {
    final LocationProvider locationProvider =
        Provider.of(context, listen: false);
    locationProvider.setLocation(await getLocation(context));
    await Permission.mediaLibrary.request();
    await fireStore.collection('listeners').doc(userId()).update({
      'lastOnline': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'latitude': locationProvider.location['latitude'],
      'longitude': locationProvider.location['longitude'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final MusicProvider musicProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      body: Stack(children: [
        dashBoardList()[currentIndex],
        if (musicProvider.audioPlayer.playing || musicProvider.songName != '')
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: Container(
              height: screenHeight(context) * 0.1,
              width: screenWidth(context),
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight(context) * 0.01,
                  horizontal: screenWidth(context) * 0.02),
              decoration: BoxDecoration(
                color: matteBlackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Marquee(
                      text: musicProvider.songName,
                      style: TextStyle(
                        color: yellowColor,
                        fontSize: screenHeight(context) * 0.02,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 50.0,
                      fadingEdgeStartFraction: 0.3,
                      fadingEdgeEndFraction: 0.3,
                      pauseAfterRound: const Duration(seconds: 1),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            musicProvider.audioPlayer
                                .seek(const Duration(seconds: -10));
                          });
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          color: textHeadingColor,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.05,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (musicProvider.audioPlayer.playing) {
                              musicProvider.audioPlayer.pause();
                            } else {
                              musicProvider.audioPlayer.play();
                            }
                          });
                        },
                        icon: musicProvider.audioPlayer.playing
                            ? Icon(
                                Icons.pause,
                                color: textHeadingColor,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: textHeadingColor,
                              ),
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.05,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            musicProvider.audioPlayer
                                .seek(const Duration(seconds: 10));
                          });
                        },
                        icon: Icon(
                          Icons.skip_next,
                          color: textHeadingColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ]),
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
