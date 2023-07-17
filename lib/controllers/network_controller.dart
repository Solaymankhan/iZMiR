import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:izmir/shapes/snack_bar.dart';
import '../consts/consts.dart';

class network_controller extends GetxController {
  var connectionStatus = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late BuildContext context;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit(){
    super.onInit();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      show_snackbar(context, e.message, whiteColor, Colors.red);
    }
    return _updateConnectionStatus(result);
  }

  _updateConnectionStatus(ConnectivityResult result) {

    switch (result) {
      case ConnectivityResult.ethernet:
        connectionStatus.value = 1;
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 1;
        break;
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        break;
      default:
        connectionStatus.value = 0;
        Get.snackbar("Network Error", "Failed to get network connection");
        break;
    }
  }

  @override
  void onClose(){
    _connectivitySubscription.cancel();
  }
}
