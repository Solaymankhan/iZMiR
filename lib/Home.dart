import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:izmir/controllers/home_controller.dart';
import 'package:izmir/pages/cart_page.dart';
import 'package:izmir/pages/category_page.dart';
import 'package:izmir/pages/messages_page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'consts/consts.dart';
import 'package:flutter/services.dart';
import 'package:izmir/pages/home_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: whiteColor,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light));

  runApp(home());
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navbar_itm = [
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house_fill), label: home_txt),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
          label: categories_txt),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_text_fill),
          label: messages_txt),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.cart_fill), label: cart_txt),
    ];

    var nav_body = [
      const home_page(),
      const category_page(),
      const message_page(),
      const cart_page(),
    ];

    return MaterialApp(
      title: 'iZMiR',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Obx(() => Expanded(
                child: nav_body.elementAt(controller.current_nav_indx.value))),
          ],
        ),
        bottomNavigationBar: Container(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            child: Obx(
              () => BottomNavigationBar(
                currentIndex: controller.current_nav_indx.value,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: darkBlueColor,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500),
                backgroundColor: lightGreyColor,
                items: navbar_itm,
                onTap: (value) {
                  controller.current_nav_indx.value = value;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
