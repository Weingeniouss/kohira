// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/modal/menu/category/subcategory/filtercategory.dart';
import 'package:kohira/view/screen/credentials/forgetpassword.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/screen/credentials/otp.dart';
import 'package:kohira/view/screen/credentials/signup.dart';
import 'package:kohira/view/screen/menu/account/addresses/addNewAddresses.dart';
import 'package:kohira/view/screen/menu/account/addresses/addresses.dart';
import 'package:kohira/view/screen/menu/account/addresses/editaddresses.dart';
import 'package:kohira/view/screen/menu/account/compliance%20policy/compliance.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderdetails.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderhistory.dart';
import 'package:kohira/view/screen/menu/account/privacy%20policy/privacy.dart';
import 'package:kohira/view/screen/menu/account/profile%20edit/profileedit.dart';
import 'package:kohira/view/screen/menu/account/retray%20&%20refund%20policy/retray.dart';
import 'package:kohira/view/screen/menu/account/returns%20&%20Exchanges/returns.dart';
import 'package:kohira/view/screen/menu/account/shipping%20&%20delivery%20policy/shipping.dart';
import 'package:kohira/view/screen/menu/account/terms%20&%20condition/terms.dart';
import 'package:kohira/view/screen/menu/account/wallet/wallet.dart';
import 'package:kohira/view/screen/menu/account/warranty%20&%20jewellery%20cleam/warranty.dart';
import 'package:kohira/view/screen/menu/category/category_menu_detail_screen.dart';
import 'package:kohira/view/screen/menu/category/collections_screen.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart';
import 'package:kohira/view/screen/menu/category/subcategory.dart';
import 'package:kohira/view/screen/menu/home/Search.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/customjewellery.dart';
import 'package:kohira/view/screen/menu/myCart/buynow.dart';
import 'package:kohira/view/screen/menu/myCart/checkout.dart';
import 'package:kohira/view/screen/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/menu/myCart/wishList/wishlist.dart';
import 'package:kohira/view/screen/menu/over%20Store/overStoredetails.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';

class AppRoutes {
  // Navigation helpers

  static void back<T>([T? result]) {
    Get.back<T>(result: result);
  }

  static Future<T?>? toHome<T>() {
    return Get.offAll<T>(() => Bottom());
  }

  static Future<T?>? toLogin<T>() {
    return Get.to<T>(() => Login());
  }

  static Future<T?>? offAllToLogin<T>() {
    return Get.offAll<T>(() => Login());
  }

  static Future<T?>? toSignUp<T>() {
    return Get.to<T>(() => Signup());
  }

  static Future<T?>? toForgetPassword<T>() {
    return Get.to<T>(() => Forgetpassword());
  }

  static Future<T?>? toOtp<T>() {
    return Get.to<T>(() => Otp());
  }

  static Future<T?>? toCollections<T>() {
    return Get.to<T>(() => CollectionsScreen());
  }

  static Future<T?>? toCategoryDetail<T>({required Datum categoryItem}) {
    return Get.to<T>(() => CategoryMenuDetailScreen(categoryItem: categoryItem));
  }

  static Future<T?>? toSubcategory<T>({
    String? subcategrorys,
    String? subcategory_slug,
    String? collection_id,
    String? subcategrorysname,
    String? metal_type,
    String? price_min,
    String? price_max,
  }) {
    return Get.to<T>(
      () => Subcategorys(
        subcategrorys: subcategrorys,
        subcategory_slug: subcategory_slug,
        collection_id: collection_id,
        subcategrorysname: subcategrorysname,
        metal_type: metal_type,
        price_min: price_min,
        price_max: price_max,
      ),
    );
  }

  static Future<T?>? toShowProduct<T>({
    required String slug,
    required String categoryslug,
  }) {
    return Get.to<T>(
      () => Showproduct(
        slug: slug,
        categoryslug: categoryslug,
      ),
    );
  }

  static Future<T?>? toWishlist<T>() {
    return Get.to<T>(() => WishlistScreen());
  }

  static Future<T?>? toCart<T>() {
    final myCart = Get.put(MyCartValueChange());
    myCart.loadCartData();
    return Get.to<T>(() => Mycart());
  }

  static Future<T?>? toCheckout<T>() {
    return Get.to<T>(() => Checkout());
  }

  static Future<T?>? toBuyNow<T>() {
    return Get.to<T>(() => Buynow());
  }

  static Future<T?>? toSearch<T>() {
    return Get.to<T>(() => Search());
  }

  static Future<T?>? toCustomJewellery<T>() {
    return Get.to<T>(() => CustomJewellery());
  }

  static Future<T?>? toOrderHistory<T>() {
    return Get.to<T>(
      () => Orderhistory(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toOrderDetails<T>({required String id}) {
    return Get.to<T>(() => Orderdetails(id: id));
  }

  static Future<T?>? toAddresses<T>() {
    return Get.to<T>(
      () => Addresses(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toAddNewAddresses<T>() {
    return Get.to<T>(() => AddNewAddresses());
  }

  static Future<T?>? toEditAddresses<T>({required String id}) {
    return Get.to<T>(() => Editaddresses(id: id));
  }

  static Future<T?>? toProfileEdit<T>() {
    return Get.to<T>(() => Profileedit());
  }

  static Future<T?>? toWallet<T>() {
    return Get.to<T>(
      () => Wallet(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toOverStoreDetails<T>({required String slug}) {
    return Get.to<T>(() => OverstoredetailsScreen(slug: slug));
  }

  static Future<T?>? toPrivacy<T>() {
    return Get.to<T>(
      () => Privacy(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toTerms<T>() {
    return Get.to<T>(
      () => Terms(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toReturns<T>() {
    return Get.to<T>(
      () => Returns(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toShipping<T>() {
    return Get.to<T>(
      () => Shipping(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toWarranty<T>() {
    return Get.to<T>(
      () => Warranty(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toCompliance<T>() {
    return Get.to<T>(
      () => Compliance(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?>? toRetray<T>() {
    return Get.to<T>(
      () => Retray(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
