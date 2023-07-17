import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:izmir/pages/view_full_image.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/images.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/dont_have_any_data.dart';
import '../shapes/snack_bar.dart';
import 'brand_shop_home_page.dart';

final drawer_controller drawerController = Get.find();

class message_page extends StatefulWidget {
  message_page(
      {Key? key,
      required this.brand_id,
      required this.brand_name,
      required this.brand_icon})
      : super(key: key);
  var brand_name, brand_icon, brand_id;

  @override
  State<message_page> createState() => _message_pageState();
}

class _message_pageState extends State<message_page> {
  var messages_docreference = FirebaseFirestore.instance.collection("messages");
  var send_img_docreference = FirebaseStorage.instance;
  var firebase_instance = FirebaseFirestore.instance;
  RxString sender = ''.obs, reciever = ''.obs;
  TextEditingController message_txt_controller = TextEditingController();
  RxList messageList = [].obs;
  ScrollController scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isMoreData = true;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await PaginatedData(false);
      }
    });
    PaginatedData(true);
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> PaginatedData(tr_fl) async {
    if (isMoreData) {
      try {
        final collectionRef = await messages_docreference
            .doc("${drawerController.pref_userId.value}+${widget.brand_id}")
            .collection("chats")
            .orderBy("time", descending: true);

        late Query<Map<String, dynamic>> querySnapshot;
        if (lastDocument == null) {
          querySnapshot = await collectionRef.limit(limit);
        } else {
          querySnapshot = await collectionRef
              .limit(limit)
              .startAfterDocument(lastDocument!);
        }
        querySnapshot.snapshots().listen((event) {
          if(tr_fl){
            isMoreData=true;
            lastDocument=null;
            messageList.clear();
          }
          lastDocument = event.docs.last;
          messageList.addAll(event.docs.map((e) => e.data()));
          if (event.docs.length < limit) isMoreData = false;
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var het = (MediaQuery.of(context).size.height);
    var wdt = (MediaQuery.of(context).size.width);
    sender.value = "${drawerController.pref_userId.value}+${widget.brand_id}";
    reciever.value = "${widget.brand_id}+${drawerController.pref_userId.value}";
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    height: 50,
                    margin: EdgeInsets.only(right: 10),
                    child: Material(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Ink(
                            height: 40,
                            width: 40,
                            color: whiteColor,
                            child: Icon(CupertinoIcons.back)),
                      ),
                    )),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  child: InkWell(
                    onTap: () async {
                      Get.to(() =>
                          brands_shops_home_page(brand_id: widget.brand_id));
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.brand_icon,
                      imageBuilder: (context, url) =>
                          brand_ink_network_image_shape(url),
                      placeholder: (context, url) =>
                          brand_ink_asset_image_shape(),
                      errorWidget: (context, url, error) =>
                          brand_ink_asset_image_shape(),
                    ),
                  ),
                ).marginOnly(right: 5),
                Expanded(
                  child: Text(
                    widget.brand_name,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: darkFontGreyColor,
                        fontWeight: FontWeight.w500),
                  ).onTap(() {
                    Get.to(() =>
                        brands_shops_home_page(brand_id: widget.brand_id));
                  }),
                ),
              ],
            ).box.padding(EdgeInsets.only(top: 5)).make(),
            Flexible(
              child: Column(
                children: [
                  Expanded(
                    child: Obx(
                      () => messageList.isEmpty
                          ? Container(
                              height: het / 2 + 100,
                              child: CupertinoActivityIndicator(radius: 10)
                                  .box
                                  .alignCenter
                                  .make())
                          : ListView.builder(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: messageList.length,
                              itemBuilder: (context, index) {
                                return Column(children: [
                                  Visibility(
                                    visible: 0 == index?true: (messageList.length - 1 == index
                                        ? false
                                        : calculate_difference_of_date(
                                            messageList[index],
                                            messageList[index + 1])),
                                    child: Text(
                                      DateFormat('EEEE, MMM d, yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  (int.parse(messageList[index]
                                                              ["time"]) /
                                                          1000)
                                                      .toInt())
                                              .toLocal()),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: darkFontGreyColor,
                                          fontWeight: FontWeight.w500),
                                    )
                                        .box
                                        .margin(EdgeInsets.only(
                                            top: 15, bottom: 15))
                                        .make(),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: messageList[index]
                                                ["sender"] ==
                                            drawerController.pref_userId.value
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Visibility(
                                          visible: messageList[index]
                                                  ["sender"] !=
                                              drawerController
                                                  .pref_userId.value,
                                          child: CachedNetworkImage(
                                            imageUrl: widget.brand_icon,
                                            imageBuilder: (context, url) =>
                                                brand_small_network_image_shape(
                                                    url),
                                            placeholder: (context, url) =>
                                                brand_small_asset_image_shape(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                brand_small_asset_image_shape(),
                                          ).marginOnly(left: 10)),
                                      Container(
                                              constraints: BoxConstraints(
                                                maxWidth: wdt * 0.8,
                                                minWidth: wdt * 0.1,
                                              ),
                                              child: messageList[index]
                                                          ["message_type"] ==
                                                      "image"
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                messageList[
                                                                        index]
                                                                    ["message"],
                                                            imageBuilder: (context,
                                                                    url) =>
                                                                message_network_image_shape(
                                                                    url, wdt),
                                                            placeholder: (context,
                                                                    url) =>
                                                                message_asset_image_shape(
                                                                    wdt),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                message_asset_image_shape(
                                                                    wdt),
                                                          ).onTap(() {
                                                            Get.to(
                                                                () =>
                                                                    view_full_image(),
                                                                arguments:
                                                                    messageList[
                                                                            index]
                                                                        [
                                                                        "message"]);
                                                          }),
                                                          2.heightBox,
                                                          Text(
                                                              "${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch((int.parse(messageList[index]["time"]) / 1000).toInt()).toLocal())}",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      darkFontGreyColor))
                                                        ])
                                                  : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                          Text(
                                                            "${messageList[index]["message"]}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    darkFontGreyColor),
                                                          ),
                                                          Text(
                                                              "${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch((int.parse(messageList[index]["time"]) / 1000).toInt()).toLocal())}",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      darkFontGreyColor)),
                                                        ])
                                                      .box
                                                      .color(messageList[index]
                                                                  ["sender"] !=
                                                              drawerController
                                                                  .pref_userId
                                                                  .value
                                                          ? lightGreyColor
                                                          : Vx.yellow200)
                                                      .padding(
                                                          EdgeInsets.all(10))
                                                      .rounded
                                                      .make())
                                          .box
                                          .margin(EdgeInsets.only(
                                              right: 15, top: 2.5, bottom: 2.5))
                                          .make()
                                    ],
                                  ),
                                ]);
                              }),
                    ),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Material(
                      child: InkWell(
                        onTap: () async {
                          pick_image(context);
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Ink(
                          height: 40,
                          width: 40,
                          color: whiteColor,
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            image_icon,
                            color: darkFontGreyColor,
                          ),
                        ),
                      ),
                    ).marginOnly(
                      left: 10,
                      right: 5,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Write here...',
                          filled: true,
                          fillColor: lightGreyColor,
                          contentPadding: const EdgeInsets.all(8),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                          counterText: '',
                          counterStyle: TextStyle(
                            fontSize: 0,
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                        maxLines: 5,
                        minLines: 1,
                        maxLength: 1000,
                        controller: message_txt_controller,
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () async {
                          if (!message_txt_controller.text.trim().isEmpty)
                            send_message(
                                "text", message_txt_controller.text.trim());
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Ink(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(10),
                            color: whiteColor,
                            child: SvgPicture.asset(
                              send_icon,
                              color: darkFontGreyColor,
                            )),
                      ),
                    ).marginOnly(left: 5, right: 10)
                  ]).marginOnly(bottom: 5, top: 5)
                ],
              ),
            )
          ],
        ),
      ).box.color(whiteColor).make(),
    );
  }

  calculate_difference_of_date(today, next_day) {
    if (DateFormat('EEEE, MMM d, yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                    (int.parse(today["time"]) / 1000).toInt())
                .toLocal()) ==
        DateFormat('EEEE, MMM d, yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                    (int.parse(next_day["time"]) / 1000).toInt())
                .toLocal())) {
      return false;
    }
    return true;
  }

  pick_image(context) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? img = await imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List response =
        (await FlutterImageCompress.compressWithFile(img!.path, quality: 25))!;

    if (response != null) {
      Reference reference = send_img_docreference
          .ref()
          .child("message_image")
          .child(drawerController.pref_userId.value)
          .child(new DateTime.now().microsecondsSinceEpoch.toString());
      try {
        await reference.putData(response);
        String img_url = await reference.getDownloadURL();
        send_message("image", img_url);
      } catch (e) {
        show_snackbar(context, e.toString(), whiteColor, Colors.red);
      }
    }
  }

  send_message(type, message_text) {
    if (type != "image") message_txt_controller.clear();

    String message_time = new DateTime.now().microsecondsSinceEpoch.toString();
    Map<String, String> sender_info,
        reciever_info,
        sender_last_message_info,
        reciever_last_message_info;

    final batch = firebase_instance.batch();
    var sender_message =
        messages_docreference.doc(sender.value).collection("chats").doc();
    sender_info = {
      "message": message_text,
      "message_type": type,
      "sender": drawerController.pref_userId.value,
      "time": message_time,
    };
    batch.set(sender_message, sender_info);
    var reciever_message =
        messages_docreference.doc(reciever.value).collection("chats").doc();
    reciever_info = {
      "message": message_text,
      "message_type": type,
      "sender": drawerController.pref_userId.value,
      "time": message_time
    };
    batch.set(reciever_message, reciever_info);
    var sender_last_message = messages_docreference.doc(sender.value);
    sender_last_message_info = {
      "image": widget.brand_icon,
      "name": widget.brand_name,
      "message": message_text,
      "message_type": type,
      "sender": drawerController.pref_userId.value,
      "message_room_for": drawerController.pref_userId.value,
      "messaging_with": widget.brand_id,
      "seen": "true",
      "time": message_time
    };
    batch.set(sender_last_message, sender_last_message_info);
    var reciever_last_message = messages_docreference.doc(reciever.value);
    reciever_last_message_info = {
      "image": drawerController.pref_info["profile_picture"],
      "name": drawerController.pref_info["name"],
      "message": message_text,
      "message_type": type,
      "sender": drawerController.pref_userId.value,
      "message_room_for": widget.brand_id,
      "messaging_with": drawerController.pref_userId.value,
      "seen": "false",
      "time": message_time
    };
    batch.set(reciever_last_message, reciever_last_message_info);
    batch.commit();
  }
}
