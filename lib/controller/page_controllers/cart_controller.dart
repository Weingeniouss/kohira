// ignore_for_file: annotate_overrides, unnecessary_import, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:kohira/api/api_call.dart';
import 'package:kohira/view/utils/app_url.dart';

// Modal imports
import '../../modal/menu/category/subcategory/addtocart.dart';
import '../../modal/menu/category/subcategory/addtowish.dart';

// API Controllers – Cart / Checkout
import '../API/menu/myCart/fetchcart.dart';
import '../API/menu/myCart/countcart.dart';
import '../API/menu/myCart/deletcart.dart';
import '../API/menu/myCart/process-payment.dart';
import '../API/menu/myCart/withoutlogin.dart';
import '../API/menu/others/count.dart';

// UI Controllers – Cart / Wishlist
import '../user_inerface/menu/myCart/myCart.dart';
import '../user_inerface/menu/myCart/wishlist/wishlist.dart';

/// CartController
/// Responsible for all APIs used on the MyCart / Checkout / Wishlist screens:
///   - Fetch Cart
///   - Count Cart item qty
///   - Delete Cart item
///   - Process Payment / Checkout
///   - Cart Without Login
///   - Wishlist Without Login
///   - Cart + Wishlist count badge (top-bar)
///   - Wishlist (fetch)
class CartPageController extends GetxController {
  // =========================================================
  // STATE
  // =========================================================
  final _apiCallTracker = <String, bool>{}.obs;

  // =========================================================
  // CHILD API CONTROLLERS
  // =========================================================
  late final FetchcartCalling fetchcartCalling;
  late final CountCart countCart;
  late final Deletcart deletcart;
  late final Processpayment processpayment;
  late final Withoutlogin withoutlogin;
  late final WithoutloginWishList withoutloginWishList;
  late final CountController count;

  // UI controllers
  late final MyCartValueChange myCart;
  late final WishlistController wishlistController;

  bool _initialized = false;

  // =========================================================
  // LIFECYCLE
  // =========================================================
  @override
  void onInit() {
    super.onInit();
    _initControllers();
    _loadAll();
  }

  void _initControllers() {
    if (_initialized) return;
    _initialized = true;

    fetchcartCalling = Get.isRegistered<FetchcartCalling>()
        ? Get.find<FetchcartCalling>()
        : Get.put(FetchcartCalling());

    countCart = Get.isRegistered<CountCart>()
        ? Get.find<CountCart>()
        : Get.put(CountCart());

    deletcart = Get.isRegistered<Deletcart>()
        ? Get.find<Deletcart>()
        : Get.put(Deletcart());

    processpayment = Get.isRegistered<Processpayment>()
        ? Get.find<Processpayment>()
        : Get.put(Processpayment());

    withoutlogin = Get.isRegistered<Withoutlogin>()
        ? Get.find<Withoutlogin>()
        : Get.put(Withoutlogin());

    withoutloginWishList = Get.isRegistered<WithoutloginWishList>()
        ? Get.find<WithoutloginWishList>()
        : Get.put(WithoutloginWishList());

    count = Get.isRegistered<CountController>()
        ? Get.find<CountController>()
        : Get.put(CountController());

    myCart = Get.isRegistered<MyCartValueChange>()
        ? Get.find<MyCartValueChange>()
        : Get.put(MyCartValueChange());

    wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
  }

  // =========================================================
  // LOAD ALL CART APIs
  // =========================================================

  void _loadAll({bool forceRefresh = false}) {
    if (forceRefresh) _apiCallTracker.clear();

    _callIfNeeded('count', () => count.counting());
    _callIfNeeded('wishlist', () => wishlistController.fetchwishlist.fechwishlist());
    _callIfNeeded('cart', () => myCart.loadCartData());
  }

  /// Public refresh
  void refresh() => _loadAll(forceRefresh: true);

  // =========================================================
  // INDIVIDUAL API WRAPPERS
  // =========================================================

  /// GET: Cart data with optional filters
  Future<dynamic> getCart({
    String? flag,
    String? qty,
    String? cart,
    String? type,
  }) async {
    try {
      return await ApiCall.fetchCartData(
          flag: flag, qty: qty, cart: cart, type: type);
    } catch (e) {
      print('CartController getCart Error: $e');
      return null;
    }
  }

