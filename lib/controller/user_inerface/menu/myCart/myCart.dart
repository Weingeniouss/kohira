
// ignore_for_file: file_names, prefer_const_constructors

// class MyCartValueChange extends GetxController {
//   var hasDialogShownOnce = false.obs;
//   var isDialogVisible = false.obs;
//
//   final fetchcart = Get.put(FetchcartCalling());
//   final countcart = Get.put(CountCart());
//   final deletcount = Get.put(Deletcart());
//
//   var subTotal = 0.0.obs;
//   var discount = 0.0.obs;
//   var total = 0.0.obs;
//   var tax = 0.0.obs;
//
//   var itemCounts = <int>[].obs;
//   Timer? _debounce;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadCartData();
//   }
//
//   //load data
//   Future<void> loadCartData() async {
//     try {
//       await fetchcart.fetchcartcall();
//
//       if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
//         final newItemCounts = fetchcart.data['carts'].map<int>((item) {
//           return int.tryParse(item['qty'].toString()) ?? 1;
//         }).toList();
//         itemCounts.value = newItemCounts;
//         subTotal.value = double.tryParse(fetchcart.data['cart_gross'].toString()) ?? 0.0;
//         discount.value = double.tryParse(fetchcart.data['discount'].toString()) ?? 0.0;
//         total.value = double.tryParse(fetchcart.data['net_amount'].toString()) ?? 0.0;
//         if (fetchcart.data['global_tax'] != null) {
//           tax.value = double.tryParse(fetchcart.data['global_tax']['globaltaxcharge'].toString()) ?? 0.0;
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error loading cart data: $e');
//       }
//     }
//   }
//
//   // View of Index
//   void initializeItemCounts() {
//     if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
//       itemCounts.value = List.generate(fetchcart.data['carts'].length, (index) => int.parse(fetchcart.data['carts'][index]['qty'].toString()));
//     }
//   }
//
//   // Helper method to update cart totals from API response
//   void updateCartTotals() {
//     if (fetchcart.data.isNotEmpty) {
//       subTotal.value = double.tryParse(fetchcart.data['cart_gross'].toString()) ?? subTotal.value;
//       discount.value = double.tryParse(fetchcart.data['discount'].toString()) ?? discount.value;
//       total.value = double.tryParse(fetchcart.data['net_amount'].toString()) ?? total.value;
//
//       if (fetchcart.data['global_tax'] != null) {
//         tax.value = double.tryParse(fetchcart.data['global_tax']['globaltaxcharge'].toString()) ?? tax.value;
//       }
//     }
//   }
//
//   //increment Value
//   Future<void> incrementValueOfCount(int index) async {
//     if (index >= itemCounts.length) return;
//     final item = fetchcart.data['carts'][index];
//     final price = double.parse(item['CartJewelryData']['offerprice'].toString());
//     final cartId = item['id'].toString();
//     final updatedQty = itemCounts[index] + 1;
//     itemCounts[index] = updatedQty;
//     subTotal.value += price;
//     total.value = subTotal.value - discount.value;
//     _debounce?.cancel();
//     _debounce = Timer(Duration(milliseconds: 800), () async {
//       await fetchcart.fetchcartcall(flag: 'flag', cart: cartId, qty: updatedQty.toString(), type: 'mobile');
//       if (!isClosed) {
//         updateCartTotals();
//       }
//       ToastificationSuccess.Success('Increment QTY Successfully');
//     });
//   }
//
//   //Decrement Value
//   Future<void> decrementValueOfCount(int index) async {
//     if (index >= itemCounts.length || itemCounts[index] <= 1) return;
//     final item = fetchcart.data['carts'][index];
//     final price = double.parse(item['CartJewelryData']['offerprice'].toString());
//     final cartId = item['id'].toString();
//     final updatedQty = itemCounts[index] - 1;
//     itemCounts[index] = updatedQty;
//     subTotal.value -= price;
//     total.value = subTotal.value - discount.value;
//     _debounce?.cancel();
//     _debounce = Timer(Duration(milliseconds: 800), () async {
//       await fetchcart.fetchcartcall(flag: 'flag', cart: cartId, qty: updatedQty.toString(), type: 'mobile');
//       if (!isClosed) {
//         updateCartTotals();
//       }
//       ToastificationSuccess.Success('Decrement QTY Successfully');
//     });
//   }
//
//   //Delete Value
//   Future<void> deletValueofcount(item, fetch, int index) async {
//     final deletid = item['id'].toString();
//     final diamondid = item['diamondid'].toString();
//     final jewelryid = item['jewelryid'].toString();
//     final itemcode = item['CartJewelryData']['title'];
//     await deletcount.deletcartcall(id: deletid, jewelryid: jewelryid, diamondid: diamondid);
//     ToastificationSuccess.Success("$itemcode, ${deletcount.data['message'].replaceAll('Cart', '')}");
//     if (index < itemCounts.length) itemCounts.removeAt(index);
//     await fetchcart.fetchcartcall();
//     updateCartTotals();
//   }
// }

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
  final deletcount = Get.put(Deletcart());

  var subTotal = 0.0.obs;
  var discount = 0.0.obs;
  var total = 0.0.obs;
  var tax = 0.0.obs;

  var itemCounts = <int>[].obs;

  // Store pending updates for each cart item
  Map<int, int> pendingUpdates = {};
  Timer? _debounce;
  bool _isUpdating = false;

  @override
  void onInit() {
    super.onInit();
    loadCartData();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  // Load data
  Future<void> loadCartData() async {
    try {
      await fetchcart.fetchcartcall();
      _updateAllCartData();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cart data: $e');
      }
    }
  }

  void initializeItemCounts() {
    if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
      itemCounts.value = List.generate(fetchcart.data['carts'].length, (index) => int.parse(fetchcart.data['carts'][index]['qty'].toString()));
    }
  }

  // Update all cart data from API response
  void _updateAllCartData() {
    if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
      // Update item counts
      final newItemCounts = fetchcart.data['carts'].map<int>((item) {
        return int.tryParse(item['qty'].toString()) ?? 1;
      }).toList();
      itemCounts.value = newItemCounts;

      // Update totals
      subTotal.value = double.tryParse(fetchcart.data['cart_gross'].toString()) ?? 0.0;
      discount.value = double.tryParse(fetchcart.data['discount'].toString()) ?? 0.0;
      total.value = double.tryParse(fetchcart.data['net_amount'].toString()) ?? 0.0;

      if (fetchcart.data['global_tax'] != null) {
        tax.value = double.tryParse(fetchcart.data['global_tax']['globaltaxcharge'].toString()) ?? 0.0;
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

  // Process all pending updates
  Future<void> _processPendingUpdates() async {
    if (_isUpdating || pendingUpdates.isEmpty) return;

    _isUpdating = true;

    try {
      // Process each pending update
      for (var entry in pendingUpdates.entries) {
        final index = entry.key;
        final finalQty = entry.value;

        if (index < fetchcart.data['carts'].length) {
          final item = fetchcart.data['carts'][index];
          final cartId = item['id'].toString();

          await fetchcart.fetchcartcall(
              flag: 'flag',
              cart: cartId,
              qty: finalQty.toString(),
              type: 'mobile'
          );
        }
      }

      // Clear pending updates after processing
      pendingUpdates.clear();

      // Refresh cart data to get updated totals
      if (!isClosed) {
        await fetchcart.fetchcartcall();
        _updateAllCartData();
        ToastificationSuccess.Success('Cart updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing pending updates: $e');
      }
      // Revert on error
      await loadCartData();
    } finally {
      _isUpdating = false;
    }
  }

  // Increment Value
  void incrementValueOfCount(int index) {
    if (index >= itemCounts.length) return;

    // Update local state immediately
    itemCounts[index] = itemCounts[index] + 1;

    // Store the pending update
    pendingUpdates[index] = itemCounts[index];

    // Cancel existing timer and start new one
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () {
      _processPendingUpdates();
    });
  }

  // Decrement Value
  void decrementValueOfCount(int index) {
    if (index >= itemCounts.length || itemCounts[index] <= 1) return;

    // Update local state immediately
    itemCounts[index] = itemCounts[index] - 1;

    // Store the pending update
    pendingUpdates[index] = itemCounts[index];

    // Cancel existing timer and start new one
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () {
      _processPendingUpdates();
    });
  }

  // Delete Value
  Future<void> deletValueofcount(item, fetch, int index) async {
    try {
      final deletid = item['id'].toString();
      final diamondid = item['diamondid'].toString();
      final jewelryid = item['jewelryid'].toString();
      final itemcode = item['CartJewelryData']['title'];

      await deletcount.deletcartcall(
          id: deletid,
          jewelryid: jewelryid,
          diamondid: diamondid
      );

      ToastificationSuccess.Success(
          "$itemcode, ${deletcount.data['message'].replaceAll('Cart', '')}"
      );

      // Remove from pending updates if exists
      pendingUpdates.remove(index);

      // Remove item from local state
      if (index < itemCounts.length) {
        itemCounts.removeAt(index);
      }

      // Refresh all cart data from API
      await fetchcart.fetchcartcall();
      _updateAllCartData();

    } catch (e) {
      if (kDebugMode) {
        print('Error deleting cart item: $e');
      }
      // Revert on error
      await loadCartData();
    }
  }

  // Force refresh cart data (useful for pull-to-refresh)
  Future<void> refreshCartData() async {
    try {
      // Cancel any pending updates
      _debounce?.cancel();
      pendingUpdates.clear();

      await fetchcart.fetchcartcall();
      _updateAllCartData();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing cart data: $e');
      }
    }
  }

  // Get cart items count for badge, etc.
  int get cartItemsCount {
    return itemCounts.fold(0, (sum, count) => sum + count);
  }

  // Check if cart is empty
  bool get isCartEmpty {
    return itemCounts.isEmpty || fetchcart.data['carts'] == null || fetchcart.data['carts'].isEmpty;
  }

  // Check if there are pending updates
  bool get hasPendingUpdates {
    return pendingUpdates.isNotEmpty;
  }
}