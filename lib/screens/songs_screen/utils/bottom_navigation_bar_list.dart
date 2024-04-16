import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/styling.dart';

List<BottomNavigationBarItem> bottomNavigationBarList(
    BuildContext context, int currentIndex) {
  final height = screenHeight(context) * 0.02;
  final width = screenWidth(context) * 0.04;
  return [
    BottomNavigationBarItem(
      backgroundColor: blackColor,
      label: 'Loved',
      icon: SvgPicture.asset(
        'assets/images/svgs/favorite_icon.svg',
        color: currentIndex == 0 ? yellowColor : iconColor,
        height: height,
        width: width,
      ),
    ),
    BottomNavigationBarItem(
      backgroundColor: blackColor,
      label: 'Search',
      icon: SvgPicture.asset(
        'assets/images/svgs/search_icon.svg',
        color: currentIndex == 1 ? yellowColor : iconColor,
        height: height,
        width: width,
      ),
    ),
    BottomNavigationBarItem(
      backgroundColor: blackColor,
      label: 'Home',
      icon: SvgPicture.asset(
        'assets/images/svgs/home_icon.svg',
        color: currentIndex == 2 ? yellowColor : iconColor,
        height: height,
        width: width,
      ),
    ),
    BottomNavigationBarItem(
      backgroundColor: blackColor,
      label: 'Downloaded',
      icon: SvgPicture.asset(
        'assets/images/svgs/cart_icon.svg',
        color: currentIndex == 3 ? yellowColor : iconColor,
        height: height,
        width: width,
      ),
    ),
    BottomNavigationBarItem(
      backgroundColor: blackColor,
      label: 'Profile',
      icon: SvgPicture.asset(
        'assets/images/svgs/profile_icon.svg',
        color: currentIndex == 4 ? yellowColor : iconColor,
        height: height,
        width: width,
      ),
    ),
  ];
}
