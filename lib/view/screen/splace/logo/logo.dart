// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_background.dart';
import 'package:kohira/view/utils/app_gif.dart';
import 'package:kohira/view/utils/app_logo.dart';
import 'package:kohira/view/utils/app_text_image.dart';
import '../../../../controller/user_inerface/splace/logo/logo_controller.dart';
import '../../../utils/widget/horizontalpading.dart';

class Logo extends StatelessWidget {
  LogoController logo = Get.put(LogoController());
  Logo({super.key});

  @override
  Widget build(BuildContext context) {
    logo.onInit();
    return Scaffold(
      body: Container(
        height: Get.height, width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppBackground.background_image),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: horizontalpadding(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: Get.height / 8),
                        Image.asset(AppLogo.logo, scale: 10),
                        SizedBox(height: Get.height / 20),
                        Image.asset(AppTextImage.necklace, scale: 4),
                        SizedBox(height: Get.height / 2),
                      ],
                    ),
                  ],
                ),
                Image.asset(AppGif.mainlodaer, scale: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
