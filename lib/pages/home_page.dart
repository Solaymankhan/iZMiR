import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/consts/lists.dart';
import 'package:velocity_x/velocity_x.dart';

class home_page extends StatelessWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerRight,
                    decoration: new BoxDecoration(
                      color: whiteColor,
                    ),
                    child: Icon(CupertinoIcons.bars),margin: EdgeInsets.only(right: 10.0),

                  ),
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
                        height:het>=wdt? het*0.2:wdt*0.2,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(3),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: new DecorationImage(
                                image: new AssetImage(banner_list[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
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
