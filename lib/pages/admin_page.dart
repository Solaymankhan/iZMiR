import 'package:flutter/cupertino.dart';
import 'package:izmir/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../shapes/bar_with_back_button.dart';
import 'add_category_page.dart';
import 'app_settings_page.dart';
import 'complains_page.dart';

class admin_page extends StatelessWidget {
  admin_page({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: SafeArea(
          child: Column(
            children: [
              bar_with_back_button(context,add_txt),
              Expanded(
                child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            add_buttons(context,CupertinoIcons.circle_grid_3x3_fill,add_category_txt,0),
                            deviderr(),
                            add_buttons(context,CupertinoIcons.settings_solid,app_settings,1),
                            deviderr(),
                            add_buttons(context,CupertinoIcons.envelope,complains_txt,2),
                          ],
                        ).box.margin(EdgeInsets.only(left: 15, right: 15)).make(),
                    )
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget deviderr(){
    return Container(
      color: textFieldGreyColor,
      height: 1,
      margin: EdgeInsets.only(left: 10, right: 10),
    );
  }

  Widget add_buttons(context,icon,title,page){
    return Material(
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          if(page==0){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => add_category_page()));
          }
          else if(page==1){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => app_settings_page()));
          }
          else if(page==2){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => complains_page()));
          }
          },
        child: Ink(
          height: 50,
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: lightGreyColor),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14, color: BlackColor),
              )
            ],
          ),
        ),
      ),
    );
  }

}
