import 'dart:developer';

import 'package:android_muzik/utils/tracks.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/spotify_tracks_model.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songModelList = [];
  ConcatenatingAudioSource songPlaylist =
      ConcatenatingAudioSource(children: []);
  String _songName = '';
  String _artistName = '';
  List<AudioSource> playlist = [];
  BrowseStart? browseStart;
  bool hidePlayer = true;

  MusicProvider() {
    getDownloadedSongs();
  }

  Future<String> loadData() async {
    browseStart = parseBrowseStart(spotifyTracks);
    notifyListeners();
    return "success";
  }

  Future<void> getDownloadedSongs() async {
    songModelList = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
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

  void playPause() {
    hidePlayer = false;
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    notifyListeners();
  }

  void stopSong() {
    hidePlayer = true;
    _audioPlayer.stop();
    notifyListeners();
  }

  void setAudioSourceSong(int index) {
    if (songPlaylist.length == 0) {
      log('playlist is empty');
      songPlaylist = ConcatenatingAudioSource(
        children: playlist,
      );
    }
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
}
