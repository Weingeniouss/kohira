// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import '../../utils/app_logo.dart';
import '../../utils/app_string.dart';

class Otp extends StatelessWidget {
  const Otp({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final mobileController = TextEditingController();
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: horizontalpadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo(),
              SizedBox(height: Get.height * 0.065),
              signIn(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                mobileController: mobileController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget logo() {
  return Image.asset(AppLogo.logo, scale: 10);
}

Widget signIn({
  required TextEditingController firstNameController,
  required TextEditingController lastNameController,
  required TextEditingController mobileController,
}) {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      color: AppColor.white_color,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          hedingText(),
          textfield(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            mobileController: mobileController,
          ),
          buttonWidget(),
        ],
      ),
    ),
  );
}

Widget hedingText() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppString.signin,
        style: TextStyle(
          fontSize: Get.width * 0.055,
          fontFamily: 'Lora',
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: Get.height * 0.005),
      Text(
        AppString.newtoKohira,
        style: TextStyle(
          fontFamily: 'Zapf',
          fontSize: Get.width * 0.035,
        ),
      ),
    ],
  );
}

Widget textfield({
  required TextEditingController firstNameController,
  required TextEditingController lastNameController,
  required TextEditingController mobileController,
}) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: inputField(
              controller: firstNameController,
              hintText: AppString.firstname,
            ),
          ),
          SizedBox(width: Get.width * 0.05),
          Expanded(
            child: inputField(
              controller: lastNameController,
              hintText: AppString.lastname,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Image.asset(AppIcon.whatsapp, width: Get.width * 0.07),
          SizedBox(width: Get.width * 0.02),
          Image.asset(AppIcon.india, width: Get.width * 0.07),
          SizedBox(width: Get.width * 0.02),
          Text('+91'),
          SizedBox(width: Get.width * 0.03),
          Expanded(
            child: inputField(
              maxLength: 10,
              textInputType: TextInputType.number,
              controller: mobileController,
              hintText: AppString.hintmobile,
            ),
          ),
        ],
      ),
      SizedBox(height: Get.height * 0.015),
    ],
  );
}

Widget buttonWidget() {
  return button(
    AppString.submit.toUpperCase(),
    fontSize: Get.width * 0.033,
    padding: EdgeInsets.all(10),
  );
}
