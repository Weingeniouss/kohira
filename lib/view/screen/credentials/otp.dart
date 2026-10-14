// ignore_for_file: avoid_print, deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/credentials/otp_controller.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../utils/app_logo.dart';
import '../../utils/app_string.dart';

class Otp extends StatelessWidget {
  Otp({super.key});

  final OtpUiController controller = Get.put(OtpUiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: SingleChildScrollView(
          child: horizontalpadding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.180),
                logo(),
                SizedBox(height: Get.height * 0.075),
                signIn(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget logo() => Image.asset(AppLogo.logo, scale: 10);

Widget signIn({required OtpUiController controller}) {
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
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          hedingText(),
          textfield(controller: controller),
          buttonWidget(controller: controller),
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
          fontSize: Get.width * 0.059,
          fontFamily: 'Lora',
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: Get.height * 0.009),
      Text(
        AppString.newtoKohira,
        style: TextStyle(
          fontFamily: 'Zapf',
          fontSize: Get.width * 0.040,
        ),
      ),
      SizedBox(height: Get.height * 0.005),
    ],
  );
}

Widget textfield({required OtpUiController controller}) {
  return Obx(() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: inputField(
                controller: controller.firstNameController,
                hintText: AppString.firstname,
                empty: controller.firstnameType.value,
              ),
            ),
            SizedBox(width: Get.width * 0.05),
            Expanded(
              child: inputField(
                controller: controller.lastNameController,
                hintText: AppString.lastname,
                empty: controller.lastnameType.value,
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.005),
        Row(
          children: [
            Image.asset(AppIcon.whatsapp, width: Get.width * 0.07),
            SizedBox(width: Get.width * 0.02),
            Image.asset(AppIcon.india, width: Get.width * 0.07),
            SizedBox(width: Get.width * 0.02),
            Text(AppString.defaultCountryCode),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: inputField(
                maxLength: 10,
                textInputType: TextInputType.number,
                controller: controller.mobileController,
                hintText: AppString.hintmobile,
                empty: controller.mobileType.value,
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.020),
      ],
    );
  });
}

Widget buttonWidget({required OtpUiController controller}) {
  return Obx(() {
    return controller.otpApi.otpDataShow['status'] == true
        ? Column(
            children: [
              OTPTextField(
                controller: controller.otpFieldController,
                length: 6,
                width: Get.width,
                fieldWidth: 45,
                style: TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onChanged: (pin) {
                  controller.otpController.text = pin;
                },
                onCompleted: (pin) {
                  controller.otpController.text = pin;
                },
              ),
              SizedBox(height: Get.height * 0.020),
              GestureDetector(
                onTap: controller.verifyOtpApi.isLoading.value
                    ? null
                    : controller.verifyOtpCode,
                child: button(
                  controller.verifyOtpApi.isLoading.value
                      ? AppString.verifying
                      : AppString.verifyotp,
                  fontSize: Get.width * 0.040,
                  padding: EdgeInsets.all(14),
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              Obx(() => controller.otpApi.minutes.value == 0 &&
                      controller.otpApi.seconds.value == 0
                  ? TextButton(
                      onPressed: () {
                        controller.otpApi.minutes.value = 10;
                        controller.otpApi.seconds.value = 0;
                        controller.otpApi.startTimer();
                      },
                      child: Text(AppString.resendOtp),
                    )
                  : Text(
                      '${AppString.resendOtpIn} ${controller.otpApi.minutes.value}:${controller.otpApi.seconds.value.toString().padLeft(2, '0')}',
                    ))
            ],
          )
        : GestureDetector(
            onTap:
                controller.otpApi.isLoading.value ? null : controller.submitOtp,
            child: button(
              controller.otpApi.isLoading.value
                  ? AppString.pleaseWait
                  : AppString.submit.toUpperCase(),
              fontSize: Get.width * 0.040,
              padding: EdgeInsets.all(14),
            ),
          );
  });
}
