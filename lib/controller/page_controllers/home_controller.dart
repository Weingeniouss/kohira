// ignore_for_file: deprecated_member_use, unnecessary_import, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';

// API Controllers – Home
import '../API/menu/home/slider.dart';
import '../API/menu/home/categories.dart';
import '../API/menu/home/homecollction.dart';
import '../API/menu/home/homejewelry.dart';
import '../API/menu/home/offer_banner.dart';
import '../API/menu/home/news_list.dart';
import '../API/menu/home/Search.dart';

// UI / Service Controllers – Home
import '../user_inerface/menu/home/menuwidget/homedashbord.dart';
import '../service/menu/home/homedashbord.dart';
import '../user_inerface/menu/overStore/store_locations_controller.dart';

/// HomeController
/// Responsible for all APIs used on the Home screen:
///   - Slider
///   - Categories (home version)
///   - Home Jewelry sections
///   - Offer Banners
///   - News List
///   - Home Collections (section-wise)
///   - Home Dashboard
///   - Store Locations (home map widget)
///   - Search
class HomePageController extends GetxController {
  // =========================================================
  // STATE
  // =========================================================
  final RxBool _isLoading = false.obs;
  final _apiCallTracker = <String, bool>{}.obs;

  bool get isBusy => _isLoading.value;

  // Carousel / UI
  RxInt activeIndex = 0.obs;
  final pagecontroller = CarouselSliderController();
  final pageController = CarouselController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // =========================================================
  // CHILD API CONTROLLERS
  // =========================================================
  late final SliderCalling slider;
  late final CategoriesCalling categories;
  late final Homecollction homecollction;
  late final Homejewelry homejewelry;
  late final OfferBannerCalling offerBanner;
  late final NewsListCalling newsList;
  late final SearchProduct searchProduct;
  late final Homedashbord homedashbord;
  late final HomepageJewelryList homepageJewelryList;
  late final StoreLocationsController storeLocations;

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

    slider = Get.isRegistered<SliderCalling>()
        ? Get.find<SliderCalling>()
        : Get.put(SliderCalling());

    categories = Get.isRegistered<CategoriesCalling>()
        ? Get.find<CategoriesCalling>()
        : Get.put(CategoriesCalling());

    homecollction = Get.isRegistered<Homecollction>()
        ? Get.find<Homecollction>()
        : Get.put(Homecollction());

    homejewelry = Get.isRegistered<Homejewelry>()
        ? Get.find<Homejewelry>()
        : Get.put(Homejewelry());

    offerBanner = Get.isRegistered<OfferBannerCalling>()
        ? Get.find<OfferBannerCalling>()
        : Get.put(OfferBannerCalling());

    newsList = Get.isRegistered<NewsListCalling>()
        ? Get.find<NewsListCalling>()
        : Get.put(NewsListCalling());

    searchProduct = Get.isRegistered<SearchProduct>()
        ? Get.find<SearchProduct>()
        : Get.put(SearchProduct());

    homedashbord = Get.isRegistered<Homedashbord>()
        ? Get.find<Homedashbord>()
        : Get.put(Homedashbord());

    homepageJewelryList = Get.isRegistered<HomepageJewelryList>()
        ? Get.find<HomepageJewelryList>()
        : Get.put(HomepageJewelryList());

