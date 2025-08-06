import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/aapbar.dart';

class Buynow extends StatelessWidget {
  const Buynow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname: AppString.butnow,
      ),
      body: Container(
        height: Get.height, width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
      ),
    );
  }
}
