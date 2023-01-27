import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget category_heading_cart(category_name) {
  return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 15, top: 10,bottom: 10),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Container(
                  height: 16,
                  width: 5,
                  color: yellowColor,
                ),
                Container(
                  height: 16,
                  width: 5,
                  color: darkBlueColor,
                ),
                Container(
                  height: 16,
                  width: 10,
                ),
                Text(category_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        ],
      ));
}
