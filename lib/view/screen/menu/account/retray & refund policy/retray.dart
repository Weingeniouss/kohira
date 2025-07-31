import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/route_manager.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/html/retray.dart';

class Retray extends StatelessWidget {
  const Retray({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.htmlbackgroud,
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.htmlbackgroud),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Html(data: retray),
          ),
        ),
      ),
    );
  }
}
