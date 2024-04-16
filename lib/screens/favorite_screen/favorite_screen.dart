import 'package:flutter/material.dart';

import '../../constants/styling.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          'Loved',
          style: appBarTitleStyle(context),
        ),
      ),
      body: Text(
        'Favorite Screen',
        style: TextStyle(color: textHeadingColor),
      ),
    );
  }
}
