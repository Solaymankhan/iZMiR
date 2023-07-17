import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/pages/view_category_items.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/category_controller.dart';
import '../shapes/all_product_network_image_shape.dart';

class category_page extends StatelessWidget {

  final category_controller categoryController=Get.find();

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return   Obx(()=> categoryController.allCategoryFrontlist.isEmpty?
    CupertinoActivityIndicator(radius: 10)
        .box
        .alignCenter
        .make()
        : Container(
        color: whiteColor,
        width: wdt,
        height: het,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                width: wdt,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                child: Text(categories_txt,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),
              ),
              Expanded(
                child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categoryController.allCategoryFrontlist.length,
                          itemBuilder: (context, index) {
                            return  Material(
                              color: categoryController.selected_category_front_index.value==index?
                              textFieldGreyColor:Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () async{
                                  categoryController.allsubCategoryFrontlist.clear();
                                  categoryController.selected_category_front_index.value=index;
                                  await categoryController.get_front_subcategory_data(
                                      categoryController.allCategoryFrontlist[index]["category_id"]
                                  );
                                },
                                child:
                                [CachedNetworkImage(
                                  imageUrl: categoryController.allCategoryFrontlist[index]["category_icon"],
                                  imageBuilder: (context, url)=>brand_ink_network_image_shape(url),
                                  placeholder: (context, url)=> brand_ink_asset_image_shape(),
                                  errorWidget: (context, url, error) =>  brand_ink_asset_image_shape(),
                                ),
                                  5.heightBox,
                                  Text(
                                    categoryController.allCategoryFrontlist[index]["category_name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ].column().paddingOnly(top: 10,bottom: 10),
                              ),
                            );
                          }),
                    ).box.color(lightGreyColor).width(wdt>600?150:90).make(),
                    Expanded(
                      child:categoryController.allsubCategoryFrontlist.isEmpty?
                      CupertinoActivityIndicator(radius: 10)
                          .box
                          .alignCenter
                          .make()
                          : GridView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categoryController.allsubCategoryFrontlist.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 600 > wdt ? 3 : 7,
                          ),
                          itemBuilder: (context, index) {
                            return Material(
                              borderRadius: BorderRadius.circular(6),
                              color: whiteColor,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => view_category_items
                                            (category_name: categoryController.allsubCategoryFrontlist[index]
                                          ['sub_category_name'],)));
                                },
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: categoryController.allsubCategoryFrontlist[index]['sub_category_icon'],
                                      imageBuilder: (context, url)=>brand_ink_network_image_shape(url),
                                      placeholder: (context, url)=> brand_ink_asset_image_shape(),
                                      errorWidget: (context, url, error) =>  brand_ink_asset_image_shape(),
                                    ),
                                    5.heightBox,
                                    Text(
                                      categoryController.allsubCategoryFrontlist[index]['sub_category_name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ).marginOnly(left: 5,right: 5)
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ).marginOnly(left: 15,right: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
