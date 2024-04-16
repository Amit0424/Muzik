import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _songName = '';
  String _artistName = '';
  String _songUri = '';

  setSongForPlaying(String? songUri) async {
    if (_songUri != songUri) {
      _songUri = songUri!;
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(_songUri)));
      _audioPlayer.play();
      listener();
      notifyListeners();
    }
  }

  listener() {
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
        notifyListeners();
      }
      log('Player State: ${event.processingState}');
    });
  }

  set songName(String name) {
    if (_songName != name) {
      _songName = name;
    }
  }

  set artistName(String name) {
    if (_artistName != name) {
      _artistName = name;
    }
  }

  String get getSongName => _songName;
  String get getArtistName => _artistName;
  AudioPlayer get audioPlayer => _audioPlayer;
}
