// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/credentials/Sinup.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_gif.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../../controller/user_inerface/credentials/singup_controller.dart';
import '../../utils/app_String.dart';
import '../../utils/app_icon.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/set_logo.dart';
import '../../utils/widget/title_text.dart';

class Signup extends StatelessWidget {
  SingupController validation = Get.put(SingupController());
  final Sinup = Get.put(SinupCalling());

  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: SafeArea(
            child: horizontalpadding(
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          inputField(hintText: AppString.firstname, icon: AppIcon.parson, controller: validation.frist_controller, empty: validation.firstname_type.value),
                          inputField(hintText: AppString.lastname, icon: AppIcon.parson, controller: validation.last_controller, empty: validation.lastname_type.value),
                          inputField(hintText: AppString.hintemail, icon: AppIcon.mail, controller: validation.email_controller, empty: validation.email_type.value),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                            child: Row(
                              children: [
                                Image.asset(AppGif.earth, scale: 1.5),
                                SizedBox(width: Get.width / 50),
                                Expanded(
                                  child: DropdownButton2<String>(
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: TextEditingController(),
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Search...',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                                      },
                                    ),
                                    underline: SizedBox(),
                                    value: validation.selectedValue.value,
                                    isExpanded: true,
                                    items: validation.Contycode.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                                    onChanged: validation.selectedvalue,
                                    dropdownStyleData: DropdownStyleData(offset: Offset(0, -10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Get.height / 50),
                          inputField(hintText: AppString.hintmobile, icon: AppIcon.mobile, controller: validation.mobile_controller, empty: validation.mobile_type.value),
                          inputField(hintText: AppString.hintpassword, icon: AppIcon.password, controller: validation.password_controller, empty: validation.password_type.value),
                          inputField(hintText: AppString.hintconfirmpassword, icon: AppIcon.password, controller: validation.confiim_password_controller, empty: validation.confirmpassword_type.value),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: validation.value.value,
                                  onChanged: validation.selectedcheak,
                                  overlayColor: WidgetStatePropertyAll(AppColor.pink_color),
                                  side: BorderSide(color: AppColor.pink_color, width: 2),
                                  checkColor: Colors.white,
                                  activeColor: AppColor.pink_color,
                                ),
                              ),
                              Text(AppString.notarobot, style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w500, fontSize: Get.width * 0.04)),
                            ],
                          ),
                          SizedBox(height: Get.height / 50),

                          //
                          Text(AppString.singupHading, style: TextStyle(fontSize: Get.width * 0.033)),
                          SizedBox(height: Get.height / 30),
                          GestureDetector(
                            onTap: () {
                              validation.SignupnTab((){
                                Sinup.registerUser(
                                firstname: validation.frist_controller.text,
                                lastname: validation.last_controller.text,
                                email: validation.email_controller.text,
                                password: validation.password_controller.text,
                                passwordConfirmation: validation.confiim_password_controller.text,
                                mobileno: validation.mobile_controller.text,
                                captcha: 'xylsjjdhbvjaz',
                                countrycode: '91',
                                country_shortname: 'aSKJHVf',
                                login_type: 'mobile',
                              );
                              });
                            },
                            child: button(AppString.signUp),
                          ),
                          SizedBox(height: Get.height / 50),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            height: Get.height * 0.050,
            decoration: BoxDecoration(color: AppColor.white_color),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppString.donthaveanaccount, style: TextStyle(fontSize: Get.width * 0.04)),
                SizedBox(width: Get.width / 100),
                Text(
                  AppString.signin,
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
      ),
    );
  }
}
