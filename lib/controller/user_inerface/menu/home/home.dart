// ignore_for_file: unnecessary_import, unused_import, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/api/api_call.dart';
import 'package:kohira/services/api_service.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/widget/pop.dart';

// Modal imports
import '../../../../modal/menu/category/subcategory/addtocart.dart';
import '../../../../modal/menu/category/subcategory/addtowish.dart';
import '../../../../modal/menu/home/dashboard.dart';
import '../../../../modal/menu/home/home_jewelry_sections.dart';
import '../../../../modal/menu/home/store_locations.dart';

// API Controllers
import '../../../API/credentials/Sinup.dart';
import '../../../API/credentials/country.dart';
import '../../../API/credentials/forgetpasssword.dart';
import '../../../API/credentials/login.dart';
import '../../../API/credentials/logout.dart';
import '../../../API/credentials/otp.dart';
import '../../../API/menu/account/addresses.dart';
import '../../../API/menu/account/myOrder.dart';
import '../../../API/menu/account/myOrderDetails.dart';
import '../../../API/menu/account/profile.dart';
import '../../../API/menu/account/profiledetails.dart';
import '../../../API/menu/account/wallet.dart';
import '../../../API/menu/category/addtocart.dart';
import '../../../API/menu/category/category.dart';
import '../../../API/menu/category/jewelleryDetail.dart';
import '../../../API/menu/category/recommendedJewelleryList.dart';
import '../../../API/menu/category/subcategrory/filtercategory.dart';
import '../../../API/menu/category/subcategrory/jewelleryfilter.dart';
import '../../../API/menu/category/subcategrory/subCategrory.dart';
import '../../../API/menu/category/wishlist.dart';
import '../../../API/menu/home/Search.dart';
import '../../../API/menu/home/categories.dart';
import '../../../API/menu/home/drawar/customJewellery/clarity.dart';
import '../../../API/menu/home/drawar/customJewellery/customorder.dart';
import '../../../API/menu/home/drawar/customJewellery/submit_custom_jewelley.dart';
import '../../../API/menu/home/homecollction.dart';
import '../../../API/menu/home/homejewelry.dart';
import '../../../API/menu/home/news_list.dart';
import '../../../API/menu/home/offer_banner.dart';
import '../../../API/menu/home/slider.dart';
import '../../../API/menu/myCart/countcart.dart';
import '../../../API/menu/myCart/deletcart.dart';
import '../../../API/menu/myCart/fetchcart.dart';
import '../../../API/menu/myCart/process-payment.dart';
import '../../../API/menu/myCart/withoutlogin.dart';
import '../../../API/menu/others/count.dart';
import '../../../API/menu/others/drawer/Jewellery_list.dart';
import '../../../API/menu/others/drawer/collection.dart';
import '../../../API/menu/overstore/citylist.dart';
import '../../../API/menu/overstore/overStore.dart';
import '../../../API/menu/overstore/overstoredetails.dart';
import '../../../service/menu/home/homedashbord.dart';

// UI Controllers
import '../account/account.dart';
import '../account/orderhistory.dart';
import 'menuwidget/homedashbord.dart';
import '../myCart/myCart.dart';
import '../myCart/wishlist/wishlist.dart';
import '../overStore/store_locations_controller.dart';

class HomeController extends GetxController {
  final RxBool _isActive = true.obs;
  final RxBool _isLoading = false.obs;
  final _apiCallTracker = <String, bool>{}.obs;

  // ==========================================
  // REACTIVE STATE DATA (Direct Observables)
  // ==========================================
  var dashboardData = <String, dynamic>{}.obs;
  var categoriesData = <String, dynamic>{}.obs;
  var sliderData = <String, dynamic>{}.obs;
  var offerBannerData = <String, dynamic>{}.obs;
  var newsListData = <String, dynamic>{}.obs;
  var homeJewelryData = <String, dynamic>{}.obs;
  var homeCollectionData = <String, dynamic>{}.obs;
  var searchData = <String, dynamic>{}.obs;
  var storeLocationsData = <String, dynamic>{}.obs;
  var cartData = <String, dynamic>{}.obs;
  var wishlistData = <String, dynamic>{}.obs;
  var profileData = <String, dynamic>{}.obs;
  var addressesData = <String, dynamic>{}.obs;
  var ordersData = <String, dynamic>{}.obs;
  var walletData = <String, dynamic>{}.obs;

