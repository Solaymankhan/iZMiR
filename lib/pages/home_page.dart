import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/consts/lists.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shapes/buttons.dart';
import '../shapes/all_product_cart.dart';
import '../shapes/hot_deals_cart.dart';
import '../shapes/other_products_cart.dart';
import '../shapes/product_heading.dart';
import '../shapes/circuler_buttons.dart';
import '../shapes/sets_cart.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  List<String> item = [];
  bool isLoadingData = false;
  bool hasMoreData = true;
  final ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(() {
      if(_scrollController.offset==_scrollController.position.maxScrollExtent){
        getData();
      }
    });
    super.initState();
    getData();

  }

  void getData() async {
    if (!isLoadingData && hasMoreData) {
      isLoadingData = true;
      setState(() {});
      List<String> dummyDataList = item.length >= banner_list.length
          ? []
          : List.generate(banner_list.length<8?banner_list.length:8,
              (index) => banner_list[index+item.length]);
      if (dummyDataList.isEmpty) {
        hasMoreData = false;
      }
      item.addAll(dummyDataList);
      isLoadingData = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var discount = 15;
    String description="sadfajof dfjaoij adoifj sdadifj oiddescription";
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Container(
      color: whiteColor,
      width: wdt,
      height: het,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                    flex: 2,
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 80,
                        decoration: new BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(6),
                          image: new DecorationImage(
                            image: new AssetImage(izmir_name_icon),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                Flexible(
                  flex: 5,
                  child: Container(
                      color: whiteColor,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: TextField(
                        cursorColor: darkBlueColor,
                        // onChanged: (value) => _runFilter(value),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightGreyColor,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          hintText: srchany,
                          suffixIcon: Icon(
                            Icons.search,
                            color: darkFontGreyColor,
                          ),
                          // prefix: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none),
                        ),
                      )),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerRight,
                      height: 60,
                      margin: EdgeInsets.only(right: 10),
                      child: Material(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                            height: 40,
                            width: 40,
                            decoration: new BoxDecoration(
                              color: whiteColor,
                            ),
                            child: Icon(CupertinoIcons.bars).onTap(() {}),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        itemCount: banner_list.length,
                        height: het >= wdt ? het * 0.2 : wdt * 0.2,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: new DecorationImage(
                                image: new AssetImage(banner_list[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        circuler_button(wdt, het, men_icon, men),
                        circuler_button(wdt, het, women_icon, women),
                        circuler_button(wdt, het, t_shirt_icon, tshirt),
                        circuler_button(wdt, het, polo_icon, polo),
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        circuler_button(wdt, het, shirt_icon, shirt),
                        circuler_button(wdt, het, pants_icon, pants),
                        circuler_button(wdt, het, glasess_icon, glasess),
                        circuler_button(wdt, het, more_icon, more)
                      ],
                    ),
                    items_heading_cart("Hot deals"),
                    hot_deals_cart(
                        banner_list,
                        "sadfajof dfjaoij adoifj sdadifj oiddescription",
                        het,
                        wdt),
                    items_heading_cart("Sets"),
                    sets_cart(
                        banner_list,
                        "sadfajof dfjaoij adoifj sdadifj oiddescription",
                        het,
                        wdt),
                    items_heading_cart("All Products"),
                    all_product_cart(item, description, het, wdt)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
