import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget category_button_cart(item_icon_list,item_name_list,het,wdt) {
  return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: item_icon_list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: het > wdt ? 5 : 7,
          ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Material(
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: (){},
                child: Ink(

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightGreyColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item_icon_list[index],
                        width: wdt*2<het?wdt * 0.05:het* 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            5.heightBox,
            Text(
              item_name_list[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        );
      });
}
