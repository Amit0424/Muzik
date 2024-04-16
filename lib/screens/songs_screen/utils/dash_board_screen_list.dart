import 'package:flutter/cupertino.dart';

import '../../downloaded_songs_screen/downloaded_songs_screen.dart';
import '../../favorite_screen/favorite_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../search_screen/search_screen.dart';
import '../../user_detail_form_screen/user_detail_form_screen.dart';

List<Widget> dashBoardList() {
  return [
    const FavoriteScreen(),
    const SearchScreen(),
    const HomeScreen(),
    const DownloadedSongsScreen(),
    const UserDetailFormScreen(buttonName: 'Update'),
  ];
}
