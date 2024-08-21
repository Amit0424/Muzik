import 'dart:developer';

import 'package:android_muzik/providers/loading_provider.dart';
import 'package:android_muzik/screens/songs_screen/utils/bottom_navigation_bar_list.dart';
import 'package:android_muzik/screens/songs_screen/utils/dash_board_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

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
  @override
  void initState() {
    // connectToSpotify();
    _getMediaPermission();
    sendLiveDataToDB();
    super.initState();
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

  Future<void> connectToSpotify() async {
    try {
      log("Connecting to Spotify");
      var result = await SpotifySdk.getAccessToken(
        clientId: "6721df4e7588483b9b598b87852d12c6",
        redirectUrl: "myapp://android_muzik",
        scope:
            "app-remote-control,user-modify-playback-state,playlist-read-private",
      );
      log("Connected to Spotify: $result");
    } catch (e) {
      log("Error connecting to Spotify: $e");
    }
    log("Connected to Spotify");
  }

  @override
  Widget build(BuildContext context) {
    final MusicProvider musicProvider = Provider.of<MusicProvider>(context);
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      body: Stack(children: [
        dashBoardList()[loadingProvider.currentIndexOfScreen],
        if (musicProvider.audioPlayer.playing || !musicProvider.hidePlayer)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              child: Stack(
                children: [
                  Container(
                    height: screenHeight(context) * 0.15,
                    width: screenWidth(context),
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight(context) * 0.01,
                      horizontal: screenWidth(context) * 0.02,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight(context) * 0.01,
                        horizontal: screenWidth(context) * 0.02),
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: screenHeight(context) * 0.05,
                              width: screenWidth(context) * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/jpgs/music_symbol.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.05,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    musicProvider.songName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth(context) * 0.04,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    musicProvider.artistName,
                                    style: TextStyle(
                                      color: textHeadingColor,
                                      fontSize: screenWidth(context) * 0.03,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
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
                                size: screenHeight(context) * 0.03,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.05,
                            ),
                            GestureDetector(
                              onTap: () {
                                musicProvider.playPause();
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenHeight(context) * 0.05,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: yellowColor,
                                ),
                                child: Icon(
                                  musicProvider.audioPlayer.playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: screenHeight(context) * 0.03,
                                ),
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
                                size: screenHeight(context) * 0.03,
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
                        musicProvider.stopSong();
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
        currentIndex: loadingProvider.currentIndexOfScreen,
        onTap: (index) {
          loadingProvider.setCurrentIndexOfScreen(index);
        },
        items: bottomNavigationBarList(
            context, loadingProvider.currentIndexOfScreen),
      ),
    );
  }
}
