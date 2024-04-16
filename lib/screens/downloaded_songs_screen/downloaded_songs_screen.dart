import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/styling.dart';
import '../../widgets/loading_widget.dart';
import '../now_playing/now_playing.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({super.key});

  @override
  State<DownloadedSongsScreen> createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    log('getting storage permission');
    final storageStatusRequest = await Permission.mediaLibrary.request();

    if (storageStatusRequest.isDenied) {
      log('Permission Granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          'Downloaded',
          style: appBarTitleStyle(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: SongSortType.DISPLAY_NAME,
            orderType: OrderType.ASC_OR_SMALLER,
            ignoreCase: true,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, songs) {
            if (songs.hasError) {
              return Text(
                songs.error.toString(),
                style: TextStyle(color: textHeadingColor),
              );
            }
            if (songs.hasData) {
              return ListView.builder(
                itemCount: songs.data!.length,
                itemBuilder: (context, index) {
                  final songName = songs.data![index].displayNameWOExt;
                  final artistName = songs.data![index].artist.toString();
                  if (songs.data!.isEmpty) {
                    return Text(
                      'No songs found',
                      style: TextStyle(
                        color: textHeadingColor,
                        fontSize: 16,
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NowPlaying(
                          songModel: songs.data![index],
                        );
                      }));
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight(context) * 0.01),
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight(context) * 0.01,
                          horizontal: screenWidth(context) * 0.02),
                      decoration: BoxDecoration(
                        color: textHeadingColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            radius: screenWidth(context) * 0.05,
                            backgroundImage: const AssetImage(
                              'assets/images/pngs/anime_image_1.png',
                            ),
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.05,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenWidth(context) * 0.75,
                                child: Text(
                                  songName,
                                  style: TextStyle(
                                    color: textHeadingColor,
                                    fontSize: screenWidth(context) * 0.04,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                artistName == '<unknown>'
                                    ? 'Unknown Artist'
                                    : artistName ?? 'Unknown Artist',
                                style: TextStyle(
                                  color: textSubHeadingColor,
                                  fontSize: screenWidth(context) * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return LoadingWidget(color: redColor);
            }
          },
        ),
      ),
    );
  }
}
