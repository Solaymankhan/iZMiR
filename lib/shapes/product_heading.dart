import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget items_heading_cart(category_name) {
  var va=category_name=="All Products"?"":"View all... ";
  return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 15, top: 20),
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
          Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: Material(
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: (){},
                    child: Ink(
                      padding: EdgeInsets.all(2),
                      child: Text(va,style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                  ),
                ),
              ))
        ],
      ));
}
