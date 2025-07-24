// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart'
    show ProfiledetailsController;
import 'package:kohira/modal/menu/account/accountlist.dart';
import 'package:kohira/view/screen/menu/account/profile%20edit/profileedit.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';

class Account extends StatefulWidget {
  Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final profileDetails = Get.put(ProfiledetailsController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    profileDetails.profiledetailscall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (profileDetails.isLoading.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isDialogOpen != true) {
                Get.dialog(
                  Center(child: Lottie.asset(AppJson.loading2)),
                  barrierDismissible: false,
                );
              }
            });
            return Scaffold(backgroundColor: Colors.transparent);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
            });
            return Column(
              children: [
                Expanded(
                  flex: 1,
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
                                      Text(profileDetails.data['data']['firstname'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 24)),
                                      SizedBox(width: Get.width / 80),
                                      Text(profileDetails.data['data']['lastname'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width / 24)),
                                    ],
                                  ),
                                  Text(profileDetails.data['data']['email'], style: TextStyle(color: AppColor.grey_color)),
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
                Expanded(
                  flex: 5,
                  child: horizontalpadding(
                    child: ListView.builder(
                      itemCount: accountlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            if(index == 0){
                              print('Order History');
                            }

                            if(index == 1){
                              print('Wishlist');
                            }
                          },
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
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          }},
        ),
      ),
    );
  }
}
