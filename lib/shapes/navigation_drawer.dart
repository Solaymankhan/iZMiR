import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/colors.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/pages/login_page.dart';
import 'package:izmir/shapes/snack_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/drawer_controller.dart';
import '../pages/professionals_profile_page.dart';
import '../pages/about_us_page.dart';
import '../pages/cart_page_2.dart';
import '../pages/complain_box_page.dart';
import '../pages/message_book_page.dart';
import '../pages/my_orders_page.dart';
import '../pages/profile_page.dart';
import '../pages/returns_page.dart';
import '../pages/rules_and_guide_page.dart';
import 'all_product_network_image_shape.dart';

class navigation_drawer extends StatelessWidget {
  navigation_drawer({Key? key}) : super(key: key);

  final drawer_controller drawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    check_activation();
    if (drawerController.pref_userId.value.length != 0)
      drawerController.lgin_lgot_txt.value = logout_txt;
    else
      drawerController.lgin_lgot_txt.value = login_txt;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((OverscrollIndicatorNotification? notificaton) {
            notificaton!.disallowIndicator();
            return true;
          }),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              drawer_header().onTap(() {
                Navigator.of(context).pop();
                if (check_lgin(context) == true)
                  Get.to(() => check_pro(context) == true
                      ? professionals_profile_page()
                      : profile_page());
              }),
              Visibility(
                visible: check_pro(context) == true ? false: true,
                child: ListTile(
                    leading: Icon(
                      CupertinoIcons.cart_fill,
                      color: darkFontGreyColor,
                    ),
                    title: Text(my_cart_txt),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (check_lgin(context) == true)
                        Get.to(() => cart_page_2());
                    }),
              ),
              Visibility(
                visible: check_pro(context) == true ? false: true,
                child: ListTile(
                    leading: Icon(
                      CupertinoIcons.gift_alt_fill,
                      color: darkFontGreyColor,
                    ),
                    title: Text(my_orders_txt),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (check_lgin(context) == true)
                        Get.to(() => my_orders_page());
                    }),
              ),
              Visibility(
                  visible: check_pro(context) == true ? false: true,
                child: ListTile(
                    leading: Icon(
                      CupertinoIcons.arrowshape_turn_up_left_fill,
                      color: darkFontGreyColor,
                    ),
                    title: Text(returns_txt),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (check_lgin(context) == true)
                        Get.to(() => returns_page());
                    }),
              ),
              Visibility(
                visible: check_pro(context) == true ? false: true,
                child: ListTile(
                    leading: Icon(
                      CupertinoIcons.bubble_left_bubble_right_fill,
                      color: darkFontGreyColor,
                    ),
                    title: Text(message_book_txt),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (check_lgin(context) == true)
                        Get.to(() =>message_book_page());
                    }),
              ),
              Visibility(
                visible: check_pro(context) == true ? false: true,
                child: ListTile(
                    leading: Icon(
                      CupertinoIcons.envelope_fill,
                      color: darkFontGreyColor,
                    ),
                    title: Text(conplain_box_txt),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (check_lgin(context) == true)
                        Get.to(() => complain_box_page());
                    }),
              ),
              ListTile(
                  leading: Icon(
                    CupertinoIcons.exclamationmark_square_fill,
                    color: darkFontGreyColor,
                  ),
                  title: Text(Rules_and_guide_txt),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => rules_and_guide_page());
                  }),
              ListTile(
                  leading: Icon(
                    CupertinoIcons.person_3_fill,
                    color: darkFontGreyColor,
                  ),
                  title: Text(about_us_txt),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => about_us_page());
                  }),
              10.heightBox,
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Material(
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: () {
                      if (drawerController.pref_userId.value.length != 0) {
                        showAlertDialog(context, drawerController);
                      } else {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => login_page()));
                      }
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: darkBlueColor,
                      ),
                      height: 35,
                      width: 100,
                      child: Obx(
                        () => Text(
                          drawerController.lgin_lgot_txt.value,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: yellowColor,
                              fontWeight: FontWeight.w500),
                        ).box.alignCenter.make(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  check_activation() async {
    if (drawerController.pref_userId.value.length != 0) {
      if (drawerController.pref_info["account_type"] == professionals) {
        await FirebaseFirestore.instance
            .collection(professionals)
            .doc(drawerController.pref_userId.value)
            .snapshots()
            .listen((event) {
          if (event.get("account_status") == deactivated) {
            drawerController.removeUserId();
          }
        });
      }
    }
  }

  bool check_lgin(context) {
    if (drawerController.pref_userId.value.length != 0) {
      return true;
    } else {
      show_snackbar(context, not_lgdin_yt_txt, whiteColor, Colors.red);
      return false;
    }
  }
  bool check_pro(context) {
    if (drawerController.pref_userId.value.length != 0) {
      if(drawerController.pref_info["account_type"] == professionals) return true;
      return false;
    } else return false;
  }

  Widget drawer_header() {
    return Obx(
      () => UserAccountsDrawerHeader(
        decoration: BoxDecoration(
        ),
        accountName: Text(
          drawerController.pref_info.length > 0
              ? drawerController.pref_info["name"]
              : hey_txt,
          style: TextStyle(
              color: BlackColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(
          "${drawerController.pref_info.length > 0 ? drawerController.pref_info["phone"] : lgn_to_by_txt}\n"
          "${drawerController.pref_info.length > 0 ? drawerController.pref_info["address"] : ""}",
          style: TextStyle(color: darkFontGreyColor, fontSize: 15),
        ),
        currentAccountPicture: CachedNetworkImage(
          imageUrl: drawerController.pref_info.length > 0 ?
          drawerController.pref_info["profile_picture"]:"",
          imageBuilder: (context, url)=>profile_network_image_shape(url),
          placeholder: (context, url)=>profile_asset_image_shape(),
          errorWidget: (context, url, error) => profile_asset_image_shape(),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, drawerController) async =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: new Text(
            'Are you sure?',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          content: new Text(
            "Do you really want to Logout ?",
            style: TextStyle(fontSize: 14, color: darkBlueColor),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('No'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => {
                drawerController.delete_pref_info(),
                drawerController.pref_info.clear(),
                drawerController.removeUserId(),
                drawerController.removeCarts(),
                Navigator.of(context).pop()
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      );
}
