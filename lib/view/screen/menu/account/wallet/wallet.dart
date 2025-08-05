// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/wallet.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';

class Wallet extends StatelessWidget {
  final wallet = Get.put(WalletController());
  Wallet({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.wallet),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          if (wallet.isLoading.value) {
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

            if(wallet.data.isEmpty){
              return Center(child: Lottie.asset(AppJson.noData));
            }

            return SafeArea(
              child: horizontalpadding(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height / 50),
                      Text(AppString.points, style: TextStyle(fontSize: Get.width / 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcon.star,width: 22,height: 22),
                          SizedBox(width: Get.width / 50),
                          Text(wallet.data['myWalletAmount'].toString(), style: TextStyle(fontSize: Get.width / 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(AppString.points1, style: TextStyle(fontSize: Get.width / 22, color: AppColor.grey_color)),
                      SizedBox(height: Get.height / 50),
                      Divider(color: AppColor.dividercolor),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppString.recent,style: TextStyle(fontSize: Get.width / 20,fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: Get.height / 50),
                      Container(
                        decoration: BoxDecoration(color: AppColor.white_color, boxShadow: kElevationToShadow[1]),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppString.date,style: TextStyle(fontSize: Get.width / 26,fontWeight: FontWeight.w600)),
                                  Text(AppString.debit,style: TextStyle(fontSize: Get.width / 26,fontWeight: FontWeight.w600)),
                                  Text(AppString.credit,style: TextStyle(fontSize: Get.width / 26,fontWeight: FontWeight.w600)),
                                  Text(AppString.balance,style: TextStyle(fontSize: Get.width / 26,fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Divider(color: AppColor.dividercolor),
                            SizedBox(
                              height: Get.height * 0.55,
                              child:(wallet.data != null)
                                  ? ListView.builder(
                                itemCount: wallet.data['userWalletHistory'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  final history = wallet.data['userWalletHistory'][index];
                                  final orderData = history['OrderData'];

                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(history['refunddate'].toString()),
                                        Text(orderData.isNotEmpty ? orderData[0]['grossamt'].toString() : '-'),
                                        Text(orderData.isNotEmpty ? orderData[0]['netamount'].toString() : '-'),
                                        Text(history['balance'].toString()),
                                      ],
                                    ),
                                  );
                                },
                              )
                                  : Center(child: Lottie.asset(AppJson.noData)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }},
        ),
      ),
    );
  }
}
