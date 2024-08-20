import 'package:android_muzik/constants/styling.dart';
import 'package:android_muzik/providers/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key, required this.songModel, required this.index});

  final List<SongModel> songModel;
  final int index;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
        ),
        backgroundColor: blackColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textHeadingColor,
            size: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Now Playing',
          style: appBarTitleStyle(context),
        ),
      ),
      body: Consumer<MusicProvider>(builder: (context, musicProvider, child) {
        musicProvider.songName =
            widget.songModel[musicProvider.audioPlayer.currentIndex!].title;
        musicProvider.artistName =
            widget.songModel[musicProvider.audioPlayer.currentIndex!].artist!;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth(context) * 0.03,
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              Container(
                height: screenHeight(context) * 0.4,
                width: screenWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/jpgs/music_symbol.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  musicProvider.songName,
                  style: TextStyle(
                    color: textHeadingColor,
                    fontSize: screenHeight(context) * 0.025,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  musicProvider.artistName,
                  style: TextStyle(
                    color: textSubHeadingColor,
                    fontSize: screenHeight(context) * 0.015,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              Slider(
                activeColor: yellowColor.withOpacity(0.9),
                inactiveColor: textSubHeadingColor,
                allowedInteraction: SliderInteraction.tapAndSlide,
                thumbColor: yellowColor,
                value: musicProvider.audioPlayer.position.inSeconds.toDouble(),
                onChanged: (value) {
                  musicProvider.seekSong(value);
                },
                min: 0,
                max: musicProvider.audioPlayer.duration?.inSeconds.toDouble() ??
                    0.00,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(musicProvider.audioPlayer.position),
                    style: TextStyle(
                      color: textSubHeadingColor,
                      fontSize: screenHeight(context) * 0.02,
                    ),
                  ),
                  Text(
                    formatDuration(musicProvider.audioPlayer.duration ??
                        const Duration(seconds: 0)),
                    style: TextStyle(
                      color: textSubHeadingColor,
                      fontSize: screenHeight(context) * 0.02,
                    ),
                  ),
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
                      color: Colors.white,
                      size: screenHeight(context) * 0.045,
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
                      height: screenHeight(context) * 0.08,
                      width: screenHeight(context) * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellowColor,
                      ),
                      child: Icon(
                        musicProvider.audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: screenHeight(context) * 0.045,
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
                      color: Colors.white,
                      size: screenHeight(context) * 0.045,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
            ],
          ),
        );
      }),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
