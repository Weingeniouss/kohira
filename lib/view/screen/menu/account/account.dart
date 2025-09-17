// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/account.dart';
import 'package:kohira/modal/menu/account/accountlist.dart';
import 'package:kohira/view/screen/menu/account/profile%20edit/profileedit.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';

class Account extends StatelessWidget {
  final account = Get.put(AccountController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Account({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final Bottamnavigation bottomSelectController = Get.find<Bottamnavigation>();
        Bottom();
        bottomSelectController.indexOne();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          prefixicon: AppIcon.menu,
          prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          hedingname: AppString.accounttitale,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (account.profileDetails.isLoading.value) {
              return Shimmer.fromColors(
                baseColor: AppColor.lodingcolor,
                highlightColor: AppColor.highlightColor,
                child: horizontalpadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height / 50),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: Get.width / 3,
                                decoration: BoxDecoration(
                                  color: AppColor.white_color,
                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                ),
                              ),
                              SizedBox(height: Get.height / 80),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: Get.width / 1.4,
                                decoration: BoxDecoration(
                                  color: AppColor.white_color,
                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                ),
                              ),
                              SizedBox(height: Get.height / 80),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(vertical: Get.height * 0.010),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.white_color, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                              SizedBox(height: Get.height / 150),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: AppColor.dividercolor),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: Get.height * 0.010),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.white_color, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                                SizedBox(width: Get.width / 50),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Get.width /5, vertical: Get.height /70),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColor.white_color,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if(account.profileDetails.data['data'] == null) Center(child: Lottie.asset(AppJson.noData));
            final item = account.profileDetails.data['data'];
              return Column(
                children: [
                  (account.profileDetails.data['data'] == null)  ? SizedBox() : Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => Profileedit()),
                            child: horizontalpadding(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Get.height / 40),
                                      Row(
                                        children: [
                                           Text(item['firstname'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 24)),
                                           SizedBox(width: Get.width / 80),
                                           Text(item['lastname'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 24)),
                                         ],
                                        ),
                                      Text(item['email'], style: TextStyle(color: AppColor.grey_color)),
                                      SizedBox(height: Get.height / 50),
                                    ],
                                   ),
                                  SvgPicture.asset(AppIcon.editing, width: 30, height: 30, color: AppColor.pink_color),
                                ],
                              ),
                            ),
                          ),
                          Divider(color: AppColor.dividercolor),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: horizontalpadding(
                      child: ListView.builder(
                        itemCount: accountlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => account.listButton(index,context),
                            child: Container(
                              color: AppColor.white_color,
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
                                    decoration: BoxDecoration(
                                      color: AppColor.pink_color,
                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: SvgPicture.asset(
                                      accountlist[index]['image'],
                                      width: Get.width * 0.025,
                                      height: Get.height * 0.025,
                                      color: AppColor.white_color,
                                    ),
                                  ),
                                  SizedBox(width: Get.width / 30),
                                  Text(accountlist[index]['name'],style: TextStyle(fontSize: Get.width / 25)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
