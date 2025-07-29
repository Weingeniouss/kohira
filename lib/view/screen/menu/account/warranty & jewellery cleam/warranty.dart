import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/html/warranty.dart';

class Warranty extends StatelessWidget {
  const Warranty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: SingleChildScrollView(
          child: Html(data: warranty),
        ),
      ),
    );
  }
}
