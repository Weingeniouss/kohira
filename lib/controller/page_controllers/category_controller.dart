// ignore_for_file: unnecessary_import, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/view/utils/app_url.dart';

// API Controllers – Category
import '../API/menu/category/category.dart';
import '../API/menu/category/jewelleryDetail.dart';
import '../API/menu/category/recommendedJewelleryList.dart';
import '../API/menu/category/addtocart.dart';
import '../API/menu/category/wishlist.dart';
import '../API/menu/category/subcategrory/subCategrory.dart';
import '../API/menu/category/subcategrory/filtercategory.dart';
import '../API/menu/category/subcategrory/jewelleryfilter.dart';
import '../API/menu/others/drawer/Jewellery_list.dart';
import '../API/menu/others/drawer/collection.dart';
import '../API/menu/home/drawar/customJewellery/customorder.dart';
import '../API/menu/home/drawar/customJewellery/clarity.dart';
import '../API/menu/home/drawar/customJewellery/submit_custom_jewelley.dart';

/// CategoryController
/// Responsible for all APIs used on the Category / Product screens:
///   - Category list
///   - Subcategory / product listing
///   - Jewellery detail
///   - Recommended Jewellery list
///   - Add to Cart
///   - Wishlist (add / fetch / delete)
///   - Jewellery filter + filter category
///   - Drawer: Jewellery list, Collections
///   - Custom Jewellery (clarity, custom order, submit)
class CategoryPageController extends GetxController {
  // =========================================================
  // STATE
  // =========================================================
  final _apiCallTracker = <String, bool>{}.obs;

  // =========================================================
  // CHILD API CONTROLLERS
  // =========================================================
  late final CategoryCalling categoryCalling;
  late final JewellerydetailCall jewellerydetailCall;
  late final Recommendedjewellerylist recommendedjewellerylist;
  late final Addtocart addtocart;

  // Wishlist
  late final Wishlist wishlistAdd;
  late final FetchWishtlist wishlistFetch;
  late final DeletWishtlist wishlistDelete;

  // Subcategory / filter
  late final Subcategrory subcategrory;
  late final JewelleryFilterCategory filterCategory;
  late final Jewelleryfilter jewelleryfilter;

  // Drawer
  late final JewelleryList jewelleryList;
  late final Collection collection;

  // Custom Jewellery
  late final Customorder customorder;
  late final Clarity clarity;
  late final SubmitCustomJewelley submitCustomJewelley;

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

    categoryCalling = Get.isRegistered<CategoryCalling>()
        ? Get.find<CategoryCalling>()
        : Get.put(CategoryCalling());

    jewellerydetailCall = Get.isRegistered<JewellerydetailCall>()
        ? Get.find<JewellerydetailCall>()
        : Get.put(JewellerydetailCall());

    recommendedjewellerylist = Get.isRegistered<Recommendedjewellerylist>()
        ? Get.find<Recommendedjewellerylist>()
        : Get.put(Recommendedjewellerylist());

    addtocart = Get.isRegistered<Addtocart>()
        ? Get.find<Addtocart>()
        : Get.put(Addtocart());

    wishlistAdd = Get.isRegistered<Wishlist>()
        ? Get.find<Wishlist>()
        : Get.put(Wishlist());

    wishlistFetch = Get.isRegistered<FetchWishtlist>()
        ? Get.find<FetchWishtlist>()
        : Get.put(FetchWishtlist());

    wishlistDelete = Get.isRegistered<DeletWishtlist>()
        ? Get.find<DeletWishtlist>()
        : Get.put(DeletWishtlist());

    subcategrory = Get.isRegistered<Subcategrory>()
        ? Get.find<Subcategrory>()
        : Get.put(Subcategrory());

    filterCategory = Get.isRegistered<JewelleryFilterCategory>()
        ? Get.find<JewelleryFilterCategory>()
        : Get.put(JewelleryFilterCategory());

    jewelleryfilter = Get.isRegistered<Jewelleryfilter>()
        ? Get.find<Jewelleryfilter>()
        : Get.put(Jewelleryfilter());

    jewelleryList = Get.isRegistered<JewelleryList>()
        ? Get.find<JewelleryList>()
        : Get.put(JewelleryList());

    collection = Get.isRegistered<Collection>()
        ? Get.find<Collection>()
        : Get.put(Collection());

    customorder = Get.isRegistered<Customorder>()
        ? Get.find<Customorder>()
        : Get.put(Customorder());

    clarity = Get.isRegistered<Clarity>()
        ? Get.find<Clarity>()
        : Get.put(Clarity());

