import 'package:izmir/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

Widget ohter_product_cart(itm,description,het,wdt) {
  return  Container(
    child: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: ((OverscrollIndicatorNotification ? notificaton){
        notificaton!.disallowIndicator();
        return true;
      }),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              itm.length,
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
                                          itm[
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
  );
}