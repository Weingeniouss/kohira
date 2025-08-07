
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import '../../../API/menu/myCart/countcart.dart';
import '../../../API/menu/myCart/deletcart.dart';
import '../../../API/menu/myCart/fetchcart.dart';

class MyCartValueChange extends GetxController {
  var hasDialogShownOnce = false.obs;
  var isDialogVisible = false.obs;

  final fetchcart = Get.put(FetchcartCalling());
  final countcart = Get.put(CountCart());
  final deletcount = Get.put(Deletcart());

  var subTotal = 0.0.obs;
  var discount = 0.0.obs;
  var total = 0.0.obs;

  var itemCounts = <int>[].obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    loadCartData();
  }

  //load data
  Future<void> loadCartData() async {
    try {
      await fetchcart.fetchcartcall();

      if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
        final newItemCounts = fetchcart.data['carts'].map<int>((item) {
          return int.tryParse(item['qty'].toString()) ?? 1;
        }).toList();

        itemCounts.value = newItemCounts;

        final newSubTotal = double.tryParse(fetchcart.data['old_gross_total'].toString()) ?? 0.0;
        final newDiscount = double.tryParse(fetchcart.data['discount_price'].toString()) ?? 0.0;
        final newTotal = newSubTotal - newDiscount;

        itemCounts = newItemCounts;
        subTotal.value = newSubTotal;
        discount.value = newDiscount;
        total.value = newTotal;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cart data: $e');
      }
    }
  }

  //Viwe of Index
  void initializeItemCounts() {
    if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
      itemCounts.value = List.generate(fetchcart.data['carts'].length, (index) => int.parse(fetchcart.data['carts'][index]['qty'].toString()));
    }
  }


  //increment Value
  Future<void> incrementValueOfCount(int index) async {
    if (index >= itemCounts.length) return;

    final item = fetchcart.data['carts'][index];
    final price = double.parse(item['CartJewelryData']['offerprice'].toString());
    final cartId = item['id'].toString();
    final updatedQty = itemCounts[index] + 1;

    itemCounts[index] = updatedQty;
    subTotal.value += price;
    total.value = subTotal.value - discount.value;

    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () async {
      await fetchcart.fetchcartcall(flag: 'flag', cart: cartId, qty: updatedQty.toString(), type: 'mobile');
      if (!isClosed) {
        subTotal.value = double.parse(fetchcart.data['old_gross_total'].toString());
        discount.value = double.parse(fetchcart.data['discount_price'].toString());
        total.value = subTotal.value - discount.value;
      }
      ToastificationSuccess.Success('Increment QTY Successfully');
    });
  }

  //Decrement Value
 Future<void> decrementValueOfCount(int index) async{
    if (index >= itemCounts.length || itemCounts[index] <= 1) return;

    final item = fetchcart.data['carts'][index];
    final price = double.parse(item['CartJewelryData']['offerprice'].toString());
    final cartId = item['id'].toString();
    final updatedQty = itemCounts[index] - 1;

    itemCounts[index] = updatedQty;
    subTotal.value -= price;
    total.value = subTotal.value - discount.value;

    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () async {
      await fetchcart.fetchcartcall(flag: 'flag', cart: cartId, qty: updatedQty.toString(), type: 'mobile');
      if (!isClosed) {
        subTotal.value = double.parse(fetchcart.data['old_gross_total'].toString());
        discount.value = double.parse(fetchcart.data['discount_price'].toString());
        total.value = subTotal.value - discount.value;
      }
      ToastificationSuccess.Success('Decrement QTY Successfully');
    });
  }

  //Delet Value
  Future<void> deletValueofcount(item, fetch, int index) async {
    final deletid = item['id'].toString();
    final diamondid = item['diamondid'].toString();
    final jewelryid = item['jewelryid'].toString();

    await deletcount.deletcartcall(id: deletid, jewelryid: jewelryid, diamondid: diamondid);
    if (index < itemCounts.length) itemCounts.removeAt(index);

    await fetchcart.fetchcartcall();
    subTotal.value = double.tryParse(fetchcart.data['old_gross_total'].toString()) ?? 0.0;
    discount.value = double.tryParse(fetchcart.data['discount_price'].toString()) ?? 0.0;
    total.value = subTotal.value - discount.value;
  }
}
