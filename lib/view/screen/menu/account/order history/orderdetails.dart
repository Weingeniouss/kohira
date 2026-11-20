// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/account/myOrderDetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/app_json.dart';
import '../../../../utils/widget/aapbar.dart';

class Orderdetails extends StatefulWidget {
  final String id;

  const Orderdetails({super.key, required this.id});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  final orderdetails = Get.put(Myorderdetails());
  final _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 0,
  );
  final _linkColor = const Color(0xFF4A90E2);
  final _summaryHeader = const Color(0xFF5A5A5A);
  final _summaryFooter = const Color(0xFF4A4A4A);

  @override
  void initState() {
    super.initState();
    orderdetails.myorderdatails(widget.id);
  }

  Map get _order {
    final data = orderdetails.data;
    if (data['orders'] is Map) return data['orders'] as Map;
    return {};
  }

  Map get _users {
    final users = _order['users'];
    if (users is Map) return users;
    return {};
  }

  List get _items {
    final list = _order['order_detail'];
    if (list is List) return list;
    return [];
  }

  String _str(dynamic value, {String fallback = '-'}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    return text;
  }

  double _num(dynamic value) =>
      double.tryParse(value?.toString().replaceAll(',', '') ?? '') ?? 0;

  String _money(dynamic value) => _currency.format(_num(value));

  String _shippingMethod() {
    final method = _str(_order['shipping_method'], fallback: '');
    if (method.isNotEmpty && method != '-') return method;
    final charge = _num(_order['shippingcharge']);
    return charge <= 0 ? 'Free Shipping' : _money(charge);
  }

  String _shippingAddressText() {
    final users = _users;
    final parts = <String>[
      _str(users['address'], fallback: ''),
      _str(users['address2'], fallback: ''),
      _str(users['city'], fallback: ''),
      _str(users['state'], fallback: ''),
      _str(users['pincode'] ?? users['zipcode'], fallback: ''),
    ].where((e) => e.isNotEmpty && e != '-').toList();

    try {
      final addresses = _order['order_addresses_data'];
      if (addresses is List && addresses.isNotEmpty) {
        final country =
            addresses[0]?['order_country_data']?['name']?.toString() ?? '';
        if (country.trim().isNotEmpty) parts.add(country.trim());
      }
    } catch (_) {}

    if (parts.isEmpty) return '-';
    return parts.join(', ');
  }

  String _phone() => _str(
        _users['mobile'] ??
            _users['phone'] ??
            _users['phonenumber'] ??
            _users['contact'],
        fallback: '',
      );

  String _email() => _str(_users['email'] ?? _users['email_id'], fallback: '');

  Future<void> _launchTel(String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchMail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname_2: 'Order Details History',
        suffixicon_1: AppIcon.like,
        suffixicon_2: AppIcon.shop,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: AppColor.white_color,
        child: Obx(() {
          if (orderdetails.isLoading.value) {
            return Center(
              child: Lottie.asset(AppJson.loading2, width: 120, height: 120),
            );
          }

          if (_order.isEmpty) {
            return Center(child: Lottie.asset(AppJson.noData));
          }

          final subTotal = _num(_order['totalamount']);
          final discount = _num(_order['discountamt']);
          final tax = _num(_order['globaltaxcharge']);
          final shipping = _num(_order['shippingcharge']);
          final wallet = _num(_order['walletAmount']);
          final payable = subTotal - discount + tax + shipping - wallet;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: horizontalpadding(
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
                  _orderDetailsCard(),
                  SizedBox(height: Get.height * 0.018),
                  _shippingAddressCard(),
                  SizedBox(height: Get.height * 0.018),
                  ..._items.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: Get.height * 0.018),
                      child: _productCard(entry.value, entry.key),
                    );
                  }),
                  _orderSummaryCard(
                    subTotal: subTotal,
                    discount: discount,
                    tax: tax,
                    shipping: shipping,
                    payable: payable,
                  ),
                  SizedBox(height: Get.height * 0.03),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.borderGrey),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.035,
              vertical: Get.height * 0.014,
            ),
            color: AppColor.Appbercolor,
            child: Text(
              title,
              style: TextStyle(
                fontSize: Get.width * 0.034,
                fontWeight: FontWeight.w700,
                color: AppColor.black_color,
                letterSpacing: 0.2,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _orderDetailsCard() {
    final orderId = _str(_order['order_no'] ?? _order['id']);
    final date = _str(_order['order_date']);
    final payment = _str(_order['paymenttype'] ?? _order['payment_method']);
    final txn = _str(
      _order['payment_transaction_id'] ?? _order['transaction_id'],
      fallback: '-',
    );

    return _sectionCard(
      title: 'ORDER DETAILS',
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Get.width * 0.035,
                  Get.height * 0.015,
                  Get.width * 0.02,
                  Get.height * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labeledValue('Order Id:', orderId),
                    SizedBox(height: Get.height * 0.01),
                    _labeledValue('Date Added:', date),
                    SizedBox(height: Get.height * 0.01),
                    _labeledValue('Shipping Method:', _shippingMethod()),
                  ],
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColor.lightDivider,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Get.width * 0.03,
                  Get.height * 0.015,
                  Get.width * 0.035,
                  Get.height * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labeledValue('Payment Method:', payment),
                    SizedBox(height: Get.height * 0.01),
                    _labeledValue('Transaction Id:', txn),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledValue(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontSize: Get.width * 0.032,
              fontWeight: FontWeight.w600,
              color: AppColor.black_color,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: Get.width * 0.032,
              fontWeight: FontWeight.w400,
              color: AppColor.grey_color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shippingAddressCard() {
    final phone = _phone();
    final email = _email();

    return _sectionCard(
      title: 'SHIPPING ADDRESS',
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.035,
          vertical: Get.height * 0.016,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _shippingAddressText(),
              style: TextStyle(
                fontSize: Get.width * 0.033,
                fontWeight: FontWeight.w400,
                color: AppColor.black_color,
                height: 1.4,
              ),
            ),
            if (phone.isNotEmpty) ...[
              SizedBox(height: Get.height * 0.012),
              GestureDetector(
                onTap: () => _launchTel(phone),
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: _linkColor),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        phone.startsWith('+') ? phone : '+91 $phone',
                        style: TextStyle(
                          fontSize: Get.width * 0.033,
                          color: _linkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (email.isNotEmpty) ...[
              SizedBox(height: Get.height * 0.01),
              GestureDetector(
                onTap: () => _launchMail(email),
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: _linkColor),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: Get.width * 0.033,
                          color: _linkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _productCard(dynamic item, int index) {
    final jewelry = (item is Map ? item['jewelery'] : null) is Map
        ? item['jewelery'] as Map
        : <dynamic, dynamic>{};

    final image = _str(
      jewelry['default'] is Map ? jewelry['default']['path'] : null,
      fallback: '',
    );
    final title = _str(jewelry['title'], fallback: 'Product');
    final metalStamp =
        _str(jewelry['metal_stamp'] is Map ? jewelry['metal_stamp']['paraname'] : null,
            fallback: '');
    final metalType =
        _str(jewelry['metal_type'] is Map ? jewelry['metal_type']['paraname'] : null,
            fallback: '');
    final metal = [metalStamp, metalType]
        .where((e) => e.isNotEmpty && e != '-')
        .join(' ');
    final clarity = _str(jewelry['clarity'], fallback: '-');
    final sku = _str(jewelry['sku'] ?? jewelry['skucode'] ?? jewelry['code'],
        fallback: '-');
    final status = _str(
      jewelry['order_current_status'] is Map
          ? jewelry['order_current_status']['customerstatuscaption']
          : item['status'],
      fallback: 'Order Placed',
    );
    final qty = _str(item is Map ? item['qty'] : 1, fallback: '1');
    final price = _num(
      item is Map
          ? (item['price'] ?? jewelry['setting_price'] ?? item['amount'])
          : jewelry['setting_price'],
    );
    final original = _num(
      jewelry['mrp'] ??
          jewelry['original_price'] ??
          jewelry['compare_price'] ??
          item['mrp'],
    );
    final amount = _num(
      item is Map
          ? (item['amount'] ?? item['total'] ?? (price * (_num(qty))))
          : price,
    );
    final date = _str(_order['order_date']);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white_color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.borderGrey),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: Get.width * 0.28,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.012),
                  color: AppColor.Appbercolor,
                  child: Text(
                    'IMAGE',
                    style: TextStyle(
                      fontSize: Get.width * 0.032,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColor.lightDivider,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03,
                      vertical: Get.height * 0.012,
                    ),
                    color: AppColor.Appbercolor,
                    child: Text(
                      'PRODUCT DETAILS',
                      style: TextStyle(
                        fontSize: Get.width * 0.032,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: Get.width * 0.28,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColor.lightDivider),
                    ),
                  ),
                  child: image.isEmpty
                      ? Icon(AppIcon.brokenImage, color: AppColor.grey_color)
                      : Image.network(
                          image,
                          fit: BoxFit.contain,
                          cacheWidth: 280,
                          errorBuilder: (_, __, ___) => Icon(
                            AppIcon.brokenImage,
                            color: AppColor.grey_color,
                          ),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03,
                      vertical: Get.height * 0.014,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: Get.width * 0.034,
                            fontWeight: FontWeight.w700,
                            color: AppColor.black_color,
                          ),
                        ),
                        SizedBox(height: 8),
                        _productMeta('Metal', metal.isEmpty ? '-' : metal),
                        _productMeta('Diamond Quality', clarity),
                        _productMeta('SKU', sku),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _kvRow('Date', Text(date)),
          _kvRow(
            'Status',
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.chipBorderColor),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: Get.width * 0.03,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black_color,
                ),
              ),
            ),
          ),
          _kvRow('Qty', Text(qty)),
          _kvRow(
            'Price',
            Row(
              children: [
                Text(
                  _money(price),
                  style: TextStyle(
                    fontSize: Get.width * 0.033,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black_color,
                  ),
                ),
                if (original > price && original > 0) ...[
                  SizedBox(width: 8),
                  Text(
                    _money(original),
                    style: TextStyle(
                      fontSize: Get.width * 0.03,
                      color: AppColor.strikeRed,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColor.strikeRed,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _kvRow('Amount', Text(_money(amount))),
          _kvRow('Action', Text('-')),
        ],
      ),
    );
  }

  Widget _productMeta(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: TextStyle(
                fontSize: Get.width * 0.03,
                fontWeight: FontWeight.w500,
                color: AppColor.black_color,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: Get.width * 0.03,
                fontWeight: FontWeight.w400,
                color: AppColor.grey_color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kvRow(String label, Widget value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.lightDivider),
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
                vertical: Get.height * 0.014,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppColor.Appbercolor.withOpacity(0.55),
                border: Border(
                  right: BorderSide(color: AppColor.lightDivider),
                ),
              ),
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
                  vertical: Get.height * 0.012,
                ),
                alignment: Alignment.centerLeft,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: Get.width * 0.033,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black_color,
                  ),
                  child: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderSummaryCard({
    required double subTotal,
    required double discount,
    required double tax,
    required double shipping,
    required double payable,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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
            color: _summaryHeader,
            child: Text(
              'ORDER SUMMARY',
              style: TextStyle(
                fontSize: Get.width * 0.034,
                fontWeight: FontWeight.w700,
                color: AppColor.white_color,
                letterSpacing: 0.3,
              ),
            ),
          ),
          _summaryRow('Sub Total', _money(subTotal)),
          _summaryRow('Coupon Discount', _money(discount)),
          _summaryRow('Tax(3%)', _money(tax)),
          _summaryRow(
            'Shipping & Handling',
            shipping <= 0 ? 'Free' : _money(shipping),
            valueColor: shipping <= 0 ? AppColor.grey_color : null,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.035,
              vertical: Get.height * 0.016,
            ),
            color: _summaryFooter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payable',
                  style: TextStyle(
                    fontSize: Get.width * 0.036,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white_color,
                  ),
                ),
                Text(
                  _money(payable < 0 ? 0 : payable),
                  style: TextStyle(
                    fontSize: Get.width * 0.036,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white_color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.035,
        vertical: Get.height * 0.014,
      ),
      decoration: BoxDecoration(
        color: AppColor.white_color,
        border: Border(
          bottom: BorderSide(color: AppColor.lightDivider),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Get.width * 0.033,
              fontWeight: FontWeight.w500,
              color: AppColor.black_color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Get.width * 0.033,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColor.black_color,
            ),
          ),
        ],
      ),
    );
  }
}
