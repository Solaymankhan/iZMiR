import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller_2.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/bar_with_back_button.dart';
import '../shapes/dont_have_any_data.dart';



class my_sales_page extends StatefulWidget {
  my_sales_page({Key? key}) : super(key: key);

  @override
  State<my_sales_page> createState() => _my_sales_pageState();
}

class _my_sales_pageState extends State<my_sales_page> {

  final drawer_controller drawerController = Get.find();
  var _instance = FirebaseFirestore.instance;
  RxList order_batch = [].obs, order_batch_ids = [].obs;
  RxBool is_loading_finished=false.obs;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      fetch_data();
    });
    super.initState();
  }

  fetch_data() async {
    try{
      await _instance
          .collection("orders")
          .where("referral_code",
          isEqualTo: drawerController.pref_info["referral_code"])
          .orderBy("order_time", descending: true)
          .get()
          .then((valu) async {
        for(var val in valu.docs) order_batch_ids.add(val.id);
        order_batch.addAll(valu.docs.map((e) => e.data()));
      });
    }catch(e){

    }
    is_loading_finished.value=true;
  }

  @override
  Widget build(BuildContext context) {
    var het = (MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            bar_with_back_button(context,my_sales_txt),
            Expanded(
              child: Obx(
                    () =>is_loading_finished.value==false?
                    Center(
                        child: CupertinoActivityIndicator(radius: 10)
                            .box
                            .alignCenter
                            .margin(EdgeInsets.only(bottom: 50))
                            .make()):
                    (order_batch.isEmpty && is_loading_finished.value==true
                    ?dont_have_any_data(het)
                    : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: order_batch.length,
                  itemBuilder: (context, index1) {
                    return Column(
                      children: [
                        Text(
                          "Product price : ${order_batch[index1]["order_time"]}\n"
                          "Order time : ${DateFormat('h:mm a , MMM d, yyyy').format(DateTime.fromMillisecondsSinceEpoch((int.parse(order_batch[index1]["total_order_time"]) / 1000).toInt()).toLocal())}",
                          style: TextStyle(
                              color: darkFontGreyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                        Text(
                          "Ordur status : ${order_batch[index1]["order_activity"]}",
                          style: TextStyle(
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    ).box
                        .width(double.infinity)
                        .customRounded(BorderRadius.all(Radius.circular(6.0)))
                        .padding(EdgeInsets.all(10))
                        .margin(EdgeInsets.only(left: 15, right: 15))
                        .color(lightGreyColor)
                        .make();
                  },
                ))
              ),
            )
          ],
        ),
      ).color(whiteColor),
    );
  }

}
