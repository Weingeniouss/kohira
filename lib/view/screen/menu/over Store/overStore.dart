
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';

class Overstore extends StatefulWidget {
  const Overstore({super.key});

  @override
  State<Overstore> createState() => _OverstoreState();
}

class _OverstoreState extends State<Overstore> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Appbar(
        prefixicon: AppIcon.menu,
        prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
        hedingname: AppString.Over,
        suffixicon_1: AppIcon.like,
        suffixicon_2: AppIcon.shop,
      ),
      drawer: Drawers(),
      body: Container(
        height: Get.height, width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
      ),
    );
  }
}