  /// GET: Cart + Wishlist count (top-bar badge)
  Future<dynamic> getCartWishlistCount() async {
    try {
      return await ApiCall.countCartWishlist();
    } catch (e) {
      print('CartController getCartWishlistCount Error: $e');
      return null;
    }
  }

  /// GET: Wishlist items (logged-in user)
  Future<dynamic> getWishlist() async {
    try {
      return await ApiCall.fetchWishlist();
    } catch (e) {
      print('CartController getWishlist Error: $e');
      return null;
    }
  }

  /// POST: Count / update cart item quantity
  Future<dynamic> postCountCart({
    required String jewelryid,
    required String qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
  }) async {
    try {
      await countCart.countcardcall(
        jewelryid: jewelryid,
        qty: qty,
        ringsize: ringsize,
        metal_type: metal_type,
        metal_stamp: metal_stamp,
        sideDiaGrpId: sideDiaGrpId,
      );
    } catch (e) {
      print('CartController postCountCart Error: $e');
    }
  }

  /// POST: Delete a cart item
  Future<dynamic> deleteCartItem({
    required String id,
    required String jewelryid,
    String? diamondid,
  }) async {
    try {
      final body = {
        'id': id,
        'jewelryid': jewelryid,
        'diamondid': diamondid,
      }..removeWhere((key, value) => value == null);
      return await ApiCall.postRequest(AppUrl.deletcart,
          data: body, useAuth: true);
    } catch (e) {
      print('CartController deleteCartItem Error: $e');
      return null;
    }
  }

  /// POST: Process payment / place order
  Future<dynamic> postProcessPayment({
    String? firstname,
    String? lastname,
    String? email,
    String? address,
    String? city,
    String? state,
    String? country,
    String? countrycode,
    String? zip,
    String? mobileno,
    String? Payment_method,
    String? coupon_id,
    String? coupon_amount,
    String? grossamt,
    String? discountamt,
    String? totalamount,
    String? netamount,
    String? iswallet,
    String? walletAmount,
    String? remainingAmount,
    String? amount,
    String? paymenttype,
  }) async {
    try {
      await processpayment.processpayment(
        firstname: firstname,
        lastname: lastname,
        email: email,
        address: address,
        city: city,
        state: state,
        country: country,
        countrycode: countrycode,
        zip: zip,
        mobileno: mobileno,
        Payment_method: Payment_method,
        coupon_id: coupon_id,
        coupon_amount: coupon_amount,
        grossamt: grossamt,
        discountamt: discountamt,
        totalamount: totalamount,
        netamount: netamount,
        iswallet: iswallet,
        walletAmount: walletAmount,
        remainingAmount: remainingAmount,
        amount: amount,
        paymenttype: paymenttype,
      );
    } catch (e) {
      print('CartController postProcessPayment Error: $e');
    }
  }

  /// POST: Cart without login (guest user)
  Future<dynamic> postCartWithoutLogin(
    List<JewelryItem> cartData, {
    String couponCode = '',
  }) async {
    try {
      await withoutlogin.withoutlogin(cartData, couponCode: couponCode);
    } catch (e) {
      print('CartController postCartWithoutLogin Error: $e');
    }
  }

  /// POST: Wishlist without login (guest user)
  Future<dynamic> postWishlistWithoutLogin(
      List<JewelryItemWish> wishData) async {
    try {
      await withoutloginWishList.withoutloginwishlist(wishData);
    } catch (e) {
      print('CartController postWishlistWithoutLogin Error: $e');
    }
  }

  /// PUT: Update cart item quantity
  Future<dynamic> putUpdateCartItem(dynamic body) async {
    try {
      return await ApiCall.putRequest(AppUrl.cart, data: body, useAuth: true);
    } catch (e) {
      print('CartController putUpdateCartItem Error: $e');
      return null;
    }
  }

  // =========================================================
  // UTILS
  // =========================================================
  void _callIfNeeded(String key, Function call) {
    if (_apiCallTracker[key] == true) return;
    _apiCallTracker[key] = true;
    call();
  }

  @override
  void onClose() {
    _apiCallTracker.clear();
    super.onClose();
  }
}
