// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_import, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kohira/view/screen/menu/category/Category.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_string.dart';
import '../../../../controller/user_inerface/checkinternet/checkinternet.dart';
import '../../../screen/menu/home/home.dart' show Home;
import '../horizontalpading.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  final internetController = Get.put(InternetCheckerController());
  int selectindex = 0;

  List<Widget> scrren = [
    Home(),
    Category(),
  ];

  Widget selectscreen(int index) {
    return scrren[index];
  }

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bottamIcon(
                  icon: AppIcon.home,
                  name: AppString.home,
                  onTap: () => setState(() => selectindex=0),
                  condition: selectindex == 0,
                ),
                bottamIcon(
                  icon: AppIcon.category,
                  name: AppString.category,
                  onTap: () => setState(() => selectindex=1),
                  condition: selectindex == 1,
                ),
                bottamIcon(icon: AppIcon.cart, name: AppString.cart),
                bottamIcon(icon: AppIcon.find, name: AppString.find),
                bottamIcon(icon: AppIcon.account, name: AppString.account),
              ],
            ),
          ),
        ),
      ),
      body: selectscreen(selectindex),
    );
    });
  }
}

Widget bottamIcon({
  void Function()? onTap,
  required String icon,
  required String name,
  bool condition = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(icon, color: condition ? AppColor.pink_color : null),
        SizedBox(height: Get.height / 200),
        Text(name,style: TextStyle(color: condition ? AppColor.pink_color : AppColor.bottomColor)),
      ],
    ),
  );
}
