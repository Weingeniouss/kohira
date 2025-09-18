// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/addresses.dart';
import 'package:kohira/view/screen/menu/account/addresses/addNewAddresses.dart';
import 'package:kohira/view/screen/menu/account/addresses/editaddresses.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_gif.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';

class Addresses extends StatefulWidget {
  const Addresses({super.key});

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  final fech = Get.put(Fechaddresses());
  final delet = Get.put(DeletAddress());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.Addresses),
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
          if (fech.isLoading.value) {
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

              final addresses = fech.data['userAdddress'] ?? [];

              if (addresses == null || (addresses is List && addresses.isEmpty)) {
                return Scaffold(
                  body: Center(child: Lottie.asset(AppJson.noData)),
                );
              }

              return Column(
                children: [
                  SizedBox(height: Get.height / 50),
                  Expanded(
                    child: horizontalpadding(
                      child: ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (BuildContext context, int index) {
                          final fechs = fech.data['userAdddress'][index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColor.white_color,
                              boxShadow: kElevationToShadow[1],
                              borderRadius: BorderRadius.circular(Get.width / 50),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.parson, color: AppColor.grey_color),
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
                                      color: AppColor.white_color,
                                      icon: Icon(Icons.more_vert, color: AppColor.grey_color),
                                      onSelected: (value){
                                        if (value == 'edit') {
                                          Get.to(() => Editaddresses(id: fechs['id'].toString()));
                                        } else if (value == 'delete') {
                                          delet.deletaddress(id: fech.data['userAdddress'][index]['id'].toString()).then((_) {
                                            fech.fechaddresses().then((_) {
                                              if (mounted) {
                                                setState(() {});
                                              }
                                            });
                                          });
                                        }
                                      },
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
                                    Image.asset(AppGif.earth, scale: 1.9),
                                    SizedBox(width: Get.width / 50),
                                    SizedBox(width: Get.width /1.5,child: Text(fechs['address'])),
                                  ],
                                ),
                                SizedBox(height: Get.height / 50),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcon.mobile, color: AppColor.grey_color),
                                    SizedBox(width: Get.width / 50),
                                    Text(fechs['mobileno']),
                                  ],
                                ),
                                SizedBox(height: Get.height / 50),
                                (fechs['isdefault'] == 0) ? GestureDetector(
                                  onTap: () async{
                                     DeletAddress().deletaddress(id: fechs['id'].toString()).then((_){
                                       fech.fechaddresses().then((_){
                                         if(mounted){
                                           setState(() {});
                                         }
                                       });
                                     });
                                    },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.red),borderRadius: BorderRadius.circular(Get.width / 50)),
                                    child: Text('Delet Account',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500)),
                                  ),
                                ) : SizedBox(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
