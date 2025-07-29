
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/html/compliancepolicy.dart';

class Compliance extends StatelessWidget {
  const Compliance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: SingleChildScrollView(
          child: Html(data: compliance),
        ),
      ),
    );
  }
}
