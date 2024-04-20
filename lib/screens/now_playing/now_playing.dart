import 'package:android_muzik/constants/styling.dart';
import 'package:android_muzik/providers/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key, required this.songModel});
  final SongModel songModel;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: false);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    final MusicProvider musicProvider =
        Provider.of<MusicProvider>(context, listen: false);
    musicProvider.songName = widget.songModel.displayNameWOExt;
    musicProvider.artistName = widget.songModel.artist == '<unknown>'
        ? 'Unknown Artist'
        : widget.songModel.artist ?? 'Unknown Artist';
    musicProvider.setSongForPlaying(widget.songModel.uri);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MusicProvider musicProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: blackColor,
        ),
        backgroundColor: blackColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textHeadingColor,
          ),
        ),
        title: Text(
          'Downloaded',
          style: appBarTitleStyle(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth(context) * 0.05,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: screenWidth(context) * 0.3,
                foregroundImage:
                    const AssetImage('assets/images/pngs/anime_image_1.png'),
              ),
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
              SizedBox(
                height: screenHeight(context) * 0.05,
                width: screenWidth(context) * 0.9,
                child: Marquee(
                  text: widget.songModel.displayNameWOExt,
                  style: TextStyle(
                    color: textHeadingColor,
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
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              Text(
                widget.songModel.artist == '<unknown>'
                    ? 'Unknown Artist'
                    : widget.songModel.artist ?? 'Unknown Artist',
                style: TextStyle(
                  color: textSubHeadingColor,
                  fontSize: screenHeight(context) * 0.02,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.15,
                    child: Center(
                      child: Text(
                        musicProvider.audioPlayer.position.inMinutes < 1
                            ? '00:${musicProvider.audioPlayer.position.inSeconds < 10 ? '0' : ''}${musicProvider.audioPlayer.position.inSeconds}'
                            : '${musicProvider.audioPlayer.position.inMinutes < 10 ? '0' : ''}${musicProvider.audioPlayer.position.inMinutes}:${musicProvider.audioPlayer.position.inSeconds.remainder(60) < 10 ? '0' : ''}${musicProvider.audioPlayer.position.inSeconds.remainder(60)}',
                        style: TextStyle(
                          color: textSubHeadingColor,
                          fontSize: screenHeight(context) * 0.02,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      activeColor: redColor.withOpacity(0.9),
                      inactiveColor: textSubHeadingColor,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                      thumbColor: redColor,
                      value: musicProvider.audioPlayer.position.inSeconds
                          .toDouble(),
                      onChanged: (value) {
                        setState(() {
                          musicProvider.audioPlayer.seek(
                              Duration(milliseconds: (value * 1000).toInt()));
                        });
                      },
                      min: 0,
                      max: musicProvider.audioPlayer.duration?.inSeconds
                              .toDouble() ??
                          0.00,
                    ),
                  ),
                  Text(
                    '${musicProvider.audioPlayer.duration?.inMinutes ?? 0}:${(musicProvider.audioPlayer.duration?.inSeconds.remainder(60) ?? 0) < 10 ? '0${musicProvider.audioPlayer.duration?.inSeconds.remainder(60) ?? 0}' : musicProvider.audioPlayer.duration!.inSeconds.remainder(60)}',
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
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
