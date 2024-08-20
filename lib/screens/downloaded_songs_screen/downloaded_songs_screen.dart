import 'package:android_muzik/providers/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../widgets/loading_widget.dart';
import '../now_playing/now_playing.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({super.key});

  @override
  State<DownloadedSongsScreen> createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: blackColor,
        surfaceTintColor: blackColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
        ),
        title: Text(
          'My Songs',
          style: appBarTitleStyle(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child:
            Consumer<MusicProvider>(builder: (context, musicProvider, child) {
          final songModelList = musicProvider.songModelList;
          return ListView.separated(
            itemCount: songModelList.length,
            itemBuilder: (context, index) {
              final song = songModelList[index];
              final songName = song.title.toString();
              final artistName = song.artist.toString();
              if (songModelList.isEmpty) {
                return LoadingWidget(color: yellowColor);
              }

              return Column(
                children: [
                  SizedBox(
                    height: screenHeight(context) * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (musicProvider.audioPlayer.currentIndex != index) {
                        musicProvider.setAudioSourceSong(index);
                        musicProvider.audioPlayer.play();
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NowPlaying(
                          songModel: songModelList,
                          index: index,
                        );
                      }));
                    },
                    child: SizedBox(
                      width: screenWidth(context),
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
                                width: screenWidth(context) * 0.6,
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
                                    : artistName,
                                style: TextStyle(
                                  color: textSubHeadingColor,
                                  fontSize: screenWidth(context) * 0.03,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // musicProvider.deleteSong(song);
                            },
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: yellowColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: screenHeight(context) * 0.02,
            ),
          );
        }),
      ),
    );
  }
}