    storeLocations = Get.isRegistered<StoreLocationsController>()
        ? Get.find<StoreLocationsController>()
        : Get.put(StoreLocationsController());
  }

  // =========================================================
  // LOAD ALL HOME APIs
  // =========================================================

  /// Load all Home screen APIs. Call [forceRefresh] = true to re-fetch everything.
  void _loadAll({bool forceRefresh = false}) {
    if (forceRefresh) {
      _apiCallTracker.clear();
    }

    _callIfNeeded('slider', () => slider.slideruser());
    _callIfNeeded('categories', () => categories.categoriesuser());
    _callIfNeeded('homejewelry', () => homejewelry.getHomejewelry());
    _callIfNeeded('homepageJewelryList', () => homepageJewelryList.homeJewelryList());
    _callIfNeeded('offerBanner', () => offerBanner.getOfferBanners());
    _callIfNeeded('newsList', () => newsList.getNewsList());
    _callIfNeeded('homedashbord', () => homedashbord.homedashbord());
    _callIfNeeded('storeLocations', () => storeLocations.fetchStoreLocations());
    _loadCollectionsWithDelay(forceRefresh: forceRefresh);
  }

  /// Public refresh method – call from UI pull-to-refresh etc.
  @override
  void refresh() => _loadAll(forceRefresh: true);

  void _loadCollectionsWithDelay({bool forceRefresh = false}) {
    Future.delayed(const Duration(milliseconds: 100), () {
      _callIfNeeded('homecollction_2',
          () => homecollction.homecollction(section_no: '2'));
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _callIfNeeded('homecollction_3',
          () => homecollction.homecollction(section_no: '3'));
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _callIfNeeded('homecollction_4',
          () => homecollction.homecollction(section_no: '4'));
    });
  }

  // =========================================================
  // INDIVIDUAL API WRAPPERS (direct call from UI / other controllers)
  // =========================================================

  /// GET: Slider data
  Future<dynamic> getSlider() async {
    try {
      return await ApiCall.fetchSliderData();
    } catch (e) {
      print('HomePageController getSlider Error: $e');
      return null;
    }
  }

  /// GET: Home Dashboard data
  Future<dynamic> getHomeDashboard() async {
    try {
      return await ApiCall.fetchDashboardData();
    } catch (e) {
      print('HomePageController getHomeDashboard Error: $e');
      return null;
    }
  }

  /// GET: Categories list (home version)
  Future<dynamic> getCategories() async {
    try {
      return await ApiCall.fetchCategoryData();
    } catch (e) {
      print('HomePageController getCategories Error: $e');
      return null;
    }
  }

  /// GET: Offer Banners
  Future<dynamic> getOfferBanners() async {
    try {
      return await ApiCall.fetchBannerData();
    } catch (e) {
      print('HomePageController getOfferBanners Error: $e');
      return null;
    }
  }

  /// GET: News List
  Future<dynamic> getNewsList() async {
    try {
      return await ApiCall.fetchNewsListData();
    } catch (e) {
      print('HomePageController getNewsList Error: $e');
      return null;
    }
  }

  /// GET: Home Jewelry sections
  Future<dynamic> getHomeJewelry() async {
    try {
      return await ApiCall.fetchHomeJewelryData();
    } catch (e) {
      print('HomePageController getHomeJewelry Error: $e');
      return null;
    }
  }

  /// GET: Homepage Jewelry List
  Future<dynamic> getHomepageJewelryList() async {
    try {
      return await ApiCall.getRequest(AppUrl.homepage_JewelryList, useAuth: false);
    } catch (e) {
      print('HomePageController getHomepageJewelryList Error: $e');
      return null;
    }
  }

  /// GET: Store Locations (map widget on home)
  Future<dynamic> getStoreLocations() async {
    try {
      return await ApiCall.fetchStoreLocationsData();
    } catch (e) {
      print('HomePageController getStoreLocations Error: $e');
      return null;
    }
  }

  /// POST: Home Collection by section number
  Future<dynamic> postHomeCollection({required String sectionNo}) async {
    try {
      final body = {'section_no': sectionNo};
      return await ApiCall.postRequest(AppUrl.homecollcation, data: body, useAuth: false);
    } catch (e) {
      print('HomePageController postHomeCollection Error: $e');
      return null;
    }
  }

  /// POST: Search products
  Future<dynamic> searchProducts({
    String? search,
    String? type,
    String? metal_type,
    String? metal_stamp,
    String? diamond_type,
    String? setting_type,
    String? weight_min,
    String? weight_max,
    String? price_min,
    String? order_column,
    String? sort,
    String? page,
  }) async {
    try {
      final body = {
        'search': search,
        'type': type,
        'metal_type': metal_type,
        'metal_stamp': metal_stamp,
        'diamond_type': diamond_type,
        'setting_type': setting_type,
        'weight_min': weight_min,
        'weight_max': weight_max,
        'price_min': price_min,
        'order_column': order_column,
        'sort': sort,
        'page': page,
      }..removeWhere((key, value) => value == null);
      return await ApiCall.postRequest(AppUrl.search, data: body, useAuth: false);
    } catch (e) {
      print('HomePageController searchProducts Error: $e');
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

  void changeCarouselIndex(int index, dynamic reason) {
    activeIndex.value = index;
  }

  @override
  void onClose() {
    _apiCallTracker.clear();
    super.onClose();
  }
}
