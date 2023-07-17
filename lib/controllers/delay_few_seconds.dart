

import 'package:get/get.dart';

class delay_few_seconds extends GetxController{
  late RxBool is_loading=true.obs;
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1),(){
      is_loading.value=false;
    });
    super.onInit();
  }
}