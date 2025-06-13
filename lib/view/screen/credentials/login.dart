// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/credentials/login_controller.dart';
import 'package:kohira/view/screen/credentials/forgetpassword.dart';
import 'package:kohira/view/screen/credentials/signup.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../utils/widget/app_size_text.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/company_button.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/set_logo.dart';
import '../../utils/widget/title_text.dart';

class Login extends StatelessWidget {
  LoginController validation = Get.put(LoginController());
  Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: Container(
        height: Get.height, width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: SafeArea(
          child: horizontalpadding(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      setLogo(),
                    ],
                  ),
                  title_text(AppString.signin),
                  SizedBox(height: Get.height / 80),
                  sub_titel_text(AppString.subsignin),
                  SizedBox(height: Get.height / 20),

                  //Inputfild
                  inputField(hintText: AppString.hintemail, icon: AppIcon.mail, controller: validation.email_controller, empty: validation.email_type.value),
                  inputField(hintText: AppString.hintpassword, icon: AppIcon.password, controller: validation.password_controller, empty: validation.password_type.value),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => Forgetpassword()),
                        child: forgetpassword(AppString.forgetPassword),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height / 20),

                  //button
                  GestureDetector(onTap: validation.SiginTab, child: button(AppString.signin)),
                  SizedBox(height: Get.height / 40),

                  //Or
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColor.textfild_color)),
                      SizedBox(width: Get.width / 20),
                      Text('Or', style: TextStyle(color: AppColor.othersub_color, fontSize: Get.width * 0.04)),
                      SizedBox(width: Get.width / 20),
                      Expanded(child: Divider(color: AppColor.textfild_color)),
                    ],
                  ),
                  SizedBox(height: Get.height / 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      company_button(AppString.google, AppIcon.google),
                      company_button(AppString.facebook, AppIcon.facebook),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Get.to(() => Signup(),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transition: Transition.rightToLeft,
          );
        },
        child: Container(
          height: Get.height * 0.050,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppString.donthaveanaccount, style: TextStyle(fontSize: Get.width * 0.04)),
              SizedBox(width: Get.width / 100),
              Text(
                AppString.signUp,
                style: TextStyle(
                  fontSize: Get.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: AppColor.pink_color,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
