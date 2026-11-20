// ignore_for_file: dead_null_aware_expression, file_names, prefer_const_constructors, strict_top_level_inference, avoid_print

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import '../../../../modal/menu/category/subcategory/addtocart.dart';
import '../../../../view/utils/app_constants.dart';
import '../../../API/menu/myCart/deletcart.dart';
import '../../../API/menu/myCart/fetchcart.dart';
import '../../../API/menu/myCart/withoutlogin.dart';
import '../../../database/local/localstore.dart';

Map<String, dynamic> extractCartData(dynamic rawData) {
  if (rawData == null || rawData is! Map) return {};
  if (rawData.containsKey('data') &&
      rawData['data'] is Map &&
      (rawData['data'] as Map).containsKey('carts')) {
    return Map<String, dynamic>.from(rawData['data']);
  }
  return Map<String, dynamic>.from(rawData);
}

class MyCartValueChange extends GetxController {
  var hasDialogShownOnce = false.obs;
  var isDialogVisible = false.obs;

  final fetchcart = Get.put(FetchcartCalling());
  final witoutlogin = Get.put(Withoutlogin());
  final deletcount = Get.put(Deletcart());

  var subTotal = 0.0.obs;
  var discount = 0.0.obs;
  var total = 0.0.obs;
  var tax = 0.0.obs;

  var itemCounts = <int>[].obs;

  bool get isGuestUser => (!islogin || tokans.isEmpty);
  RxList<JewelryItem> existingItems = <JewelryItem>[].obs;

