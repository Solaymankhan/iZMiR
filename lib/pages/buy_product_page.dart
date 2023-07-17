import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import '../controllers/buy_controller.dart';
import '../controllers/drawer_controller.dart';
import '../shapes/bar_with_back_button.dart';

class buy_product_page extends StatefulWidget {
  @override
  State<buy_product_page> createState() => _buy_product_pageState();
}

class _buy_product_pageState extends State<buy_product_page> {
  final buyController = Get.put(buy_controller());
  final drawer_controller drawerController = Get.find();

  @override
  void initState() {
    fetch_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Obx(
      () => Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            bar_with_back_button(context,ordr_dtls_txt),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order by : ${drawerController.pref_info["name"]}\n"
                          "${drawerController.pref_info["phone"]}\n"
                          "${drawerController.pref_info["email"]}",
                          style: TextStyle(
                              color: darkFontGreyColor,
                              fontWeight: FontWeight.w500, fontSize: 14),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${buyController.district.value}, ${buyController.division.value}\n"
                                "${buyController.address.value}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: darkFontGreyColor,
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            onTap: () {
                              buyController.address_edit_sheet(context);
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Ink(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  CupertinoIcons.pencil,
                                  color: darkFontGreyColor,
                                )),
                          ),
                        )
                      ],
                    ),
                    15.heightBox,
                    buyController.buy_shape(het, wdt),
                    15.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Use account balance ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icon/taka_svg.svg',
                              width: 14,
                              color: darkFontGreyColor,
                            ),
                            Text(
                              drawerController.account_balance_txt.value,
                              style: TextStyle(
                                  color: darkFontGreyColor,
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(50),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    buyController.is_account_balance_selected.value =
                                        !buyController.is_account_balance_selected.value;
                                    print(buyController.is_account_balance_selected.value
                                        .toString());
                                    buyController.total_price_calculator();
                                  },
                                  child: Ink(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: whiteColor),
                                    child: Container(
                                      width: 20,
                                      padding: EdgeInsets.all(10),
                                      child: buyController.is_account_balance_selected.value
                                          ? SvgPicture.asset(
                                              green_circle_icon,
                                            )
                                          : SvgPicture.asset(
                                              white_circle_icon,
                                            ),
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Use Referral code ",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ).marginOnly(right: 10),
                        ),
                        ConstrainedBox(
                           constraints: BoxConstraints(
                             maxWidth: 200.0,
                           ),
                           child: TextFormField(
                        decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6),
                          ),
                          labelText: "Code",
                          counterText: '',
                          counterStyle: TextStyle(
                         fontSize: 0,
                          ),
                        ),
                maxLength: 26,
                onChanged: (val) {
                  buyController.refer_code.value =val.toString();
                  buyController.total_price_calculator();
                },
              ),
                         ),
                      ],
                    ).box.height(35).make(),
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Product Price ",
                            style: TextStyle(
                              color: darkFontGreyColor,
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 14,
                                color: darkFontGreyColor,
                              ),
                              Text(
                                "${buyController.product_total_price.value}",
                                style: TextStyle(
                                    color: darkFontGreyColor,
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Account balance ",
                            style: TextStyle(
                                color: darkFontGreyColor,
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 14,
                                color: darkFontGreyColor,
                              ),
                              Text(
                                "-${buyController.account_balance.value}",
                                style: TextStyle(
                                    color: darkFontGreyColor,
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Off on refer ",
                            style: TextStyle(
                                color: darkFontGreyColor,
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                color: darkFontGreyColor,
                                width: 14,
                              ),
                              Text(
                                "-${buyController.off_on_refer_buyer.value}",
                                style: TextStyle(
                                    color: darkFontGreyColor,
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery fee ",
                            style: TextStyle(
                                color: darkFontGreyColor,
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 14,
                                color: darkFontGreyColor,
                              ),
                              Text(
                                "${buyController.delivery_fee.value}",
                                style: TextStyle(
                                    color: darkFontGreyColor,
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      10.heightBox,
                      Container().box.height(1).color(textFieldGreyColor).make(),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total ",
                            style: TextStyle(
                                color: darkFontGreyColor,
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/taka_svg.svg',
                                width: 14,
                                color: darkFontGreyColor,
                              ),
                              Text(
                                "${buyController.total_price.value}",
                                style: TextStyle(
                                    color: darkFontGreyColor,
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],).box.margin(EdgeInsets.only(top: 10))
                    .color(lightGreyColor).padding(EdgeInsets.all(10))
                        .customRounded(BorderRadius.all(Radius.circular(6))).make(),
                    45.heightBox
                  ],
                ).marginOnly(left: 15, right: 15),
              ),
            ),
          ],
        )).color(whiteColor),
        bottomNavigationBar:Obx(
              () =>  Visibility(
                visible: !buyController.cart_products.isEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Total : ",
                      style: TextStyle(
                          color: darkFontGreyColor,
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SvgPicture.asset(
                      'assets/icon/taka_svg.svg',
                      width: 16,
                      color: darkFontGreyColor,
                    ),
                    Text(
                      "${buyController.total_price.value}",
                      style: TextStyle(
                          color: darkFontGreyColor,
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Material(
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: () {
                      buyController.call_payment_gateway_sheet(context);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: darkBlueColor,
                      ),
                      height: 40.0,
                      width: wdt * 0.35,
                      child: Text(
                        order_now_txt,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: yellowColor,
                            fontWeight: FontWeight.w500),
                      ).box.alignCenter.make(),
                    ),
                  ),
                ).box.margin(EdgeInsets.all(3)).make(),
              ],
            )
                .box
                .padding(EdgeInsets.only(right: 20, left: 20))
                .color(lightGreyColor)
                .make(),
          ),
        ),
      ),
    );
  }

  fetch_data() async {
    await Future.delayed(Duration(milliseconds: 200), () async {
      buyController.get_product_data();
    });
  }
}
