
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:izmir/consts/consts.dart';

import '../controllers/notification_controller.dart';
import '../controllers/notification_controller_2.dart';
import '../shapes/bar_with_back_button.dart';

class notification_page_2 extends StatelessWidget {
  notification_page_2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(notification_controller_2());
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,notification_txt),
              Flexible(
                  child: Container()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
