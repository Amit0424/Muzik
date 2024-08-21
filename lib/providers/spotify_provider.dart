import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyProvider with ChangeNotifier {
  String artistId = '2w9zwq3AktTeYYMuhMjju8';
  String searchType =
      'multi'; // albums, artists, episodes, genres, playlists, podcasts, tracks and users
  int searchOffset = 0;
  int searchLimit = 10;
  int searchNumberOfTopResults = 5;
  String searchQuery = '';
  final _headers = {
    'x-rapidapi-key': '55e14a6570msh883814e43f8fa44p1c6f5fjsncf24047ddd09',
    'x-rapidapi-host': 'spotify23.p.rapidapi.com',
    'X-RapidAPI-Mock-Response': '200'
  };

  getArtist() async {
    if (artistId.isEmpty) return;
    try {
      final uri =
          Uri.parse('https://spotify23.p.rapidapi.com/artists/?ids=$artistId');

      final response = await http.get(uri, headers: _headers);

      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  search() async {
    if (searchQuery.isEmpty || searchType.isEmpty) return;
    try {
      final uri = Uri.parse(
          'https://spotify23.p.rapidapi.com/search/?q=$searchQuery&type=$searchType&offset=$searchOffset&limit=$searchLimit&numberOfTopResults=$searchNumberOfTopResults');

      final response = await http.get(uri, headers: _headers);

      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  playTrack(String trackId) async {
    await SpotifySdk.play(spotifyUri: trackId);
  }

  void pauseTrack() async {
    await SpotifySdk.pause();
  }

  void resumeTrack() async {
    await SpotifySdk.resume();
  }

  void skipNextTrack() async {
    await SpotifySdk.skipNext();
  }

  void skipPreviousTrack() async {
    await SpotifySdk.skipPrevious();
  }
}
