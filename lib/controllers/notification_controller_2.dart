import 'package:get/get.dart';
import 'package:izmir/model/product_model.dart';
import 'package:izmir/consts/lists.dart';

import '../consts/consts.dart';
class notification_controller_2 extends GetxController{
  List<product_model> cart_data=[];

  bool isLoadingData = false;
  bool hasMoreData = true;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement initState
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getData();
      }
    });
    super.onInit();
    getData();
  }

  void getData() async {
    if (!isLoadingData && hasMoreData) {
      isLoadingData = true;
      List<product_model> dummyDataList = cart_data.length >=
          product_data_from_server.length
          ? []
          : List.generate(10,
              (index) => product_data_from_server[index + cart_data.length]);
      if (dummyDataList.isEmpty) {
        hasMoreData = false;
      }
      cart_data.addAll(dummyDataList);
      isLoadingData = false;
      update();
    }
  }

}