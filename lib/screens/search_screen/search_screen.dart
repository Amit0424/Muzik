import 'package:flutter/material.dart';

import '../../constants/styling.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          'Search',
          style: appBarTitleStyle(context),
        ),
      ),
      body: Text(
        'Search Screen',
        style: TextStyle(color: textHeadingColor),
      ),
    );
  }
}
