import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';

class Buynow extends StatelessWidget {
  const Buynow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
      ),
    );
  }
}
