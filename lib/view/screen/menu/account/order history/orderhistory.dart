// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/account/orderhistory.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderdetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/app_String.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/app_json.dart';
import '../../../../utils/widget/aapbar.dart';

List extractOrdersList(dynamic rawData) {
  if (rawData == null) return [];
  if (rawData is List) return rawData;
  if (rawData is Map) {
    if (rawData['orders'] is List) return rawData['orders'];
    if (rawData['data'] is Map) {
      final subData = rawData['data'];
      if (subData['orders'] is List) return subData['orders'];
      if (subData is List) return subData;
    }
    if (rawData['data'] is List) return rawData['data'];
  }
  return [];
}

class Orderhistory extends StatelessWidget {
  final order = Get.put(OrderhistoryControll());

  Orderhistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname_2: AppString.orderhistroy,
        suffixicon_1: AppIcon.like,
        suffixicon_2: AppIcon.shop,
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          if (tokans.isEmpty) {
            return _buildUnauthenticatedState();
          }

          if (order.order.isLoading.value) {
            return _buildLoadingState();
          }

          final oderList = extractOrdersList(order.order.data);
          if (oderList.isEmpty) {
            return _buildEmptyState();
          }

          return _buildOrderList(oderList);
        }),
      ),
    );
  }

  Widget _buildUnauthenticatedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: AppColor.pink_color),
          SizedBox(height: 16),
          Text(
            "Please sign in to view your order history",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColor.black_color,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Get.to(() => Login()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.pink_color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: AppColor.white_color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(color: AppColor.pink_color),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Lottie.asset(AppJson.noData),
    );
  }

  Widget _buildOrderList(List oderList) {
    return horizontalpadding(
      child: Column(
        children: [
          SizedBox(height: Get.height / 50),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.orderid),
              Text(AppString.orderDate),
              Text(AppString.orderTotal),
              Text(AppString.orderstatas),
            ],
          ),

          SizedBox(height: Get.height / 60),

          // Order List
          Expanded(
            child: ListView.builder(
              itemCount: oderList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = oderList[index] ?? {};
                return _buildOrderItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['order_no']?.toString() ??
                    item['id']?.toString() ??
                    ''),
                Text(item['order_date']?.toString() ??
                    item['date']?.toString() ??
                    ''),
                Text(item['totalamount']?.toString() ??
                    item['amount']?.toString() ??
                    ''),
                Text(
                  item['status']?.toString() ?? '',
                  style: TextStyle(color: AppColor.glodcolor),
                ),
              ],
            ),
          ),
          onTap: () => Get.to(() => Orderdetails(id: item['id'].toString())),
        ),
        Divider(color: AppColor.dividercolor),
      ],
    );
  }
}
