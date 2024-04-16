import 'package:flutter/material.dart';

import '../../constants/styling.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          'Home',
          style: appBarTitleStyle(context),
        ),
      ),
      body: const Text('Home Screen'),
    );
  }
}
