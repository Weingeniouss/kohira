// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_import, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kohira/controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_string.dart';
import '../../../../controller/user_inerface/checkinternet/checkinternet.dart';

class Bottom extends StatelessWidget {
  final  internetController = Get.put(InternetCheckerController());
  final  bottamSelect = Get.put(Bottamnavigation());
  Bottom({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx((){
      if(!internetController.isConnected.value){
        return  Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 80, color: AppColor.pink_color),
                SizedBox(height: Get.height / 50),
                Text("No Internet Connection", style: TextStyle(fontSize: Get.width / 20,color: AppColor.pink_color)),
                SizedBox(height: Get.height / 50),
                ElevatedButton(
                  onPressed: () => internetController.retryConnection(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.pink_color),
                  child: Text("Retry", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      }
     return  Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: Get.height * 0.075,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColor.textfild_color)),
            color: AppColor.white_color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              //defult home Sccrren
              InkWell(
                onTap: bottamSelect.indexOne,
                child: bottamIcon(
                  context: context,
                  icon: AppIcon.home,
                  name: AppString.home,
                  onTap: bottamSelect.indexOne,
                  condition: bottamSelect.selectindex.value == 0,
                ),
              ),

              //Category Screen
              GestureDetector(
                onTap: bottamSelect.indexTwo,
                child: bottamIcon(
                  context: context,
                  icon: AppIcon.category,
                  name: AppString.category,
                  onTap: bottamSelect.indexTwo,
                  condition: bottamSelect.selectindex.value == 1,
                ),
              ),

              //Mycart Screen
              InkWell(
                onTap: bottamSelect.indexThree,
                child: bottamIcon(
                  context: context,
                  icon: AppIcon.cart,
                  name: AppString.cart,
                  onTap: bottamSelect.indexThree,
                  condition: bottamSelect.selectindex.value == 2,
                ),
              ),

              //Over Store
              InkWell(
                onTap: bottamSelect.indexFour,
                child: bottamIcon(
                  context: context,
                  icon: AppIcon.house,
                  name: AppString.Over,
                  onTap: bottamSelect.indexFour,
                  condition: bottamSelect.selectindex.value == 3,
                ),
              ),

              //Account
              InkWell(
                onTap: bottamSelect.indexFive,
                child: bottamIcon(
                  context: context,
                  icon: AppIcon.account,
                  name: AppString.account,
                  onTap: bottamSelect.indexFive,
                  condition: bottamSelect.selectindex.value == 4,
                ),
              ),
            ],
          ),
          ),
        ),body: bottamSelect.selectscreen(bottamSelect.selectindex.value),
      );
    });
  }
}

Widget bottamIcon({
  void Function()? onTap,
  required String icon,
  required String name,
  bool condition = false,
  context
}) {
  return SizedBox(
    width: Get.width / 5.5,
    child: GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, color: condition ? AppColor.pink_color : AppColor.bottomColor,
            width: MediaQuery.of(context).size.width * 0.058,
            height: MediaQuery.of(context).size.width * 0.058,
          ),
          SizedBox(height: Get.height / 200),
          Text(
            textAlign: TextAlign.center,
            name,style: TextStyle(
            color: condition ? AppColor.pink_color : AppColor.bottomColor,
            fontWeight: condition ? FontWeight.w600 : FontWeight.w500,
            fontSize: MediaQuery.of(context).size.width * 0.03,
           ),
          ),
        ],
      ),
    ),
  );
}
