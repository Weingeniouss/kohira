// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import 'package:kohira/controller/user_inerface/menu/account/address/address.dart';
import 'package:kohira/view/screen/menu/account/addresses/addNewAddresses.dart';
import 'package:kohira/view/screen/menu/account/addresses/editaddresses.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/widget/containershadow.dart';

class Addresses extends StatelessWidget {
  final address = Get.put(AddressUserInterface());
  Addresses({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back();
        address.fech.fechaddresses();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: Appbar(
          lefticon: AppIcon.left,
          hedingname_2: AppString.Addresses,
          onTaplefticon: (){
            address.fech.fechaddresses();
            Get.back();
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: AppColor.white_color,
            height: Get.height * 0.080,
            child: horizontalpadding(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => AddNewAddresses()),
                        child: button("Add New ${AppString.Addresses}"),
                      ),
                      SizedBox(height: Get.height / 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            // if (fech.isLoading.value) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //       if (Get.isDialogOpen != true) {
            //         Get.dialog(
            //           Center(child: Lottie.asset(AppJson.loading2)),
            //           barrierDismissible: false,
            //         );
            //       }
            //     });
            //     return Scaffold(backgroundColor: Colors.transparent);
            //   } else {
            //     WidgetsBinding.instance.addPostFrameCallback((_) {
            //       if (Get.isDialogOpen == true) {
            //         Get.back();
            //       }
            //     });

            final addresses = address.fech.data['userAdddress'] ?? [];

            if (addresses == null || (addresses is List && addresses.isEmpty)) {
              return Scaffold(
                body: Center(child: Lottie.asset(AppJson.noData)),
              );
            }

            // if (address.fech.isLoading.value) {
            //   return Shimmer.fromColors(
            //     baseColor: AppColor.lodingcolor,
            //     highlightColor: AppColor.highlightColor,
            //     child: horizontalpadding(
            //       child: ListView.builder(
            //         itemCount: addresses.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           return Column(
            //             children: [
            //               SizedBox(height: Get.height / 50),
            //               Container(
            //                 height: Get.height / 7, width: Get.width,
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(Get.width / 50),
            //                   border: Border.all(color: AppColor.grey_color,
            //                   ),
            //                 ),
            //                 child: Padding(
            //                   padding: EdgeInsets.all(8.0),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Container(
            //                             height: Get.width / 15, width: Get.width / 15,
            //                             decoration: BoxDecoration(color: AppColor.grey_color, shape: BoxShape.circle),
            //                           ),
            //                           SizedBox(width: Get.width / 30),
            //                           Expanded(
            //                             child: Container(
            //                               height: Get.height / 80, width: Get.width,
            //                               decoration: BoxDecoration(color: AppColor.grey_color,borderRadius: BorderRadiusDirectional.circular(Get.width / 50)),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(height: Get.height / 100),
            //                       Row(
            //                         children: [
            //                           Container(
            //                             height: Get.width / 15, width: Get.width / 15,
            //                             decoration: BoxDecoration(color: AppColor.grey_color, shape: BoxShape.circle),
            //                           ),
            //                           SizedBox(width: Get.width / 30),
            //                           Expanded(
            //                             child: Container(
            //                               height: Get.height / 80, width: Get.width,
            //                               decoration: BoxDecoration(color: AppColor.grey_color,borderRadius: BorderRadiusDirectional.circular(Get.width / 50)),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(height: Get.height / 100),
            //                       Row(
            //                         children: [
            //                           Container(
            //                             height: Get.width / 15, width: Get.width / 15,
            //                             decoration: BoxDecoration(color: AppColor.grey_color, shape: BoxShape.circle),
            //                           ),
            //                           SizedBox(width: Get.width / 30),
            //                           Expanded(
            //                             child: Container(
            //                               height: Get.height / 80, width: Get.width,
            //                               decoration: BoxDecoration(color: AppColor.grey_color,borderRadius: BorderRadiusDirectional.circular(Get.width / 50)),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     ),
            //   );
            // }
              return Column(
                children: [
                  SizedBox(height: Get.height / 50),
                  Expanded(
                    child: horizontalpadding(
                      child: ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (BuildContext context, int index) {
                          final fechs = address.fech.data['userAdddress'][index];
                          return Column(
                            children: [
                              GestureDetector(
                                child: containershadow(
                                  color: (address.fech.data['userAdddress'][index]['isdefault'] == 1) ? AppColor.pink_color : AppColor.textfild_color,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person_outlined, color: AppColor.pink_color),
                                              SizedBox(width: Get.width / 50),
                                              Row(
                                                children: [
                                                  Text(fechs['firstname']),
                                                  SizedBox(width: Get.width / 100),
                                                  Text(fechs['lastname']),
                                                ],
                                              ),
                                            ],
                                          ),
                                          PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            offset: Offset(0, 40),
                                            iconSize: 18,
                                            color: AppColor.white_color,
                                            child: Padding(
                                              padding: EdgeInsets.all(2),
                                              child: Icon(Icons.more_vert, color: AppColor.grey_color, size: 18),
                                            ),
                                            onSelected: (value) => address.isPopSelected(value,fechs,index),
                                            itemBuilder: (BuildContext context) => [
                                              PopupMenuItem(value: 'edit', child: Text('Change Billing State')),
                                              if(fechs['isdefault'] == 0) PopupMenuItem(value: 'delete', child: Text('Delete')),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Get.height / 80),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined, color: AppColor.pink_color,size: 20),
                                          SizedBox(width: Get.width / 50),
                                          SizedBox(width: Get.width /1.5,child: Text(fechs['address'])),
                                        ],
                                      ),
                                      SizedBox(height: Get.height / 80),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.phone_android_outlined, color: AppColor.pink_color,size: 20),
                                              SizedBox(width: Get.width / 50),
                                              Text(fechs['mobileno']),
                                            ],
                                          ),
                                          (fechs['isdefault'] == 0) ? GestureDetector(
                                            onTap: () => address.deleteAddress(fechs),
                                            child: Icon(Icons.delete_outline_outlined, color: AppColor.pink_color,size: 20),
                                          ) : SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => address.deflutvalue(index),
                              ),
                              SizedBox(height: Get.height / 80),
                            ]);
                          },
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
