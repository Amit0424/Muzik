import 'package:android_muzik/screens/songs_screen/utils/bottom_navigation_bar_list.dart';
import 'package:android_muzik/screens/songs_screen/utils/dash_board_screen_list.dart';
import 'package:flutter/material.dart';
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
    _getMediaPermission();
    sendLiveDataToDB();
  }

  sendLiveDataToDB() async {
    final LocationProvider locationProvider =
        Provider.of(context, listen: false);
    locationProvider.setLocation(await getLocation(context));
    await Permission.mediaLibrary.request();
    await fireStore.collection('listeners').doc(userId()).update({
      'lastOnline': DateTime.now(),
      'latitude': locationProvider.location['latitude'],
      'longitude': locationProvider.location['longitude'],
    });
  }

  void _getMediaPermission() async {
    if (await Permission.audio.isDenied) {
      await Permission.audio.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final MusicProvider musicProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      body: Stack(children: [
        dashBoardList()[currentIndex],
        if (musicProvider.audioPlayer.playing &&
            musicProvider.audioPlayer.currentIndex != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              child: Stack(
                children: [
                  Container(
                    height: screenHeight(context) * 0.11,
                    width: screenWidth(context),
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight(context) * 0.01,
                      horizontal: screenWidth(context) * 0.02,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight(context) * 0.01,
                        horizontal: screenWidth(context) * 0.02),
                    decoration: BoxDecoration(
                      color: matteBlackColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          musicProvider.songName,
                          style: TextStyle(
                            color: textHeadingColor,
                            fontSize: screenWidth(context) * 0.04,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                musicProvider.seekToPreviousSong();
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
                                if (musicProvider.audioPlayer.playing) {
                                  musicProvider.playPause();
                                } else {
                                  musicProvider.audioPlayer.play();
                                }
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
                                musicProvider.seekToNextSong();
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
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        musicProvider.audioPlayer.stop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: yellowColor,
                        size: screenWidth(context) * 0.05,
                      ),
                    ),
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
