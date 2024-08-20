import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyProvider with ChangeNotifier {
  String artistId = '2w9zwq3AktTeYYMuhMjju8';

  getArtist() async {
    try {
      final uri =
          Uri.parse('https://spotify23.p.rapidapi.com/artists/?ids=$artistId');
      final headers = {
        'x-rapidapi-key': '55e14a6570msh883814e43f8fa44p1c6f5fjsncf24047ddd09',
        'x-rapidapi-host': 'spotify23.p.rapidapi.com',
        'X-RapidAPI-Mock-Response': '200'
      };

      final response = await http.get(uri, headers: headers);

      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  playSpotify() async {
    log('Playing Spotify');
    await SpotifySdk.play(spotifyUri: 'spotify:track:7EFfeGN5U0zm9C6KpOeNBH');
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
