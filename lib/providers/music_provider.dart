import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songModelList = [];
  ConcatenatingAudioSource songPlaylist =
      ConcatenatingAudioSource(children: []);
  String _songName = '';
  String _artistName = '';

  // String _songUri = '';
  List<AudioSource> playlist = [];

  MusicProvider() {
    getDownloadedSongs();
  }

  Future<void> getDownloadedSongs() async {
    songModelList = await _audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
      uriType: UriType.EXTERNAL,
    );
    playlist = songModelList
        .map((song) => AudioSource.uri(Uri.parse(song.uri!)))
        .toList();
    notifyListeners();
  }

  void seekToNextSong() {
    _audioPlayer.seekToNext();
    notifyListeners();
  }

  void seekToPreviousSong() {
    _audioPlayer.seekToPrevious();
    notifyListeners();
  }

  void seekSong(double value) {
    _audioPlayer.seek(Duration(milliseconds: (value * 1000).toInt()));
    notifyListeners();
  }

  void setAudioSourceSong(int index) {
    log(songPlaylist.length.toString());
    if (songPlaylist.length == 0) {
      log('playlist is empty');
      songPlaylist = ConcatenatingAudioSource(
        children: playlist,
      );
    }
    log(songPlaylist.length.toString());
    log(playlist.length.toString());
    _audioPlayer.setAudioSource(songPlaylist, initialIndex: index);
    listener();
  }

  listener() {
    _audioPlayer.currentIndexStream.listen((event) {
      songName = songModelList[event!].title;
      artistName = songModelList[event].artist!;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        songName = event.processingState.name;
        artistName = '';
        notifyListeners();
      }
    });
    _audioPlayer.positionStream.listen((event) {
      notifyListeners();
    });
  }

  set songName(String name) {
    if (name.contains('|')) {
      name.split('|')[0];
    }
    if (_songName != name) {
      _songName = name;
    }
  }

  set artistName(String name) {
    name == '<unknown>' ? 'Unknown Artist' : name;
    if (_artistName != name) {
      _artistName = name;
    }
  }

  String get songName => _songName;

  String get artistName => _artistName;

  AudioPlayer get audioPlayer => _audioPlayer;

  void playPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    notifyListeners();
  }
}