  Timer? _quantityDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    loadCartData();
  }

  @override
  void onClose() {
    _quantityDebounceTimer?.cancel();
    super.onClose();
  }

  Future<void> loadCartData() async {
    try {
      if (isGuestUser) {
        final items = await localdatabase.getJewelryItems();
        existingItems.value = items;
        await witoutlogin.withoutlogin(items);
        _updateAllCartData();
      } else {
        await fetchcart.fetchcartcall();
        _updateAllCartData();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cart data: $e');
      }
    }
  }

  void initializeItemCounts() {
    final rawData = isGuestUser ? witoutlogin.data : fetchcart.data;
    final cartData = extractCartData(rawData);

    if (cartData.isNotEmpty &&
        cartData['carts'] != null &&
        cartData['carts'] is List) {
      itemCounts.value = List.generate(
          (cartData['carts'] as List).length,
          (index) =>
              int.tryParse(cartData['carts'][index]['qty'].toString()) ?? 1);
    }
  }

  // Update all cart data from API response
  void _updateAllCartData() {
    final rawData = isGuestUser ? witoutlogin.data : fetchcart.data;
    final cartData = extractCartData(rawData);

    if (cartData.isNotEmpty &&
        cartData['carts'] != null &&
        cartData['carts'] is List) {
      final List cartsList = cartData['carts'];
      // Update item counts
      final newItemCounts = cartsList.map<int>((item) {
        return int.tryParse(item['qty']?.toString() ?? '1') ?? 1;
      }).toList();
      itemCounts.value = newItemCounts;

      // Update totals
      subTotal.value =
          double.tryParse(cartData['cart_gross']?.toString() ?? '0') ?? 0.0;
      discount.value =
          double.tryParse(cartData['discount']?.toString() ?? '0') ?? 0.0;
      total.value =
          double.tryParse(cartData['net_amount']?.toString() ?? '0') ?? 0.0;

      if (cartData['global_tax'] != null && cartData['global_tax'] is Map) {
        tax.value = double.tryParse(
                cartData['global_tax']['globaltaxcharge']?.toString() ?? '0') ??
            0.0;
      }
    } else {
      // Reset values if cart is empty
      itemCounts.value = [];
      subTotal.value = 0.0;
      discount.value = 0.0;
      total.value = 0.0;
      tax.value = 0.0;
    }
  }

  // Instant local UI quantity increment with debounced API call
  void incrementQuantity(int index) {
    if (index >= itemCounts.length) return;

    itemCounts[index] = itemCounts[index] + 1;
    itemCounts.refresh();
    _recalculateLocalTotals();

    _debounceQuantityUpdate(index);
  }

  // Instant local UI quantity decrement with debounced API call
  void decrementQuantity(int index) {
    if (index >= itemCounts.length || itemCounts[index] <= 1) return;

    itemCounts[index] = itemCounts[index] - 1;
    itemCounts.refresh();
    _recalculateLocalTotals();

    _debounceQuantityUpdate(index);
  }

  // Alias methods for backward compatibility
  void incrementValueOfLocal(int index) => incrementQuantity(index);

  void decrementValueOfLocal(int index) => decrementQuantity(index);

  void incrementValueOfCount(int index) => incrementQuantity(index);

  void decrementValueOfCount(int index) => decrementQuantity(index);

  // Instant local recalculation of subTotal and total
  void _recalculateLocalTotals() {
    final rawData = isGuestUser ? witoutlogin.data : fetchcart.data;
    final cartData = extractCartData(rawData);
    final fetch = cartData['carts'] ?? [];

    if (fetch is List && fetch.isNotEmpty) {
      double newSubTotal = 0.0;
      for (int i = 0; i < fetch.length; i++) {
        final item = fetch[i];
        final fetchdata = item['CartJewelryData'] ?? {};
        final double discountVal =
            double.tryParse(fetchdata['discount']?.toString() ?? '0') ?? 0.0;
        final double price = double.tryParse(((discountVal > 0
                        ? fetchdata['offer_price']
                        : fetchdata['setting_price'])
                    ?.toString() ??
                '0')) ??
            0.0;

        final int q = (i < itemCounts.length) ? itemCounts[i] : 1;
        newSubTotal += (price * q);
      }
      subTotal.value = newSubTotal;
      total.value = (newSubTotal - discount.value) > 0
          ? (newSubTotal - discount.value)
          : 0.0;
    }
  }

  // Debounce API call / Local DB sync (triggers 800ms after last tap)
  void _debounceQuantityUpdate(int index) {
    _quantityDebounceTimer?.cancel();
    _quantityDebounceTimer = Timer(const Duration(milliseconds: 800), () async {
      await _syncFinalQuantity(index);
    });
  }

  Future<void> _syncFinalQuantity(int index) async {
    try {
      final finalQty = itemCounts[index];

      if (isGuestUser) {
        List<JewelryItem> currentItems = await localdatabase.getJewelryItems();
        if (index < currentItems.length) {
          currentItems[index] = JewelryItem(
            diamondId: currentItems[index].diamondId,
            jewelryId: currentItems[index].jewelryId,
            ringSize: currentItems[index].ringSize,
            qty: finalQty,
          );
          await localdatabase.saveJewelryItems(currentItems);
          await witoutlogin.withoutlogin(currentItems);
          _updateAllCartData();
        }
      } else {
        final rawData = fetchcart.data;
        final cartData = extractCartData(rawData);
        final fetch = cartData['carts'] ?? [];
        if (index < fetch.length) {
          final item = fetch[index];
          final cartId = item['id'].toString();
          await fetchcart.fetchcartcall(
            flag: 'flag',
            cart: cartId,
            qty: finalQty.toString(),
            type: 'mobile',
          );
          _updateAllCartData();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing final quantity: $e');
      }
    }
  }

  Future<void> deletvalueoflocal(int index) async {
    if (index >= itemCounts.length) return;

    localdatabase().deleteJewelryItem(index);
    ToastificationSuccess.Success("Item Deleted Successfully");
    await loadCartData();
  }

  // Delete Value
  Future<void> deletValueofcount(item, fetch, int index) async {
    try {
      final deletid = item['id'].toString();
      final diamondid = item['diamondid'].toString();
      final jewelryid = item['jewelryid'].toString();
      final itemcode = item['CartJewelryData']['title'];
      await deletcount.deletcartcall(
          id: deletid, jewelryid: jewelryid, diamondid: diamondid);
      ToastificationSuccess.Success(
          "$itemcode, ${deletcount.data['message'].replaceAll('Cart', '')}");

      if (index < itemCounts.length) {
        itemCounts.removeAt(index);
      }

      await fetchcart.fetchcartcall();
      _updateAllCartData();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting cart item: $e');
      }
      await loadCartData();
    }
  }

  Future<void> refreshCartData() async {
    try {
      _quantityDebounceTimer?.cancel();
      await loadCartData();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing cart data: $e');
      }
    }
  }

  int get cartItemsCount {
    return itemCounts.fold(0, (sum, count) => sum + count);
  }

  bool get isCartEmpty {
    final rawData = isGuestUser ? witoutlogin.data : fetchcart.data;
    final cartData = extractCartData(rawData);
    return itemCounts.isEmpty ||
        cartData['carts'] == null ||
        (cartData['carts'] as List).isEmpty;
  }
}
