
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:izmir/consts/consts.dart';

import '../controllers/notification_controller.dart';
import '../shapes/notification_shape.dart';

class notification_page extends StatelessWidget {
  final notificationController = Get.put(notification_controller());

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Container(
      color: Colors.white,
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
              child: Text(
                notification_txt,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Flexible(
              child: GetBuilder<notification_controller>(builder: (controller) {
                return notification_shape(notificationController,wdt);
              }),
            )
          ],
        ),
      ),
    );
  }
}
