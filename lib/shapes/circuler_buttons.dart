import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget circuler_button(wdt, het, icon, title) {
  return Column(
    children: [
      Material(
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: (){},
          child: Ink(
            width: wdt * 0.2,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightGreyColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      5.heightBox,
      Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
        ),
      )
    ],
  );
}
