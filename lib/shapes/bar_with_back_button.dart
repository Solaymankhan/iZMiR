import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';
import '../consts/strings.dart';


Widget bar_with_back_button(context,txt){
  return Row(
    children: [
      Container(
        margin: EdgeInsets.only(left: 10),
      ),
      Container(
          alignment: Alignment.centerRight,
          height: 50,
          margin: EdgeInsets.only(right: 10),
          child: Material(
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(50),
              child: Ink(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(CupertinoIcons.back,color: Colors.black,)),
            ),
          )),
      Text(
        txt,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black),
      ).box.margin(EdgeInsets.only(bottom: 3)).make(),
    ],
  ).box.padding(EdgeInsets.only(top: 5)).make();

}