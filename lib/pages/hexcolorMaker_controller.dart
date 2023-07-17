
  import 'package:flutter/material.dart';
import 'package:izmir/consts/colors.dart';

hexColor(String color) {
    String newColor = '0xff' + color;
    newColor = newColor.replaceAll('#', '');
    try {
      return Color(int.parse(newColor));
    } catch (e) {
      return whiteColor;
    }
}