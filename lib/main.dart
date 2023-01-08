import 'package:flutter/material.dart';
import 'package:izmir/pages/home_page.dart';

void main() {
  runApp(home());
}

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iZMiR',
      debugShowCheckedModeBanner: false,
      home: home_page(),
    );
  }
}