  // ==========================================
  // CHILD CONTROLLERS
  // ==========================================
  // HomeScreen APIs Calling
  late final CategoriesCalling categories;
  late final SliderCalling slider;
  late final Homecollction homecollction;
  late final Homejewelry homejewelry;
  late final OfferBannerCalling offerBanner;
  late final NewsListCalling newsList;
  late final SearchProduct searchProduct;
  late final Homedashbord homedashbord;
  late final HomepageJewelryList homepageJewelryList;
  late final StoreLocationsController storeLocations;

  // Wishlist
  late final WishlistController wish;

  // Account Screen
  late final ProfiledetailsController profileDetails;
  late final AccountController account;
  late final OrderhistoryControll order;
  late final Myorderdetails myorderdetails;
  late final ProfileEdit profileEdit;
  late final Fechaddresses fech;
  late final EditFechaddresses editFechaddresses;
  late final Addaddresses addaddresses;
  late final SetDeflutAddress setDeflutAddress;
  late final DeletAddress deletAddress;
  late final WalletController wallet;

  // Cart & Checkout
  late final MyCartValueChange myCart;
  late final FetchcartCalling fetchcartCalling;
  late final CountCart countCart;
  late final Deletcart deletcart;
  late final Processpayment processpayment;
  late final Withoutlogin withoutlogin;
  late final WithoutloginWishList withoutloginWishList;

  // Count API Call
  late final CountController count;

  // Drawer Menu APIs Calling
  late final Jewelleryfilter jewellery;
  late final JewelleryFilterCategory category;
  late final JewelleryList jewelleryfilter;
  late final CategoryCalling categoryCalling;

  // Products
  late final JewellerydetailCall jewellerydetailCall;
  late final Recommendedjewellerylist recommendedjewellerylist;
  late final Addtocart addtocart;

  // Custom Jewellery Api
  late final Customorder customorder;
  late final Clarity clarity;
  late final SubmitCustomJewelley submitCustomJewelley;

  // OverStore
  late final Overstore_Controller store;
  late final Citylist citylist;
  late final OverStoreDetails overStoreDetails;

  // Collection
  late final Collection collection;
  late final Subcategrory subcategrory;

  // UI States
  RxInt activeIndex = 0.obs;
  final pagecontroller = CarouselSliderController();
  final pageController = CarouselController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var kohiraDiamonds = false.obs;
  var dreemJewwlry = false.obs;

  bool _controllersInitialized = false;

  HomeController() {
    _initializeControllers();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    if (_controllersInitialized) return;
    _controllersInitialized = true;

    categories = Get.isRegistered<CategoriesCalling>()
        ? Get.find<CategoriesCalling>()
        : Get.put(CategoriesCalling());
    slider = Get.isRegistered<SliderCalling>()
        ? Get.find<SliderCalling>()
        : Get.put(SliderCalling());
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

    wish = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());

    profileDetails = Get.isRegistered<ProfiledetailsController>()
        ? Get.find<ProfiledetailsController>()
        : Get.put(ProfiledetailsController());
    account = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>()
        : Get.put(AccountController());
    order = Get.isRegistered<OrderhistoryControll>()
        ? Get.find<OrderhistoryControll>()
        : Get.put(OrderhistoryControll());
    myorderdetails = Get.isRegistered<Myorderdetails>()
        ? Get.find<Myorderdetails>()
        : Get.put(Myorderdetails());
    profileEdit = Get.isRegistered<ProfileEdit>()
        ? Get.find<ProfileEdit>()
        : Get.put(ProfileEdit());
    fech = Get.isRegistered<Fechaddresses>()
        ? Get.find<Fechaddresses>()
        : Get.put(Fechaddresses());
    editFechaddresses = Get.isRegistered<EditFechaddresses>()
        ? Get.find<EditFechaddresses>()
        : Get.put(EditFechaddresses());
    addaddresses = Get.isRegistered<Addaddresses>()
        ? Get.find<Addaddresses>()
        : Get.put(Addaddresses());
    setDeflutAddress = Get.isRegistered<SetDeflutAddress>()
        ? Get.find<SetDeflutAddress>()
        : Get.put(SetDeflutAddress());
    deletAddress = Get.isRegistered<DeletAddress>()
        ? Get.find<DeletAddress>()
        : Get.put(DeletAddress());
    wallet = Get.isRegistered<WalletController>()
        ? Get.find<WalletController>()
        : Get.put(WalletController());

