
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:izmir/consts/consts.dart';
import 'package:izmir/shapes/snack_bar.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/drawer_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../controllers/loading_dialogue_controller.dart';
import '../pages/view_full_image.dart';

final drawer_controller drawerController = Get.find();
final loading_dialogue_controller loadingController = Get.find();

class profile_picture_sheet_controller extends GetxController{
  DocumentReference docimgreference=FirebaseFirestore.instance
      .collection(drawerController.pref_info["account_type"])
      .doc(drawerController.pref_userId.value);
  var profile_img_docreference=FirebaseStorage.instance;

  late BuildContext new_context;
  profile_picture_sheet_controller({required this.new_context});

  Future profile_picture_edit_sheet(context) => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
          duration: const Duration(milliseconds: 150),
          cornerRadius: 15,
          scrollSpec: ScrollSpec(physics: NeverScrollableScrollPhysics()),
          builder: buildSheet));

  Widget buildSheet(context, state) => Material(
    child: Column(
      children: [
        Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              drawerController.pref_info["profile_picture"].toString().length==0
                  ? show_snackbar(context, no_prfl_img_txt, whiteColor, Colors.red)
                  : Get.to(() => view_full_image(),arguments: drawerController.pref_info["profile_picture"]);
            },
            child: Ink(
              height: 50,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: lightGreyColor),
              child: Row(
                children: [
                  Icon(CupertinoIcons.view_2d),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "View full Image",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: BlackColor),
                  )
                ],
              ),
            ),
          ),
        ),
        Material(
          child: InkWell(
            onTap: () {
              pick_image(context);
              Navigator.of(context).pop();
            },
            child: Ink(
              height: 50,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: lightGreyColor),
              child: Row(
                children: [
                  Icon(CupertinoIcons.up_arrow),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Upload new Image",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: BlackColor),
                  )
                ],
              ),
            ),
          ),
        ),
        Material(
          child: InkWell(
            onTap: () {
              delete_image(context);
              Navigator.of(context).pop();
            },
            child: Ink(
              height: 50,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: lightGreyColor),
              child: Row(
                children: [
                  Icon(CupertinoIcons.delete),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Delete Image",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: BlackColor),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  pick_image(context) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? img = await imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List response;
    try {
      response =
      (await FlutterImageCompress.compressWithFile(img!.path, quality: 25))!;
    } on UnsupportedError catch (e) {
      print(e);
      response = (await FlutterImageCompress.compressWithFile(
        img!.path,
        quality: 25,
        format: CompressFormat.jpeg,
      ))!;
    }
    if (response != null) {
      if(drawerController.pref_info["profile_picture"].toString().length>1){
        profile_img_docreference.refFromURL(drawerController.pref_info["profile_picture"].toString().trim()).delete();
      }
      Reference reference = profile_img_docreference
          .ref()
          .child("profile_picture")
          .child(drawerController.pref_userId.value)
          .child(new DateTime.now().microsecondsSinceEpoch.toString());
      try {
        await reference.putData(response);
        String img_url = await reference.getDownloadURL();
        docimgreference.update({'profile_picture': img_url}).then((value) {
          drawerController.pref_info["profile_picture"] = img_url;
          drawerController.saveProfileInfo(drawerController.pref_info.value);
        }).then((value) {
          show_snackbar(new_context, sccs_profile_pic_upld, yellowColor, darkBlueColor);
        }
        )
            .onError((e, stackTrace){
          show_snackbar(new_context, e.toString(), whiteColor, Colors.red);
        }
        );
      } catch (e) {
        show_snackbar(new_context, e.toString(), whiteColor, Colors.red);
      }
    }
  }

  delete_image(context) async {
    await profile_img_docreference.refFromURL(drawerController.pref_info["profile_picture"].toString().trim()).delete();
    await docimgreference.update({'profile_picture': ""}).then((value) {
      drawerController.pref_info["profile_picture"] = "";
      drawerController.saveProfileInfo(drawerController.pref_info.value);

    }).then((value) => show_snackbar(new_context,sccs_profile_pic_dlt, yellowColor, darkBlueColor))
        .onError((e, stackTrace) => show_snackbar(new_context, e.toString(), whiteColor, Colors.red));
  }

}

