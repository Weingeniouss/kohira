import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kohira/view/utils/app_color.dart';
import '../../../../utils/html/returns.dart';

class Returns extends StatelessWidget {
  const Returns({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.htmlbackgroud,
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.htmlbackgroud),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Html(data: returns),
          ),
        ),
      ),
    );
  }
}