    myCart = Get.isRegistered<MyCartValueChange>()
        ? Get.find<MyCartValueChange>()
        : Get.put(MyCartValueChange());
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

    jewellery = Get.isRegistered<Jewelleryfilter>()
        ? Get.find<Jewelleryfilter>()
        : Get.put(Jewelleryfilter());
    category = Get.isRegistered<JewelleryFilterCategory>()
        ? Get.find<JewelleryFilterCategory>()
        : Get.put(JewelleryFilterCategory());
    jewelleryfilter = Get.isRegistered<JewelleryList>()
        ? Get.find<JewelleryList>()
        : Get.put(JewelleryList());
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

    customorder = Get.isRegistered<Customorder>()
        ? Get.find<Customorder>()
        : Get.put(Customorder());
    clarity =
        Get.isRegistered<Clarity>() ? Get.find<Clarity>() : Get.put(Clarity());
    submitCustomJewelley = Get.isRegistered<SubmitCustomJewelley>()
        ? Get.find<SubmitCustomJewelley>()
        : Get.put(SubmitCustomJewelley());

    store = Get.isRegistered<Overstore_Controller>()
        ? Get.find<Overstore_Controller>()
        : Get.put(Overstore_Controller());
    citylist = Get.isRegistered<Citylist>()
        ? Get.find<Citylist>()
        : Get.put(Citylist());
    overStoreDetails = Get.isRegistered<OverStoreDetails>()
        ? Get.find<OverStoreDetails>()
        : Get.put(OverStoreDetails());

