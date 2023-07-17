import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loading_page() {
  return Scaffold(
    body: const Center(
        child: CupertinoActivityIndicator(radius: 10)
    ),
  );
}

/*
ColorfulCircularProgressIndicator(
          colors: [CupertinoColors.systemGrey],
          strokeWidth: 4,
          indicatorHeight: 25,
          indicatorWidth: 25,
        ),
 */