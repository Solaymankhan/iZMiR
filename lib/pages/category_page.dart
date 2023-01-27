
import 'package:izmir/consts/consts.dart';
import 'package:izmir/consts/lists.dart';
import '../shapes/category_button_card.dart';
import '../shapes/category_heading.dart';
import '../shapes/product_heading.dart';

class category_page extends StatefulWidget {
  const category_page({Key? key}) : super(key: key);

  @override
  State<category_page> createState() => _category_pageState();
}

class _category_pageState extends State<category_page> {
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
            Container(
              height: 60,
              width: wdt,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15),
              child: Text(categories_txt,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    category_heading_cart("Men"),
                    category_button_cart(item_icon_list,item_name_list,het,wdt),
                    category_heading_cart("Women"),
                    category_button_cart(item_icon_list,item_name_list,het,wdt),
                    category_heading_cart("Kids"),
                    category_button_cart(item_icon_list,item_name_list,het,wdt),
                    category_heading_cart("Common"),
                    category_button_cart(item_icon_list,item_name_list,het,wdt),
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
