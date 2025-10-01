// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kohira/view/utils/app_color.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/widget/aapbar.dart';

class CustomJewellery extends StatelessWidget {
  const CustomJewellery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.customJewellery),
      body: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Center(child: Text('This is the Custom Jewellery page.')),
        ),
      ),
    );
  }
}