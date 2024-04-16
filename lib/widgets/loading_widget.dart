import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color,
      size: 45,
    );
  }
}
