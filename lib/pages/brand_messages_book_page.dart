import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/brands_controller.dart';
import '../controllers/cart_controller_2.dart';
import '../shapes/all_product_network_image_shape.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/dont_have_any_data.dart';
import 'brand_message_page.dart';



class brand_messages_book_page extends StatelessWidget {
  brand_messages_book_page({Key? key,required this.brand_details,required this.brand_id}) : super(key: key);
  var brand_details,brand_id;
  final brands_controller brandController = Get.find();
  var messages_docreference = FirebaseFirestore.instance.collection("messages");
  RxString brand_icon = ''.obs,
      brand_verified = ''.obs,
      sender = ''.obs,
      reciever = ''.obs;
  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,messages_txt),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: messages_docreference
                        .where("message_room_for", isEqualTo: brand_id)
                        .orderBy("time",descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return dont_have_any_data(het);
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            height: het - 120,
                            child: CupertinoActivityIndicator(radius: 10)
                                .box
                                .alignCenter
                                .make());
                      }
                      if (snapshot.data!.docs.length == 0) {
                        return dont_have_any_data(het);
                      }
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return Material(
                              borderRadius: BorderRadius.circular(6),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () async{
                                    Get.to(()=>brand_message_page(brand_id: brand_id,brand_info: brand_details,user_info: doc));
                                    await messages_docreference.doc(doc.id).update({"seen": "true"});
                                  },
                                  child: Ink(
                                    padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: lightGreyColor),
                                    child: Row(children: [
                                      CachedNetworkImage(
                                            imageUrl: doc["image"],
                                            imageBuilder: (context, url)=>brand_network_image_shape(url),
                                            placeholder: (context, url)=> brand_asset_image_shape(),
                                            errorWidget: (context, url, error) =>  brand_asset_image_shape(),
                                          ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                              Expanded(
                                                child: Text(
                                                  "${doc["name"]}",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: doc["sender"]!=brand_id && doc["seen"]=="false"?FontWeight.w500:FontWeight.w400,
                                                      color: doc["sender"]!=brand_id && doc["seen"]=="false"?
                                                      darkFontGreyColor:darkFontGreyColor
                                                  ),
                                                ).box.margin(EdgeInsets.only(left: 5)).make(),
                                              ),
                                              Text(
                                                    " ${DateFormat('h:mm a , MMM d, yyyy').format(DateTime.fromMillisecondsSinceEpoch
                                                  ((int.parse(doc["time"]) / 1000).toInt())
                                                    .toLocal())}"
                                                ,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: doc["sender"]!=brand_id && doc["seen"]=="false"?FontWeight.w500:FontWeight.w400,
                                                    color: doc["sender"]!=brand_id && doc["seen"]=="false"?
                                                    darkFontGreyColor:darkFontGreyColor
                                                ),
                                              ).box.margin(EdgeInsets.only(left: 5)).make(),
                                            ],),
                                          Text(
                                            "${doc[ "message_type"]=="image"?"image":doc["message"]}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: doc["sender"]!=brand_id && doc["seen"]=="false"?FontWeight.w500:FontWeight.w400,
                                                color: doc["sender"]!=brand_id && doc["seen"]=="false"?
                                                darkFontGreyColor:darkFontGreyColor
                                            ),
                                          ).box.margin(EdgeInsets.only(left: 5)).make()
                                        ],),
                                      )
                                    ],),
                                  )
                              ),
                            ).box
                                .margin(EdgeInsets.only(left: 15,right: 15,top: 0.5,bottom: 0.5))
                                .make();
                          });
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
