import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';

import '../../utils/app_String.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/title_text.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: horizontalpadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height / 10),
            SvgPicture.asset(AppIcon.forgetpassword),
            SizedBox(height: Get.height / 30),
            title_text(AppString.forgetPassword),
            SizedBox(height: Get.height / 80),
            sub_titel_text(AppString.subHadingforgat),
            SizedBox(height: Get.height / 20),

            //Inputfild
            inputField(hintText: AppString.hintemail,icon: AppIcon.mail),
            SizedBox(height: Get.height / 5.5),

            //button
            button(AppString.GetEmailLink),
          ],
        ),
      ),
    );
  }
}
