import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:izmir/controllers/home_controller.dart';
import 'package:izmir/controllers/network_controller.dart';
import 'package:izmir/firebase_options.dart';
import 'package:izmir/pages/cart_page.dart';
import 'package:izmir/pages/category_page.dart';
import 'package:izmir/pages/notification_page.dart';
import 'package:izmir/shapes/navigation_drawer.dart';
import 'package:izmir/shapes/no_internet.dart';
import 'consts/consts.dart';
import 'package:flutter/services.dart';
import 'package:izmir/pages/home_page.dart';
import 'controllers/app_setting_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/drawer_controller.dart';
import 'dart:ui';
import 'controllers/loading_dialogue_controller.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light)
  );

  runApp(home());
}

class home extends StatelessWidget {
  home({Key? key}) : super(key: key);

  var controller = Get.put(HomeController());
  final drawerController = Get.put(drawer_controller());
  final networkController = Get.put(network_controller());
  final categoryController = Get.put(category_controller());
  final loadingController = Get.put(loading_dialogue_controller());
  final appSettingController = Get.put(app_setting_controller());

  List<BottomNavigationBarItem> navbar_itm=[];
  List<Widget> nav_body=[];

  @override
  Widget build(BuildContext context) {
    load_data();
    var pixelRatio = window.devicePixelRatio.obs;
    var logicalScreenSize = (window.physicalSize / pixelRatio.value).obs;
    var wdt = logicalScreenSize.value.width.obs;
    int in_page=0;

    return GetMaterialApp(
      title: 'iZMiR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(primary: darkBlueColor),
      ),
      home: Obx(()=>Container(child: networkController.connectionStatus.value!=1?
          no_internet():Scaffold(
          drawerEnableOpenDragGesture: false,
          key: drawerController.scaffold_key,
          drawer:  GetBuilder<drawer_controller>(builder: (controller) { return navigation_drawer();}),
          body: Column(
            children: [
              Obx(() => Expanded(
                  child: IndexedStack(index: controller.current_nav_indx.value,children: nav_body))),
            ],
          ),
          bottomNavigationBar: Container(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              child: Obx(
                () => BottomNavigationBar(
                  currentIndex: controller.current_nav_indx.value,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: darkBlueColor,
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w500),
                  backgroundColor: lightGreyColor,
                  items: navbar_itm,
                  onTap: (value){
                    controller.current_nav_indx.value = value;
                    final cart_controller cartController =Get.find();
                    if(value==3 && in_page!=3){
                      cartController.is_all_selected.value = false;
                      Future.delayed(Duration(milliseconds: 100), () async{
                          in_page=value;
                          await cartController.get_product_data();
                      });
                    }else if(value!=3 && in_page==3){
                      in_page=value;
                      cartController.total_price.value='0';
                      cartController.isCompleted.value=false;
                      drawerController.cart.forEach((key, value) {
                        cartController.product_selected_map[key]!.fillRange(0, value.length,false);
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        )),
      )
    );
  }


  load_data()async{
  navbar_itm = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.house_fill), label: home_txt),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
        label: categories_txt),
    BottomNavigationBarItem(
      //icon: Icon(CupertinoIcons.chat_bubble_text_fill),
        icon: Icon(CupertinoIcons.bell_fill),
        label: notification_txt),
    BottomNavigationBarItem(
        icon:drawerController.notification_icon()
        , label: cart_txt
    )
  ];
  nav_body = [
    home_page(),
    category_page(),
    notification_page(),
    cart_page(),
  ];
}


}
