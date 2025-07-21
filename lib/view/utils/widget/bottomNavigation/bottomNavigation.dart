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
import '../horizontalpading.dart';

class Bottom extends StatelessWidget {
  Bottom({super.key});

  final internetController = Get.put(InternetCheckerController());
  final bottamSelect =  Get.put(Bottamnavigation());

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if(!internetController.isConnected.value){
        return  Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text("No Internet Connection", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => internetController.retryConnection(),
                  child: Text("Retry"),
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
          child: horizontalpadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                //defult home Sccrren
                bottamIcon(
                  icon: AppIcon.home,
                  name: AppString.home,
                  onTap: bottamSelect.indexOne,
                  condition: bottamSelect.selectindex.value == 0,
                ),

                //Category Screen
                bottamIcon(
                  icon: AppIcon.category,
                  name: AppString.category,
                  onTap: bottamSelect.indexTwo,
                  condition: bottamSelect.selectindex.value == 1,
                ),

                //Mycart Screen
                bottamIcon(
                  icon: AppIcon.cart,
                  name: AppString.cart,
                  onTap: bottamSelect.indexThree,
                  condition: bottamSelect.selectindex.value == 2,
                ),
                bottamIcon(icon: AppIcon.find, name: AppString.find),
                bottamIcon(icon: AppIcon.account, name: AppString.account),
              ],
             ),
            ),
          ),
        ),body: bottamSelect.selectscreen(bottamSelect.selectindex.value),
      );
    });
  }
}

Widget bottamIcon({void Function()? onTap, required String icon, required String name, bool condition = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(icon, color: condition ? AppColor.pink_color : null),
        SizedBox(height: Get.height / 200),
        Text(
          name,style: TextStyle(
          color: condition ? AppColor.pink_color : AppColor.bottomColor,
          fontWeight: condition ? FontWeight.w500 : FontWeight.w400,
          fontSize: Get.width / 30,
         ),
        ),
      ],
    ),
  );
}
