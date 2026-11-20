// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

String _orderField(dynamic item, List<String> keys, {String fallback = ''}) {
  if (item is! Map) return fallback;
  for (final key in keys) {
    final value = item[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString().trim();
    }
  }
  return fallback;
}

String _shipToAddress(dynamic item) {
  if (item is! Map) return '-';

  final direct = _orderField(item, [
    'ship_to',
    'shipping_address',
    'shippingAddress',
    'address',
    'full_address',
  ]);
  if (direct.isNotEmpty) return direct;

  final users = item['users'] ?? item['user'] ?? item['shipping'];
  if (users is Map) {
    final parts = <String>[
      users['address']?.toString() ?? '',
      users['address2']?.toString() ?? '',
      users['city']?.toString() ?? '',
      users['state']?.toString() ?? '',
      users['zipcode']?.toString() ?? users['zip']?.toString() ?? '',
    ].where((e) => e.trim().isNotEmpty).toList();
    if (parts.isNotEmpty) return parts.join(', ');
  }

  return '-';
}

String _formatOrderTotal(dynamic item) {
  final raw =
      _orderField(item, ['totalamount', 'amount', 'total', 'order_total']);
  if (raw.isEmpty) return '₹ 0';
  final value = double.tryParse(raw.replaceAll(',', '')) ?? 0;
  final formatted = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: value % 1 == 0 ? 0 : 2,
  ).format(value);
  return formatted;
}

class Orderhistory extends StatelessWidget {
  final order = Get.put(OrderhistoryControll());

  Orderhistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname_2: AppString.Order,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.02),
          Text(
            'My Orders',
            style: TextStyle(
              fontSize: Get.width * 0.048,
              fontWeight: FontWeight.w700,
              color: AppColor.black_color,
            ),
          ),
          SizedBox(height: Get.height * 0.018),
          Expanded(
            child: ListView.separated(
              itemCount: oderList.length,
              physics: const ClampingScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(height: Get.height * 0.018),
              itemBuilder: (BuildContext context, int index) {
                final item = oderList[index] ?? {};
                return _buildOrderCard(item);
              },
            ),
          ),
          SizedBox(height: Get.height * 0.015),
        ],
      ),
    );
  }

  Widget _buildOrderCard(dynamic item) {
    final orderId = _orderField(item, ['order_no', 'order_id', 'id']);
    final date = _orderField(item, ['order_date', 'date', 'created_at']);
    final shipTo = _shipToAddress(item);
    final total = _formatOrderTotal(item);
    final status = _orderField(
        item, ['status', 'order_status', 'current_status'],
        fallback: 'Pending');
    final idForDetails = _orderField(item, ['id', 'order_id', 'order_no']);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.borderGrey),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.035,
              vertical: Get.height * 0.014,
            ),
            color: AppColor.Appbercolor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER DETAILS',
                  style: TextStyle(
                    fontSize: Get.width * 0.034,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black_color,
                    letterSpacing: 0.2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (idForDetails.isEmpty) return;
                    Get.to(() => Orderdetails(id: idForDetails));
                  },
                  child: Text(
                    'View',
                    style: TextStyle(
                      fontSize: Get.width * 0.034,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black_color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _detailRow('Order Id', orderId, isFirst: true),
          _detailRow('Date', date),
          _detailRow('Ship To', shipTo),
          _detailRow('Order Total', total),
          _detailRow('Status', status, isStatus: true),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool isStatus = false,
    bool isFirst = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: isFirst
              ? BorderSide.none
              : BorderSide(color: AppColor.lightDivider),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: Get.width * 0.28,
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.03,
                vertical: Get.height * 0.016,
              ),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColor.lightDivider),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Get.width * 0.033,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black_color,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.03,
                  vertical: Get.height * 0.014,
                ),
                alignment: Alignment.centerLeft,
                child: isStatus
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.035,
                            vertical: Get.height * 0.006,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor.pink_color,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: Get.width * 0.032,
                              fontWeight: FontWeight.w500,
                              color: AppColor.pink_color,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontSize: Get.width * 0.033,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black_color,
                          height: 1.35,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
