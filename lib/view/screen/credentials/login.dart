// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/credentials/login.dart';
import 'package:kohira/controller/database/local/localstore.dart';
import 'package:kohira/controller/user_inerface/checkinternet/checkinternet.dart';
import 'package:kohira/controller/user_inerface/credentials/login_controller.dart';
import 'package:kohira/view/screen/credentials/forgetpassword.dart';
import 'package:kohira/view/screen/credentials/signup.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../utils/app_json.dart';
import '../../utils/widget/app_size_text.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/lodingstate.dart';
import '../../utils/widget/pop.dart';
import '../../utils/widget/set_logo.dart';
import '../../utils/widget/title_text.dart';

class Login extends StatelessWidget {
  LoginController validation = Get.put(LoginController());
  LoginCalling login = Get.put(LoginCalling());
  final internetController = Get.put(InternetCheckerController());

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    ever(login.isLoading, (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isLoading) {
          LoadingState.show(AppJson.loading2);
        } else {
          LoadingState.hide();
        }
      });
    });

    return Obx(() {
      if (!internetController.isConnected.value) {
        return NoInternetWidget();
      }

      return Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: SafeArea(
            child: horizontalpadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoginHeaderWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LoginFormFieldsWidget(),
                          SizedBox(height: Get.height / 20),
                          LoginSubmitButton(),
                          SizedBox(height: Get.height / 40),
                          OrDividerWidget(),
                          SizedBox(height: Get.height / 30),
                          SizedBox(height: Get.height / 50),
                          ContinueButtonWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SignUpBottomNavBar(),
      );
    });
  }

  /// Widget to display when there is no internet connection
  Widget NoInternetWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: AppColor.pink_color),
            SizedBox(height: Get.height / 50),
            Text(
              AppString.noInternetConnection,
              style: TextStyle(
                fontSize: Get.width / 20,
                color: AppColor.pink_color,
              ),
            ),
            SizedBox(height: Get.height / 50),
            ElevatedButton(
              onPressed: () => internetController.retryConnection(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.pink_color,
              ),
              child:
                  Text(AppString.retry, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  /// Header section with logo, title, and subtitle
  Widget LoginHeaderWidget() {
    return Column(
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
      ],
    );
  }

  /// Input fields section (Email, Password, Forgot Password)
  Widget LoginFormFieldsWidget() {
    return Obx(() {
      return Column(
        children: [
          inputField(
            hintText: AppString.hintemail,
            icon: AppIcon.mail,
            controller: validation.email_controller,
            empty: validation.email_type.value,
          ),
          inputField(
            hintText: AppString.hintpassword,
            icon: AppIcon.password,
            controller: validation.password_controller,
            empty: validation.password_type.value,
            isVis: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Get.to(() => Forgetpassword()),
                child: forgetpassword(AppString.forgetPassword),
              ),
            ],
          ),
        ],
      );
    });
  }

  /// Sign-in button widget with form validation and submit logic
  Widget LoginSubmitButton() {
    return Obx(() {
      var email = validation.email_controller.value.text;
      var password = validation.password_controller.value.text;
      return GestureDetector(
        onTap: () {
          if (email.isEmpty && password.isEmpty) {
            ToastificationError.Error(AppString.errorFillAll);
            validation.email_type.value = true;
            validation.password_type.value = true;
            return;
          } else if (password.isEmpty) {
            ToastificationError.Error(AppString.errorFillPassword);
            validation.password_type.value = true;
            validation.email_type.value = false;
            return;
          } else if (email.isEmpty) {
            ToastificationError.Error(AppString.errorFillEmail);
            validation.email_type.value = true;
            validation.password_type.value = false;
            return;
          } else {
            validation.SiginTab(
              login.loginUser(
                email,
                password,
              ),
            );
            localdatabase().loginstrore(
              email: email,
              password: password,
            );
          }
        },
        child: button(
          validation.login.isLoading.value
              ? AppString.loading
              : AppString.signin,
        ),
      );
    });
  }

  /// 'Or' divider line widget
  Widget OrDividerWidget() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColor.textfild_color)),
        SizedBox(width: Get.width / 20),
        Text(
          AppString.or,
          style: TextStyle(
            color: AppColor.othersub_color,
            fontSize: Get.width * 0.04,
          ),
        ),
        SizedBox(width: Get.width / 20),
        Expanded(child: Divider(color: AppColor.textfild_color)),
      ],
    );
  }

  /// 'Continue' button widget
  Widget ContinueButtonWidget() {
    return GestureDetector(
      onTap: () => Get.off(() => Bottom()),
      child: Text(
        AppString.continues,
        style: TextStyle(
          color: AppColor.pink_color,
          fontSize: Get.width * 0.040,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Bottom navigation bar widget containing Sign Up option
  Widget SignUpBottomNavBar() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => Signup(),
            duration: Duration(milliseconds: 800),
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
              Text(
                AppString.donthaveanaccount,
                style: TextStyle(fontSize: Get.width * 0.04),
              ),
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
    );
  }
}
