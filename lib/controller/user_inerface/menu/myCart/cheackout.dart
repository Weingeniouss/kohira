// ignore_for_file: prefer_const_constructors, deprecated_member_use, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cheackout_Controller extends GetxController {
  bool get shouldScroll => !billing.value || !shipping.value || !shippingtype.value;

  final shipping = ValueNotifier<bool>(true);
  var billing = true.obs;
  var shippingtype = true.obs;
  var showItems = false.obs;

  void isbilling() => billing.value =! billing.value;
  void isshippingtype() => shippingtype.value =! shippingtype.value;
  void showitems() => showItems.value =! showItems.value;
}
