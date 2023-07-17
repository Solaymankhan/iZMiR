import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izmir/pages/hexcolorMaker_controller.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../shapes/all_product_network_image_shape.dart';

class upcoming_events_shape_controller2 extends GetxController {
  var settings_docreference = FirebaseFirestore.instance
      .collection("app_settings")
      .doc("setting")
      .collection("upcomming_events");
  RxList eventlist = [].obs, event_id_list = [].obs;

  final ScrollController scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  var img_docreference = FirebaseStorage.instance;
  bool isMoreData = true;
  RxBool visibility_of_widget = false.obs;
  var dat;
  RxString event_date_picked_compare = "".obs;

  @override
  void onInit() {
    dat = DateTime.parse(DateTime.now().toString());
    event_date_picked_compare.value =
        (dat.year.toString() + dat.month.toString() + dat.day.toString());
    super.onInit();
    PaginatedData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        PaginatedData();
      }
    });
  }

  void reload_event_data() {
    dat = DateTime.parse(DateTime.now().toString());
    event_date_picked_compare.value =
        (dat.year.toString() + dat.month.toString() + dat.day.toString());
    isMoreData = true;
    eventlist.clear();
    event_id_list.clear();
    lastDocument = null;
    PaginatedData();
  }

  void PaginatedData() async {
    if (isMoreData) {
      try {
        late QuerySnapshot<Map<String, dynamic>> querySnapshot;
        if (lastDocument == null) {
          querySnapshot = await settings_docreference
              .where('event_date_compare',
                  isGreaterThan: event_date_picked_compare.value)
              .orderBy('event_date_compare')
              .limit(5)
              .get();
        } else {
          querySnapshot = await settings_docreference
              .where('event_date_compare',
                  isGreaterThan: event_date_picked_compare.value)
              .orderBy('event_date_compare')
              .limit(5)
              .startAfterDocument(lastDocument!)
              .get();
        }
        lastDocument = querySnapshot.docs.last;

        eventlist.addAll(querySnapshot.docs.map((e) => e.data()));
        event_id_list.addAll(querySnapshot.docs.map((e) => e.id));
        if (querySnapshot.docs.length < 5) isMoreData = false;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget upcoming_events_shape(het, wdt) {
    return Visibility(
      visible: eventlist.isEmpty ? false : true,
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: eventlist.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisExtent: 250),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showAlertDialog(context, event_id_list[index],
                  eventlist[index]['event_img']);
            },
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: eventlist[index]['event_img'],
                  imageBuilder: (context, url)=> event_network_image_shape(url),
                  placeholder: (context, url)=>event_asset_image_shape(),
                  errorWidget: (context, url, error) => event_asset_image_shape(),
                ),
                Opacity(
                  opacity: 0.7,
                  child: Column(
                    children: [
                      Text(
                        eventlist[index]['event_day'],
                        style: TextStyle(
                            color: darkBlueColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        month_names[
                            int.parse(eventlist[index]['event_month'])],
                        style: TextStyle(
                            color: darkBlueColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                      .box
                      .color(hexColor("#FFCD46"))
                      .height(57)
                      .rounded
                      .margin(EdgeInsets.all(5))
                      .padding(EdgeInsets.all(5))
                      .make(),
                )
              ],
            )
                .box
                .margin(EdgeInsets.only(
                    left: index == 0 ? 15 : 2,
                    right: eventlist.length - 1 == index ? 15 : 2))
                .make(),
          );
        },
      )
          .box
          .margin(EdgeInsets.only(bottom: 15))
          .height(130)
          .width(double.infinity)
          .make(),
    ).box.margin(EdgeInsets.only(top: 10)).make();
  }

  showAlertDialog(BuildContext context, event_id, event_img) async =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: new Text(
            'Are you sure?',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          content: new Text(
            "Do you really want to Delete this Event ?",
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
                settings_docreference.doc(event_id).delete(),
                img_docreference.refFromURL(event_img).delete(),
                reload_event_data(),
                reload_event_data(),
                Navigator.of(context).pop()
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      );
}
