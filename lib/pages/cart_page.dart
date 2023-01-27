import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/lists.dart';
import '../shapes/category_button_card.dart';
import '../shapes/category_heading.dart';

class cart_page extends StatefulWidget {
  const cart_page({Key? key}) : super(key: key);

  @override
  State<cart_page> createState() => _cart_pageState();
}

class _cart_pageState extends State<cart_page> {
  List<String> item = [];
  bool isLoadingData = false;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
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
          : List.generate(8,
              (index) => banner_list[index + item.length]);
      if (dummyDataList.isEmpty) {
        hasMoreData = false;
      }
      item.addAll(dummyDataList);
      isLoadingData = false;
      setState(() {});
    }
  }

  bool is_selected = false;

  @override
  Widget build(BuildContext context) {
    String description = "sadfajof dfjaoij adoifj sdadifj oiddescription";
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Container(
      color: whiteColor,
      width: wdt,
      height: het,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              width: wdt,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                cart_txt,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is_selected = !is_selected;
                    });
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: is_selected ? darkBlueColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: is_selected
                            ? null
                            : Border.all(color: lightGreyColor, width: 2)),
                    child: is_selected
                        ? Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 13,
                          )
                        : null,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    select_all,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: item.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 75
                        ),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(6),
                                  child: Ink(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: lightGreyColor),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              is_selected = !is_selected;
                                            });
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: is_selected
                                                    ? darkBlueColor
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: is_selected
                                                    ? null
                                                    : Border.all(
                                                        color: lightGreyColor,
                                                        width: 2)),
                                            child: is_selected
                                                ? Icon(
                                                    Icons.check,
                                                    color: whiteColor,
                                                    size: 13,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        Container(
                                            height: 60,
                                            width: 60,
                                            margin: EdgeInsets.only(left: 5,right: 5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(item[index]),
                                                ))).box.padding(EdgeInsets.all(3)).make(),
                                        Column(children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(description),
                                              ),
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: Icon(Icons.delete),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                child: Text("100"),
                                              ),
                                              Container(
                                                alignment: Alignment.bottomRight,
                                                child: Text("hel"),
                                              )
                                            ],
                                          )
                                        ],)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
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
