// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/credentials/forgetpasssword.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';

import '../../utils/app_String.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/title_text.dart';

class Forgetpassword extends StatelessWidget {
  final forgetpassswordCalling = Get.put(ForgetpassswordCalling());
  Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    final email_controller = TextEditingController();
    return Scaffold(
      body: horizontalpadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height / 10), SvgPicture.asset(AppIcon.forgetpassword),
            SizedBox(height: Get.height / 30), title_text(AppString.forgetPassword),
            SizedBox(height: Get.height / 80), sub_titel_text(AppString.subHadingforgat),
            SizedBox(height: Get.height / 20),

            //Inputfild
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    inputField(hintText: AppString.hintemail, icon: AppIcon.mail, controller: email_controller),
                    SizedBox(height: Get.height / 5.5),

                    //button
                    GestureDetector(
                      onTap: () => forgetpassswordCalling.forgetpassworduser(email: email_controller.text),
                      child: button(AppString.GetEmailLink),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
