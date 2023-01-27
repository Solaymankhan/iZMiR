import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget squer_button(wdt, het, icon, title) {
  return Material(
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: (){},
      child: Ink(
        height: 60,
        width: wdt * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: lightGreyColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 30,
            ),
            5.heightBox,
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
