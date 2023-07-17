

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/consts.dart';
import '../pages/view_category_items.dart';
import '../shapes/all_product_network_image_shape.dart';
import 'category_controller.dart';


class app_setting_controller extends GetxController {
  final category_controller categoryController=Get.find();
  var settings_docreference= FirebaseFirestore.instance.collection("app_settings").doc("setting");
  var banner_prev_img_list = [].obs;
  var seasonal_sale_name=''.obs;
  RxMap setting_list=new RxMap();


  @override
  void onInit() {
    fetch_app_setting();
    super.onInit();
  }


  fetch_app_setting() async{
      await settings_docreference
          .snapshots()
          .listen((doc) {
        banner_prev_img_list.value=doc["banner_img"].toString().trim().split("  ");
        setting_list.value=doc.data() as Map;
        seasonal_sale_name.value=doc["season_sale_name"];
      });
  }



  Widget seaconal_sales_demo(het, wdt) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10,bottom: 20),
      child: GridView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount:setting_list["season_sale_categories"].length,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: wdt>600?250:wdt/2,
            ),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                          Get.to(() => view_category_items(category_name: setting_list["season_sale_categories"][index]["category_name"],));
                      },
                      child: CachedNetworkImage(
                        imageUrl: setting_list["season_sale_categories"][index]["category_icon"],
                        imageBuilder: (context, url)=>special_sales_network_image_shape(url,wdt),
                        placeholder: (context, url)=> special_sales_asset_image_shape(wdt),
                        errorWidget: (context, url, error) =>  special_sales_asset_image_shape(wdt),
                      ),

                    ),
                  ),
                  Text(
                    setting_list["season_sale_categories"][index]["category_name"]
                    ,style: TextStyle(
                      fontSize: 15,fontWeight: FontWeight.w400,color: darkBlueColor
                  ),).box.color(yellowColor.withOpacity(0.7)).customRounded(BorderRadius.circular(10))
                      .rounded.margin(EdgeInsets.all(5)).padding(EdgeInsets.all(5)).make()
                ],)
                  .box.margin(EdgeInsets.only(left: index==0||index==1?15:2,
                  right: (setting_list["season_sale_categories"].length%2==0)?
                  (index==setting_list["season_sale_categories"].length-1||
                      index==setting_list["season_sale_categories"].length-2?15:2):
                  index==setting_list["season_sale_categories"].length-1?15:2,top: 2,bottom: 2))
                  .make();
            }),
    );
  }

  Widget seaconal_sales(het, wdt,from) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: ((OverscrollIndicatorNotification? notificaton) {
        notificaton!.disallowIndicator();
        return true;
      }),
      child:Container(
        height: 200,
        width: double.infinity,
        child: GridView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: setting_list["season_sale_categories"].length>20?20:
            setting_list["season_sale_categories"].length,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: wdt/2,
            ),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if(from=="view"){
                          Get.to(() => view_category_items(category_name: setting_list["season_sale_categories"][index]["category_name"],));
                        }else{
                          /*showAlertDialog(context, event_id_list[index],
                                  eventlist[index]['event_img']); */
                        }

                      },
                      child: CachedNetworkImage(
                        imageUrl: setting_list["season_sale_categories"][index]["category_icon"],
                        imageBuilder: (context, url)=>special_sales_network_image_shape(url,wdt),
                        placeholder: (context, url)=> special_sales_asset_image_shape(wdt),
                        errorWidget: (context, url, error) =>  special_sales_asset_image_shape(wdt),
                      ),

                    ),
                  ),

                  Opacity(
                    opacity: 0.7,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: yellowColor
                      ),
                      child: Text(
                        setting_list["season_sale_categories"][index]["category_name"]
                        ,style: TextStyle(
                          fontSize: 15,fontWeight: FontWeight.w400,color: darkBlueColor
                      ),),
                    ),
                  )
                ],).box.margin(EdgeInsets.all(2)).make();
            }),
      ),
    );
  }

  Widget seaconal_sales_vertical(het, wdt) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: setting_list["season_sale_categories"].length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 100,
        ),
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                      Get.to(() => view_category_items(category_name: setting_list["season_sale_categories"][index]["category_name"],));
                  },
                  child: CachedNetworkImage(
                    imageUrl: setting_list["season_sale_categories"][index]["category_icon"],
                    imageBuilder: (context, url)=>special_sales_network_image_shape(url,wdt),
                    placeholder: (context, url)=> special_sales_asset_image_shape(wdt),
                    errorWidget: (context, url, error) =>  special_sales_asset_image_shape(wdt),
                  ),

                ),
              ),

              Opacity(
                opacity: 0.7,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: yellowColor
                  ),
                  child: Text(
                    setting_list["season_sale_categories"][index]["category_name"]
                    ,style: TextStyle(
                      fontSize: 15,fontWeight: FontWeight.w400,color: darkBlueColor
                  ),),
                ),
              )
            ],).box.margin(EdgeInsets.all(2)).make();
        }).marginOnly(left: 13,right: 13);
  }

/*  showAlertDialog(BuildContext context, event_id, event_img) async =>
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
      );*/

}
