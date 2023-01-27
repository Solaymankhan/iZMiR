import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget all_product_cart(item, description, het, wdt) {
  return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: item.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: het > wdt ? 2 : 5,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          mainAxisExtent: 250),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Material(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(6),
                child: Ink(
                  height: 244,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: lightGreyColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(item[index]),
                                  ))).box.padding(EdgeInsets.all(3)).make(),
                          Container(
                            color: lightGreyColor,
                            padding: EdgeInsets.all(1),
                            child: Text(
                              "15% Discount",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: orangeColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                              .box
                              .alignCenterRight
                              .rounded
                              .padding(EdgeInsets.only(top: 5, right: 5))
                              .make(),
                        ],
                      ),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ).box.padding(EdgeInsets.all(3)).make(),
                      3.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icon/taka_svg.svg',
                                    width: 15,
                                  ),
                                  Text(
                                    "150",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )),
                          Flexible(
                              flex: 1,
                              child: Stack(children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icon/taka_svg.svg',
                                      width: 15,
                                      color: orangeColor,
                                    ),
                                    Text(
                                      "150",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: orangeColor),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                  margin: EdgeInsets.only(top: 10, right: 10),
                                )
                              ]))
                        ],
                      ).box.padding(EdgeInsets.all(3)).make(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ).box.padding(EdgeInsets.all(3)).make();
      });
}
