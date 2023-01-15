import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/consts/lists.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shapes/buttons.dart';

class home_page extends StatelessWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var discount=15;
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
                        home_button(
                            wdt, het, 'assets/icon/women_svg.svg', women),
                        home_button(wdt, het, 'assets/icon/boy_svg.svg', men)
                      ],
                    ),
                    10.heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(sets,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              banner_list.length,
                              (index) => Column(
                                    children: [
                                      Material(
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Ink(
                                            height: 180,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  banner_list[
                                                                      index]),
                                                            )))
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                Text(
                                                  "Solaymanoeunoidupoicnv u pousioufcmfurouv ruopuvnuifuhfui",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                3.heightBox,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icon/taka_svg.svg',
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "1,50,000",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                    Flexible(
                                                        flex: 1,
                                                        child: Stack(children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icon/taka_svg.svg',
                                                                width: 15,
                                                                color:
                                                                    orangeColor,
                                                              ),
                                                              Text(
                                                                "1,50,000",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        orangeColor),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: Colors.black,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 10),
                                                          )
                                                        ]))
                                                  ],
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ).box.padding(EdgeInsets.all(3)).make()),
                        ),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(sets,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              banner_list.length,
                              (index) => Column(
                                    children: [
                                      Material(
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Ink(
                                            height: 180,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  banner_list[
                                                                      index]),
                                                            )))
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                Text(
                                                  "Solaymanoeunoidupoicnv u pousioufcmfurouv ruopuvnuifuhfui",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                3.heightBox,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icon/taka_svg.svg',
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "150",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                    Flexible(
                                                        flex: 1,
                                                        child: Stack(children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icon/taka_svg.svg',
                                                                width: 15,
                                                                color:
                                                                    orangeColor,
                                                              ),
                                                              Text(
                                                                "150",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        orangeColor),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: Colors.black,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 10),
                                                          )
                                                        ]))
                                                  ],
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ).box.padding(EdgeInsets.all(3)).make()),
                        ),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(sets,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              banner_list.length,
                              (index) => Column(
                                    children: [
                                      Material(
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Ink(
                                            height: 180,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  banner_list[
                                                                      index]),
                                                            )))
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                Text(
                                                  "Solaymanoeunoidupoicnv u pousioufcmfurouv ruopuvnuifuhfui",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                3.heightBox,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icon/taka_svg.svg',
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "150",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                    Flexible(
                                                        flex: 1,
                                                        child: Stack(children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icon/taka_svg.svg',
                                                                width: 15,
                                                                color:
                                                                    orangeColor,
                                                              ),
                                                              Text(
                                                                "150",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        orangeColor),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: Colors.black,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 10),
                                                          )
                                                        ]))
                                                  ],
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ).box.padding(EdgeInsets.all(3)).make()),
                        ),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(sets,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              banner_list.length,
                              (index) => Column(
                                    children: [
                                      Material(
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Ink(
                                            height: 180,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  banner_list[
                                                                      index]),
                                                            )))
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                Text(
                                                  "Solaymanoeunoidupoicnv u pousioufcmfurouv ruopuvnuifuhfui",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                3.heightBox,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icon/taka_svg.svg',
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "150",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                    Flexible(
                                                        flex: 1,
                                                        child: Stack(children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icon/taka_svg.svg',
                                                                width: 15,
                                                                color:
                                                                    orangeColor,
                                                              ),
                                                              Text(
                                                                "150",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        orangeColor),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: Colors.black,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 10),
                                                          )
                                                        ]))
                                                  ],
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ).box.padding(EdgeInsets.all(3)).make()),
                        ),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(sets,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              banner_list.length,
                              (index) => Column(
                                    children: [
                                      Material(
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Ink(
                                            height: 180,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: lightGreyColor),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  banner_list[
                                                                      index]),
                                                            )))
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                Text(
                                                  "Solaymanoeunoidupoicnv u pousioufcmfurouv ruopuvnuifuhfui",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                                3.heightBox,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icon/taka_svg.svg',
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              "150",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                    Flexible(
                                                        flex: 1,
                                                        child: Stack(children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icon/taka_svg.svg',
                                                                width: 15,
                                                                color:
                                                                    orangeColor,
                                                              ),
                                                              Text(
                                                                "150",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        orangeColor),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: Colors.black,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 10),
                                                          )
                                                        ]))
                                                  ],
                                                )
                                                    .box
                                                    .padding(EdgeInsets.all(3))
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ).box.padding(EdgeInsets.all(3)).make()),
                        ),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(all,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: banner_list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: het > wdt ? 2 : 5,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            mainAxisExtent: 250),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(6),
                                  child: Ink(
                                    height: 244,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: lightGreyColor),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                                    height: 160,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              banner_list[
                                                                  index]),
                                                        )))
                                                .box
                                                .padding(EdgeInsets.all(3))
                                                .make(),
                                            Container(
                                              color: lightGreyColor,
                                              padding: EdgeInsets.all(1),
                                              child:Text(
                                                "$discount% Discount",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: orangeColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500),
                                              ),
                                            )
                                                .box.alignCenterRight.rounded
                                                .padding(EdgeInsets.only(top: 5,right: 5))
                                                .make(),
                                          ],
                                        ),
                                        Text(
                                          "Solaymanoeunoidupoicnv u pousioufcmfurouv ruopuvnuifuhfui",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ).box.padding(EdgeInsets.all(3)).make(),
                                        3.heightBox,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icon/taka_svg.svg',
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      "150",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                )),
                                            Flexible(
                                                flex: 1,
                                                child: Stack(children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icon/taka_svg.svg',
                                                        width: 15,
                                                        color: orangeColor,
                                                      ),
                                                      Text(
                                                        "150",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: orangeColor),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    color: Colors.black,
                                                    margin: EdgeInsets.only(
                                                        top: 10, right: 10),
                                                  )
                                                ]))
                                          ],
                                        ).box.padding(EdgeInsets.all(3)).make(),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ).box.padding(EdgeInsets.all(3)).make();
                        })
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
