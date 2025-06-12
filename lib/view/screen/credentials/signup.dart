// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';

import '../../utils/app_String.dart';
import '../../utils/app_icon.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/set_logo.dart';
import '../../utils/widget/title_text.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  bool firstname_type = false;
  bool lastname_type = false;
  bool email_type = false;
  bool password_type = false;
  bool mobile_type = false;
  bool confirmpassword_type = false;


  TextEditingController frist_controller = TextEditingController();
  TextEditingController last_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confiim_password_controller = TextEditingController();


  void SignupnTab() {
    if (email_controller.text.isEmpty) {
      setState(() {
        email_type = true;
      });
    }
    else {
      setState(() {
        email_type = false;
      });
    }
    if (password_controller.text.isEmpty) {
      setState(() {
        password_type = true;
      });
    }
    else {
      setState(() {
        password_type = false;
      });
    }
    if (mobile_controller.text.isEmpty) {
      setState(() {
        mobile_type = true;
      });
    }
    else {
      setState(() {
        mobile_type = false;
      });
    }
    if (frist_controller.text.isEmpty) {
      setState(() {
        firstname_type = true;
      });
    }
    else {
      setState(() {
        firstname_type = false;
      });
    }
    if (last_controller.text.isEmpty) {
      setState(() {
        lastname_type = true;
      });
    }
    else {
      setState(() {
        lastname_type = false;
      });
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: Get.width,
      height: Get.height,
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
                inputField(hintText: AppString.firstname,icon: AppIcon.parson,controller: frist_controller,empty: firstname_type),
                inputField(hintText: AppString.lastname,icon: AppIcon.parson,controller: last_controller,empty: lastname_type),
                inputField(hintText: AppString.hintemail,icon: AppIcon.mail,controller: email_controller,empty: email_type),
                inputField(hintText: AppString.hintmobile,icon: AppIcon.mobile,controller: mobile_controller,empty: mobile_type),
                inputField(hintText: AppString.hintpassword,icon: AppIcon.password,controller: password_controller,empty: password_type),
                inputField(hintText: AppString.hintconfirmpassword,icon: AppIcon.password,controller: confiim_password_controller,empty: confirmpassword_type),
                SizedBox(height: Get.height / 50),

                //
                Text(AppString.singupHading,style: TextStyle(fontSize: Get.width * 0.033)),
                SizedBox(height: Get.height / 30),
                GestureDetector(
                  onTap: SignupnTab,
                  child: button(AppString.signUp),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        height: Get.height *0.050,
        decoration: BoxDecoration(
          color: AppColor.white_color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppString.donthaveanaccount,style: TextStyle(fontSize: Get.width * 0.04)),
            SizedBox(width: Get.width / 100),
            Text(AppString.signin,style: TextStyle(fontSize: Get.width * 0.04,fontWeight: FontWeight.w600,color: AppColor.pink_color)),
          ],
        ),
      ),
    ),
  );
}
}