    collection = Get.isRegistered<Collection>()
        ? Get.find<Collection>()
        : Get.put(Collection());
    subcategrory = Get.isRegistered<Subcategrory>()
        ? Get.find<Subcategrory>()
        : Get.put(Subcategrory());
  }

  void _loadInitialData() {
    if (!_isLoading.value) {
      _isLoading.value = true;

      // 1. Home Page APIs call
      callApiHOME();

      // 2. Cart & Wishlist APIs call
      callApiCART();

      // Baaki pages ke APIs ko thoda delay se call karte hain taaki network congestion na ho
      Future.delayed(const Duration(milliseconds: 100), () {
        // 3. Category Page APIs call
        callApiCATEGORY();

        // 4. OverStore Page APIs call
        callApiOVERSTORE();

        // 5. Account Page APIs call
        callApiACCOUNT();

        _isLoading.value = false;
      });
    }
  }

  // =========================================================================
  // 5 PAGES KE SEPARATE API CALL METHODS
  // =========================================================================

  /// 1. HOME PAGE APIs: Isme Home page ke sabhi APIs call hote hain
  void callApiHOME({bool forceRefresh = false}) {
    if (forceRefresh) {
      _clearApiTrackers([
        'homedashbord',
        'slider',
        'categories',
        'homejewelry',
        'homepageJewelryList',
        'offerBanner',
        'newsList',
        'storeLocations',
        'homecollction_2',
        'homecollction_3',
        'homecollction_4',
      ]);
    }

    _callApiIfNeeded('homedashbord', () => homedashbord.homedashbord());
    _callApiIfNeeded('slider', () => slider.slideruser());
    _callApiIfNeeded('categories', () => categories.categoriesuser());
    _callApiIfNeeded('homejewelry', () => homejewelry.getHomejewelry());
    _callApiIfNeeded(
        'homepageJewelryList', () => homepageJewelryList.homeJewelryList());
    _callApiIfNeeded('offerBanner', () => offerBanner.getOfferBanners());
    _callApiIfNeeded('newsList', () => newsList.getNewsList());
    _callApiIfNeeded(
        'storeLocations', () => storeLocations.fetchStoreLocations());

    // Home collections section-wise delay ke sath
    _loadHomeCollectionsWithDelay();
  }

  /// Alias for callApiHOME
  void callApiHome({bool forceRefresh = false}) =>
      callApiHOME(forceRefresh: forceRefresh);

  /// 2. CATEGORY PAGE APIs: Isme Category aur Products se related sabhi APIs call hote hain
  void callApiCATEGORY({bool forceRefresh = false}) {
    if (forceRefresh) {
      _clearApiTrackers([
        'jewellery_filter',
        'filter_category',
        'jewellery_list',
        'collection',
        'subcategory',
        'custom_order',
        'clarity',
      ]);
    }

    _callApiIfNeeded(
        'jewellery_filter', () => jewellery.fetchJewelleryFilter());
    _callApiIfNeeded('filter_category', () => category.fetchFilter());
    _callApiIfNeeded('jewellery_list', () => jewelleryfilter.jewellerylist());
    _callApiIfNeeded('collection', () => collection.collectiondata());
    _callApiIfNeeded('subcategory', () => subcategrory.subcategroryuser());
    _callApiIfNeeded('custom_order', () => customorder.fetchCustomorder());
    _callApiIfNeeded('clarity', () => clarity.clarity());
  }

  /// Alias for callApiCATEGORY
  void callApiCategory({bool forceRefresh = false}) =>
      callApiCATEGORY(forceRefresh: forceRefresh);

  /// 3. CART & WISHLIST PAGE APIs: Isme MyCart aur Wishlist se related sabhi APIs call hote hain
  void callApiCART({bool forceRefresh = false}) {
    if (forceRefresh) {
      _clearApiTrackers(['count', 'wishlist', 'cart']);
    }

    _callApiIfNeeded('count', () => count.counting());
    _callApiIfNeeded('wishlist', () => wish.fetchwishlist.fechwishlist());
    _callApiIfNeeded('cart', () => myCart.loadCartData());
  }

  /// Alias for callApiCART
  void callApiCart({bool forceRefresh = false}) =>
      callApiCART(forceRefresh: forceRefresh);

  /// 4. OVER STORE PAGE APIs: Isme OverStore aur Store Locations ke sabhi APIs call hote hain
  void callApiOVERSTORE({bool forceRefresh = false}) {
    if (forceRefresh) {
      _clearApiTrackers(['city_list', 'over_store', 'storeLocations']);
    }

    _callApiIfNeeded('city_list', () => citylist.citylist());
    _callApiIfNeeded('over_store', () => store.overStore());
    _callApiIfNeeded(
        'storeLocations', () => storeLocations.fetchStoreLocations());
  }

  /// Alias for callApiOVERSTORE
  void callApiOverStore({bool forceRefresh = false}) =>
      callApiOVERSTORE(forceRefresh: forceRefresh);

  /// 5. ACCOUNT PAGE APIs: Isme User Profile, Orders, Addresses aur Wallet ke sabhi APIs call hote hain
  void callApiACCOUNT({bool forceRefresh = false}) {
    if (forceRefresh) {
      _clearApiTrackers(['profile', 'wallet', 'addresses', 'orderHistory']);
    }

    _callApiIfNeeded('profile', () => profileDetails.profiledetailscall());
    _callApiIfNeeded('wallet', () => wallet.wallet());
    _callApiIfNeeded('addresses', () => fech.fechaddresses());
    _callApiIfNeeded('orderHistory', () => order.order.myOrder());
  }

  /// Alias for callApiACCOUNT
  void callApiAccount({bool forceRefresh = false}) =>
      callApiACCOUNT(forceRefresh: forceRefresh);

  void _loadHomeCollectionsWithDelay() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _callApiIfNeeded('homecollction_2',
          () => homecollction.homecollction(section_no: '2'));
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _callApiIfNeeded('homecollction_3',
          () => homecollction.homecollction(section_no: '3'));
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _callApiIfNeeded('homecollction_4',
          () => homecollction.homecollction(section_no: '4'));
    });
  }

  void _clearApiTrackers(List<String> keys) {
    for (final key in keys) {
      _apiCallTracker.remove(key);
    }
  }

  void _callApiIfNeeded(String apiKey, Function apiCall) {
    if (!_isActive.value || _apiCallTracker[apiKey] == true) return;

    _apiCallTracker[apiKey] = true;
    apiCall();
  }

  // =========================================================================
  // GENERIC HTTP METHODS (GET, POST, PUT, DELETE)
  // =========================================================================

  /// Generic GET API request
  Future<dynamic> getApi(String url,
      {Map<String, dynamic>? queryParameters, bool useAuth = true}) async {
    try {
      final response = await ApiCall.getRequest(url,
          queryParameters: queryParameters, useAuth: useAuth);
      return response;
    } catch (e) {
      log('HomeController GET Error [$url]: $e');
      rethrow;
    }
  }

  /// Generic POST API request
  Future<dynamic> postApi(String url,
      {dynamic data, bool useAuth = true}) async {
    try {
      final response =
          await ApiCall.postRequest(url, data: data, useAuth: useAuth);
      return response;
    } catch (e) {
      log('HomeController POST Error [$url]: $e');
      rethrow;
    }
  }

  /// Generic PUT API request
  Future<dynamic> putApi(String url,
      {dynamic data, bool useAuth = true}) async {
    try {
      final response =
          await ApiCall.putRequest(url, data: data, useAuth: useAuth);
      return response;
    } catch (e) {
      log('HomeController PUT Error [$url]: $e');
      rethrow;
    }
  }

  /// Generic DELETE API request
  Future<dynamic> deleteApi(String url,
      {dynamic data, bool useAuth = true}) async {
    try {
      final response =
          await ApiCall.deleteRequest(url, data: data, useAuth: useAuth);
      return response;
    } catch (e) {
      log('HomeController DELETE Error [$url]: $e');
      rethrow;
    }
  }

  // =========================================================================
  // GET APIS
  // =========================================================================

  /// GET: Home Dashboard Data
  Future<dynamic> getHomeDashboard() async {
    try {
      final response = await ApiCall.fetchDashboardData();
      if (response != null) {
        dashboardData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getHomeDashboard Error: $e');
      return null;
    }
  }

  /// GET: Categories
  Future<dynamic> getCategories() async {
    try {
      final response = await ApiCall.fetchCategoryData();
      if (response != null) {
        categoriesData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getCategories Error: $e');
      return null;
    }
  }

  /// GET: Sliders
  Future<dynamic> getSlider() async {
    try {
      final response = await ApiCall.fetchSliderData();
      if (response != null) {
        sliderData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getSlider Error: $e');
      return null;
    }
  }

  /// GET: Offer Banners
  Future<dynamic> getOfferBanners() async {
    try {
      final response = await ApiCall.fetchBannerData();
      if (response != null) {
        offerBannerData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getOfferBanners Error: $e');
      return null;
    }
  }

  /// GET: News List
  Future<dynamic> getNewsList() async {
    try {
      final response = await ApiCall.fetchNewsListData();
      if (response != null) {
        newsListData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getNewsList Error: $e');
      return null;
    }
  }

  /// GET: Home Jewelry
  Future<dynamic> getHomeJewelry() async {
    try {
      final response = await ApiCall.fetchHomeJewelryData();
      if (response != null) {
        homeJewelryData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getHomeJewelry Error: $e');
      return null;
    }
  }

  /// GET: Homepage Jewelry List
  Future<dynamic> getHomepageJewelryList() async {
    try {
      final response =
          await ApiCall.getRequest(AppUrl.homepage_JewelryList, useAuth: false);
      return response;
    } catch (e) {
      print('HomeController getHomepageJewelryList Error: $e');
      return null;
    }
  }

  /// GET: Store Locations
  Future<dynamic> getStoreLocations() async {
    try {
      final response = await ApiCall.fetchStoreLocationsData();
      if (response != null) {
        storeLocationsData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getStoreLocations Error: $e');
      return null;
    }
  }

  /// GET: Search Products
  Future<dynamic> searchProductApi(String query) async {
    try {
      final response = await ApiCall.searchApi(query);
      if (response != null) {
        searchData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController searchProductApi Error: $e');
      return null;
    }
  }

  /// GET: Clarity
  Future<dynamic> getClarity() async {
    try {
      return await ApiCall.getRequest(AppUrl.clarity, useAuth: false);
    } catch (e) {
      print('HomeController getClarity Error: $e');
      return null;
    }
  }

  /// GET: Custom Order Categories
  Future<dynamic> getCustomOrder() async {
    try {
      return await ApiCall.getRequest(AppUrl.customorder, useAuth: false);
    } catch (e) {
      print('HomeController getCustomOrder Error: $e');
      return null;
    }
  }

  /// GET: Drawer Collections
  Future<dynamic> getCollections() async {
    try {
      return await ApiCall.getRequest(AppUrl.collection, useAuth: false);
    } catch (e) {
      print('HomeController getCollections Error: $e');
      return null;
    }
  }

  /// GET: Jewellery Filter
  Future<dynamic> getJewelleryFilter() async {
    try {
      return await ApiCall.getRequest(AppUrl.jewellery_filter, useAuth: false);
    } catch (e) {
      print('HomeController getJewelleryFilter Error: $e');
      return null;
    }
  }

  /// GET: Filter Category
  Future<dynamic> getFilterCategory() async {
    try {
      return await ApiCall.fetchFilterCategory();
    } catch (e) {
      print('HomeController getFilterCategory Error: $e');
      return null;
    }
  }

  /// GET: Jewellery Detail by Slug
  Future<dynamic> getJewelleryDetail(String slug) async {
    try {
      return await ApiCall.fetchJewelleryDetail(slug);
    } catch (e) {
      print('HomeController getJewelleryDetail Error: $e');
      return null;
    }
  }

  /// GET: Recommended Jewellery List
  Future<dynamic> getRecommendedJewellery(String slug) async {
    try {
      return await ApiCall.fetchRecommendedJewellery(slug);
    } catch (e) {
      print('HomeController getRecommendedJewellery Error: $e');
      return null;
    }
  }

  /// GET: Cart & Wishlist Count
  Future<dynamic> getCartWishlistCount() async {
    try {
      return await ApiCall.countCartWishlist();
    } catch (e) {
      print('HomeController getCartWishlistCount Error: $e');
      return null;
    }
  }

  /// GET: Cart Data
  Future<dynamic> getCartData(
      {String? flag, String? qty, String? cart, String? type}) async {
    try {
      final response = await ApiCall.fetchCartData(
          flag: flag, qty: qty, cart: cart, type: type);
      if (response != null) {
        cartData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getCartData Error: $e');
      return null;
    }
  }

  /// GET: Wishlist Data
  Future<dynamic> getWishlistData() async {
    try {
      final response = await ApiCall.fetchWishlist();
      if (response != null) {
        wishlistData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getWishlistData Error: $e');
      return null;
    }
  }

  /// GET: Profile Data
  Future<dynamic> getProfileData() async {
    try {
      final response = await ApiCall.fetchProfileData();
      if (response != null) {
        profileData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getProfileData Error: $e');
      return null;
    }
  }

  /// GET: Profile Details
  Future<dynamic> getProfileDetails() async {
    try {
      return await ApiCall.fetchProfileDetails();
    } catch (e) {
      print('HomeController getProfileDetails Error: $e');
      return null;
    }
  }

  /// GET: Addresses
  Future<dynamic> getAddresses() async {
    try {
      final response = await ApiCall.fetchAddresses();
      if (response != null) {
        addressesData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getAddresses Error: $e');
      return null;
    }
  }

  /// GET: Address by ID
  Future<dynamic> getAddressById(String id) async {
    try {
      return await ApiCall.getRequest('${AppUrl.addressesfeach}/$id',
          useAuth: true);
    } catch (e) {
      print('HomeController getAddressById Error: $e');
      return null;
    }
  }

  /// GET: Orders List
  Future<dynamic> getOrders() async {
    try {
      final response = await ApiCall.fetchOrderList();
      if (response != null) {
        ordersData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getOrders Error: $e');
      return null;
    }
  }

  /// GET: Order Details by ID
  Future<dynamic> getOrderDetails(String id) async {
    try {
      return await ApiCall.fetchOrderDetails(id);
    } catch (e) {
      print('HomeController getOrderDetails Error: $e');
      return null;
    }
  }

  /// GET: Wallet Data
  Future<dynamic> getWallet() async {
    try {
      final response = await ApiCall.fetchWalletData();
      if (response != null) {
        walletData.assignAll(Map<String, dynamic>.from(
            response is Map ? response : jsonDecode(jsonEncode(response))));
      }
      return response;
    } catch (e) {
      print('HomeController getWallet Error: $e');
      return null;
    }
  }

  /// GET: Store City List
  Future<dynamic> getStoreCities() async {
    try {
      return await ApiCall.fetchStoreCityData();
    } catch (e) {
      print('HomeController getStoreCities Error: $e');
      return null;
    }
  }

  /// GET: Store Asset Detail by Slug
  Future<dynamic> getStoreDetails(String slug) async {
    try {
      return await ApiCall.fetchStoreDetailsData(slug);
    } catch (e) {
      print('HomeController getStoreDetails Error: $e');
      return null;
    }
  }

  /// GET: Country List
  Future<dynamic> getCountries() async {
    try {
      return await ApiCall.getRequest(AppUrl.country, useAuth: false);
    } catch (e) {
      print('HomeController getCountries Error: $e');
      return null;
    }
  }

  /// GET: State List
  Future<dynamic> getStates({String? countryId}) async {
    try {
      final url =
          countryId != null ? '${AppUrl.state}/$countryId' : AppUrl.state;
      return await ApiCall.getRequest(url, useAuth: false);
    } catch (e) {
      print('HomeController getStates Error: $e');
      return null;
    }
  }

  // =========================================================================
  // POST APIS
  // =========================================================================

  /// POST: Home Collection by Section Number
  Future<dynamic> postHomeCollection({String? sectionNo}) async {
    try {
      final body = {'section_no': sectionNo};
      final response = await ApiCall.postRequest(AppUrl.homecollcation,
          data: body, useAuth: false);
      if (response != null && sectionNo != null) {
        homeCollectionData[sectionNo] = response;
      }
      return response;
    } catch (e) {
      print('HomeController postHomeCollection Error: $e');
      return null;
    }
  }

  /// POST: Add to Cart
  Future<dynamic> postAddToCart(dynamic body) async {
    try {
      final response = await ApiCall.addToCart(body);
      return response;
    } catch (e) {
      print('HomeController postAddToCart Error: $e');
      return null;
    }
  }

  /// POST: Add to Wishlist
  Future<dynamic> postAddToWishlist(dynamic body) async {
    try {
      final response = await ApiCall.postRequest(AppUrl.wishlist,
          data: body, useAuth: false);
      return response;
    } catch (e) {
      print('HomeController postAddToWishlist Error: $e');
      return null;
    }
  }

  /// POST: Cart Without Login
  Future<dynamic> postCartWithoutLogin(dynamic body) async {
    try {
      return await ApiCall.postRequest(AppUrl.withoutlogin,
          data: body, useAuth: false);
    } catch (e) {
      print('HomeController postCartWithoutLogin Error: $e');
      return null;
    }
  }

  /// POST: Wishlist Without Login
  Future<dynamic> postWishlistWithoutLogin(dynamic body) async {
    try {
      return await ApiCall.postRequest(AppUrl.wishlistwithoutlogin,
          data: body, useAuth: false);
    } catch (e) {
      print('HomeController postWishlistWithoutLogin Error: $e');
      return null;
    }
  }

  /// POST: Submit Custom Jewelry
  Future<dynamic> postSubmitCustomJewelry(dynamic body) async {
    try {
      return await ApiCall.postRequest(AppUrl.addcustom,
          data: body, useAuth: false);
    } catch (e) {
      print('HomeController postSubmitCustomJewelry Error: $e');
      return null;
    }
  }

  /// POST: Process Payment / Make Payment
  Future<dynamic> postProcessPayment(dynamic body) async {
    try {
      return await ApiCall.postRequest(AppUrl.payment,
          data: body, useAuth: true);
    } catch (e) {
      print('HomeController postProcessPayment Error: $e');
      return null;
    }
  }

  /// POST: Add Address
  Future<dynamic> postAddAddress(dynamic body) async {
    try {
      final response = await ApiCall.postRequest(AppUrl.addressesfeach,
          data: body, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController postAddAddress Error: $e');
      return null;
    }
  }

  /// POST: Store List (filter by search and city)
  Future<dynamic> postStoreData({String? search, String? storeCityId}) async {
    try {
      return await ApiCall.fetchStoreData(
          search: search, storeCityId: storeCityId);
    } catch (e) {
      print('HomeController postStoreData Error: $e');
      return null;
    }
  }

  /// POST: User Login
  Future<dynamic> postLogin(dynamic body) async {
    try {
      return await ApiCall.login(body);
    } catch (e) {
      print('HomeController postLogin Error: $e');
      return null;
    }
  }

  /// POST: User Signup
  Future<dynamic> postSignup(dynamic body) async {
    try {
      return await ApiCall.signup(body);
    } catch (e) {
      print('HomeController postSignup Error: $e');
      return null;
    }
  }

  /// POST: Send OTP
  Future<dynamic> postSendOtp(dynamic body) async {
    try {
      return await ApiCall.sendOtp(body);
    } catch (e) {
      print('HomeController postSendOtp Error: $e');
      return null;
    }
  }

  /// POST: Verify OTP
  Future<dynamic> postVerifyOtp(dynamic body) async {
    try {
      return await ApiCall.verifyOtp(body);
    } catch (e) {
      print('HomeController postVerifyOtp Error: $e');
      return null;
    }
  }

  /// POST: User Logout
  Future<dynamic> postLogout() async {
    try {
      return await ApiCall.postRequest(AppUrl.logout, useAuth: true);
    } catch (e) {
      print('HomeController postLogout Error: $e');
      return null;
    }
  }

  /// POST: Forgot Password
  Future<dynamic> postForgotPassword(dynamic body) async {
    try {
      return await ApiCall.postRequest(AppUrl.forgetpassword,
          data: body, useAuth: false);
    } catch (e) {
      print('HomeController postForgotPassword Error: $e');
      return null;
    }
  }

  // =========================================================================
  // PUT APIS
  // =========================================================================

  /// PUT: Update Address
  Future<dynamic> putUpdateAddress(
      {required String id, required dynamic data}) async {
    try {
      final url = '${AppUrl.addressesfeach}/$id';
      final response = await ApiCall.putRequest(url, data: data, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController putUpdateAddress Error: $e');
      return null;
    }
  }

  /// PUT: Update User Profile
  Future<dynamic> putUpdateProfile(dynamic body) async {
    try {
      final response =
          await ApiCall.putRequest(AppUrl.profile, data: body, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController putUpdateProfile Error: $e');
      return null;
    }
  }

  /// PUT / GET: Set Default Address
  Future<dynamic> putSetDefaultAddress(String id) async {
    try {
      final url = '${AppUrl.setdefault}/$id';
      final response = await ApiCall.getRequest(url, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController putSetDefaultAddress Error: $e');
      return null;
    }
  }

  /// PUT: Update Cart Item Quantity
  Future<dynamic> putUpdateCartItem(dynamic body) async {
    try {
      final response =
          await ApiCall.putRequest(AppUrl.cart, data: body, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController putUpdateCartItem Error: $e');
      return null;
    }
  }

  // =========================================================================
  // DELETE APIS
  // =========================================================================

  /// DELETE / POST: Delete Cart Item
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

      // Backend route uses POST for cart-delete-particular or DELETE
      final response = await ApiCall.postRequest(AppUrl.deletcart,
          data: body, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController deleteCartItem Error: $e');
      return null;
    }
  }

  /// DELETE: Remove Item from Wishlist
  Future<dynamic> deleteWishlistItem(String id) async {
    try {
      final body = {'id': id};
      final response = await ApiCall.postRequest(AppUrl.wishlistdelete,
          data: body, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController deleteWishlistItem Error: $e');
      return null;
    }
  }

  /// DELETE: Delete Address
  Future<dynamic> deleteAddress(String id) async {
    try {
      final body = {'id': id};
      final response = await ApiCall.postRequest(AppUrl.deleteaddress,
          data: body, useAuth: true);
      return response;
    } catch (e) {
      print('HomeController deleteAddress Error: $e');
      return null;
    }
  }

  // =========================================================================
  // UTILITY METHODS & UI HELPERS
  // =========================================================================

  void someMethod() {
    if (!_isActive.value) return;
  }

  void disableController() {
    _isActive.value = false;
    _isLoading.value = false;
  }

  void enableController() {
    _isActive.value = true;
  }

  void retryFailedAPIs() {
    _apiCallTracker.clear();
    _loadInitialData();
  }

  @override
  void onClose() {
    _isActive.value = false;
    _isLoading.value = false;
    _apiCallTracker.clear();
    super.onClose();
  }

  void changeCarouselIndex(int index, dynamic reason) {
    if (!_isActive.value) return;
    activeIndex.value = index;
  }

  void toggleKohiraDiamonds() {
    if (!_isActive.value) return;
    kohiraDiamonds.value = !kohiraDiamonds.value;
  }

  void toggleDreemJewwlry() {
    if (!_isActive.value) return;
    dreemJewwlry.value = !dreemJewwlry.value;
  }

  bool get isBusy => _isLoading.value;
}