    submitCustomJewelley = Get.isRegistered<SubmitCustomJewelley>()
        ? Get.find<SubmitCustomJewelley>()
        : Get.put(SubmitCustomJewelley());
  }

  // =========================================================
  // LOAD ALL CATEGORY APIs
  // =========================================================

  void _loadAll({bool forceRefresh = false}) {
    if (forceRefresh) _apiCallTracker.clear();

    _callIfNeeded('categories', () => categoryCalling.categroryservice());
    _callIfNeeded('jewellery_filter', () => jewelleryfilter.fetchJewelleryFilter());
    _callIfNeeded('filter_category', () => filterCategory.fetchFilter());
    _callIfNeeded('jewellery_list', () => jewelleryList.jewellerylist());
    _callIfNeeded('collection', () => collection.collectiondata());
    _callIfNeeded('subcategory', () => subcategrory.subcategroryuser());
    _callIfNeeded('custom_order', () => customorder.fetchCustomorder());
    _callIfNeeded('clarity', () => clarity.clarity());
  }

  /// Public refresh
  @override
  void refresh() => _loadAll(forceRefresh: true);

  // =========================================================
  // INDIVIDUAL API WRAPPERS
  // =========================================================

  /// GET: Category list
  Future<dynamic> getCategories() async {
    try {
      return await ApiCall.fetchCategoryData();
    } catch (e) {
      print('CategoryController getCategories Error: $e');
      return null;
    }
  }

  /// GET: Jewellery detail by slug
  Future<dynamic> getJewelleryDetail(String slug) async {
    try {
      return await ApiCall.fetchJewelleryDetail(slug);
    } catch (e) {
      print('CategoryController getJewelleryDetail Error: $e');
      return null;
    }
  }

  /// GET: Recommended Jewellery list by slug
  Future<dynamic> getRecommendedJewellery(String slug) async {
    try {
      return await ApiCall.fetchRecommendedJewellery(slug);
    } catch (e) {
      print('CategoryController getRecommendedJewellery Error: $e');
      return null;
    }
  }

  /// GET: Jewellery filter options
  Future<dynamic> getJewelleryFilter() async {
    try {
      return await ApiCall.getRequest(AppUrl.jewellery_filter, useAuth: false);
    } catch (e) {
      print('CategoryController getJewelleryFilter Error: $e');
      return null;
    }
  }

  /// GET: Filter category list
  Future<dynamic> getFilterCategory() async {
    try {
      return await ApiCall.fetchFilterCategory();
    } catch (e) {
      print('CategoryController getFilterCategory Error: $e');
      return null;
    }
  }

  /// GET: Drawer – Jewellery list (metal types, stamps etc.)
  Future<dynamic> getJewelleryList() async {
    try {
      return await ApiCall.getRequest(AppUrl.jewellery_filter, useAuth: false);
    } catch (e) {
      print('CategoryController getJewelleryList Error: $e');
      return null;
    }
  }

  /// GET: Drawer – Collections
  Future<dynamic> getCollections() async {
    try {
      return await ApiCall.getRequest(AppUrl.collection, useAuth: false);
    } catch (e) {
      print('CategoryController getCollections Error: $e');
      return null;
    }
  }

  /// GET: Custom Order options
  Future<dynamic> getCustomOrder() async {
    try {
      return await ApiCall.getRequest(AppUrl.customorder, useAuth: false);
    } catch (e) {
      print('CategoryController getCustomOrder Error: $e');
      return null;
    }
  }

  /// GET: Clarity options (for custom jewellery)
  Future<dynamic> getClarity() async {
    try {
      return await ApiCall.getRequest(AppUrl.clarity, useAuth: false);
    } catch (e) {
      print('CategoryController getClarity Error: $e');
      return null;
    }
  }

  /// GET: Wishlist items
  Future<dynamic> getWishlist() async {
    try {
      return await ApiCall.fetchWishlist();
    } catch (e) {
      print('CategoryController getWishlist Error: $e');
      return null;
    }
  }

  /// POST: Add to Cart
  Future<dynamic> postAddToCart({
    required String token,
    String? jewelryid,
    String? qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
  }) async {
    try {
      await addtocart.addtocartservice(
        tokan: token,
        jewelryid: jewelryid,
        qty: qty,
        ringsize: ringsize,
        metal_type: metal_type,
        metal_stamp: metal_stamp,
        sideDiaGrpId: sideDiaGrpId,
      );
    } catch (e) {
      print('CategoryController postAddToCart Error: $e');
    }
  }

  /// POST: Add to Wishlist
  Future<dynamic> postAddToWishlist({
    required String token,
    String? jewelryid,
    String? qty,
    String? ringsize,
    String? metal_type,
    String? metal_stamp,
    String? sideDiaGrpId,
    bool showDialog = true,
  }) async {
    try {
      await wishlistAdd.wishlistservice(
        tokan: token,
        jewelryid: jewelryid,
        qty: qty,
        ringsize: ringsize,
        metal_type: metal_type,
        metal_stamp: metal_stamp,
        sideDiaGrpId: sideDiaGrpId,
        showDialog: showDialog,
      );
    } catch (e) {
      print('CategoryController postAddToWishlist Error: $e');
    }
  }

  /// POST: Delete Wishlist item
  Future<dynamic> deleteWishlistItem(String id) async {
    try {
      final body = {'id': id};
      return await ApiCall.postRequest(AppUrl.wishlistdelete, data: body, useAuth: true);
    } catch (e) {
      print('CategoryController deleteWishlistItem Error: $e');
      return null;
    }
  }

  /// POST: Submit Custom Jewellery
  Future<dynamic> postSubmitCustomJewellery(dynamic body) async {
    try {
      return await ApiCall.postRequest(AppUrl.addcustom, data: body, useAuth: false);
    } catch (e) {
      print('CategoryController postSubmitCustomJewellery Error: $e');
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
