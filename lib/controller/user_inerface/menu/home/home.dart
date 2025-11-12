// ignore_for_file: unnecessary_import, unused_import

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/customorder.dart';
import 'package:kohira/controller/API/menu/others/drawer/collection.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/modal/menu/category/subcategory/addtowish.dart';

import '../../../../modal/menu/category/subcategory/addtocart.dart';
import '../../../../view/utils/app_constants.dart';
import '../../../API/menu/account/addresses.dart';
import '../../../API/menu/account/wallet.dart';
import '../../../API/menu/category/subcategrory/filtercategory.dart';
import '../../../API/menu/category/subcategrory/jewelleryfilter.dart';
import '../../../API/menu/category/subcategrory/subCategrory.dart';
import '../../../API/menu/home/categories.dart';
import '../../../API/menu/home/drawar/customJewellery/clarity.dart';
import '../../../API/menu/home/homecollction.dart';
import '../../../API/menu/home/homejewelry.dart';
import '../../../API/menu/home/slider.dart';
import '../../../API/menu/myCart/fetchcart.dart';
import '../../../API/menu/myCart/withoutlogin.dart';
import '../../../API/menu/others/count.dart';
import '../../../API/menu/others/drawer/Jewellery_list.dart';
import '../../../API/menu/overstore/citylist.dart';
import '../../../API/menu/overstore/overStore.dart';
import '../../../database/local/localstore.dart';
import '../account/account.dart';
import '../account/orderhistory.dart';
import '../myCart/wishlist/wishlist.dart';

// class HomeController extends GetxController {
//   final RxBool _isActive = true.obs;
//
//   // Add condition to all methods
//   void someMethod() {
//     if (!_isActive.value) return;
//     // Your method logic here
//   }
//
//   void disableController() {
//     _isActive.value = false;
//   }
//
//   void enableController() {
//     _isActive.value = true;
//   }
//
//   //HomeScreen APIs Calling
//   final categories = Get.put(CategoriesCalling());
//   final slider = Get.put(SliderCalling());
//   final homecollction = Get.put(Homecollction());
//   final homejewelry = Get.put(Homejewelry());
//
//   //Wishlist
//   final wish = Get.put(WishlistController());
//
//   //Account Scrren
//   final profileDetails = Get.put(ProfiledetailsController());
//   final account = Get.put(AccountController());
//   final order = Get.put(OrderhistoryControll());
//   final fech = Get.put(Fechaddresses());
//   final wallet = Get.put(WalletController());
//
//   //Cart
//   final myCart = Get.put(MyCartValueChange());
//
//   //count API Call
//   final count = Get.put(CountController());
//
//   //Drawer Menu APIs Calling
//   final jewellery = Get.put(Jewelleryfilter());
//   final category = Get.put(JewelleryFilterCategory());
//   final jewelleryfilter = Get.put(JewelleryList());
//
//     //Custom Jewellery Api
//       final customorder = Get.put(Customorder());
//       final clarity = Get.put(Clarity());
//
//   //OverStore
//   final store =  Get.put(Overstore_Controller());
//   final citylist =  Get.put(Citylist());
//
//   //Collection
//   final collection = Get.put(Collection());
//   final subcategrory = Get.put(Subcategrory());
//
//   // //setDefalt
//   // final setDeflut = Get.put(SetDeflutAddress());
//
//   RxInt activeIndex = 0.obs;
//
//   final pagecontroller = CarouselSliderController();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     //HomeScreen APIs Calling
//     slider.slideruser();
//     categories.categoriesuser();
//     homejewelry.getHomejewelry();
//
//     //Drawer Menu APIs Call
//     jewellery.fetchJewelleryFilter();
//     category.fetchFilter();
//     jewelleryfilter.jewellerylist();
//     count.counting();
//
//      //Custom Jewellery Api
//        customorder.fetchCustomorder();
//        clarity.clarity();
//
//     //Wishlist
//     wish.onInit();
//     wish.fetchwishlist.fechwishlist();
//
//     //OverStore Screen
//     citylist.citylist();
//     store.overStore();
//
//     //Account Scrren
//     profileDetails.profiledetailscall();
//     account.onInit();
//     account.profileDetails.profiledetailscall();
//     order.onInit();
//     order.order.myOrder();
//     wallet.wallet();
//     fech.fechaddresses();
//
//     //Cart
//     myCart.loadCartData();
//
//     //Collection
//     collection.collectiondata();
//     subcategrory.subcategroryuser();
//
//     homecollction.homecollction(section_no: '2');
//     homecollction.homecollction(section_no: '3');
//     homecollction.homecollction(section_no: '4');
//   }
//
//   @override
//   void dispose() {
//      //HomeScreen APIs Calling
//     slider.slideruser();
//     categories.categoriesuser();
//
//     //Drawer Menu APIs Call
//     jewellery.fetchJewelleryFilter();
//     category.fetchFilter();
//     count.counting();
//
//     //Wishlist
//     wish.onInit();
//     wish.fetchwishlist.fechwishlist();
//
//     //OverStore Screen
//     citylist.citylist();
//     store.overStore();
//
//     //Account Scrren
//     profileDetails.profiledetailscall();
//     account.onInit();
//     account.profileDetails.profiledetailscall();
//     order.onInit();
//     order.order.myOrder();
//     wallet.wallet();
//     fech.fechaddresses();
//
//
//     homecollction.homecollction(section_no: '2');
//     homecollction.homecollction(section_no: '3');
//     homecollction.homecollction(section_no: '4');
//     super.dispose();
//   }
//
//   @override
//   void onClose() {
//     _isActive.value = false;
//     super.onClose();
//   }
//
//
//   var kohiraDiamonds = false.obs;
//   var dreemJewwlry = false.obs;
//
//   final pageController = CarouselController();
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   void changeCarouselIndex(int index, dynamic reason) {
//    activeIndex.value = index;
//   }
//
//   void toggleKohiraDiamonds() {
//     kohiraDiamonds.value = !kohiraDiamonds.value;
//   }
//
//   void toggleDreemJewwlry() {
//     dreemJewwlry.value = !dreemJewwlry.value;
//   }
// }

class HomeController extends GetxController {
  final RxBool _isActive = true.obs;
  final RxBool _isLoading = false.obs;
  final _apiCallTracker = <String, bool>{}.obs;

  // HomeScreen APIs Calling
  late final CategoriesCalling categories;
  late final SliderCalling slider;
  late final Homecollction homecollction;
  late final Homejewelry homejewelry;

  // Wishlist
  late final WishlistController wish;

  // Account Screen
  late final ProfiledetailsController profileDetails;
  late final AccountController account;
  late final OrderhistoryControll order;
  late final Fechaddresses fech;
  late final WalletController wallet;

  // Cart
  late final MyCartValueChange myCart;

  // count API Call
  late final CountController count;

  // Drawer Menu APIs Calling
  late final Jewelleryfilter jewellery;
  late final JewelleryFilterCategory category;
  late final JewelleryList jewelleryfilter;

  // Custom Jewellery Api
  late final Customorder customorder;
  late final Clarity clarity;

  // OverStore
  late final Overstore_Controller store;
  late final Citylist citylist;

  // Collection
  late final Collection collection;
  late final Subcategrory subcategrory;

  RxInt activeIndex = 0.obs;

  final pagecontroller = CarouselSliderController();
  final pageController = CarouselController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var kohiraDiamonds = false.obs;
  var dreemJewwlry = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    categories = Get.put(CategoriesCalling());
    slider = Get.put(SliderCalling());
    homecollction = Get.put(Homecollction());
    homejewelry = Get.put(Homejewelry());

    wish = Get.put(WishlistController());

    profileDetails = Get.put(ProfiledetailsController());
    account = Get.put(AccountController());
    order = Get.put(OrderhistoryControll());
    fech = Get.put(Fechaddresses());
    wallet = Get.put(WalletController());

    myCart = Get.put(MyCartValueChange());
    count = Get.put(CountController());

    jewellery = Get.put(Jewelleryfilter());
    category = Get.put(JewelleryFilterCategory());
    jewelleryfilter = Get.put(JewelleryList());

    customorder = Get.put(Customorder());
    clarity = Get.put(Clarity());

    store = Get.put(Overstore_Controller());
    citylist = Get.put(Citylist());

    collection = Get.put(Collection());
    subcategrory = Get.put(Subcategrory());
  }

  void _loadInitialData() {
    if (!_isLoading.value) {
      _isLoading.value = true;

      // HomeScreen APIs - Call only essential ones initially
      _callApiIfNeeded('slider', () => slider.slideruser());
      _callApiIfNeeded('categories', () => categories.categoriesuser());
      _callApiIfNeeded('homejewelry', () => homejewelry.getHomejewelry());

      // Essential user data
      _callApiIfNeeded('count', () => count.counting());
      _callApiIfNeeded('wishlist', () => wish.fetchwishlist.fechwishlist());
      _callApiIfNeeded('cart', () => myCart.loadCartData());

      // Load other data with delay to prevent overwhelming the network
      Future.delayed(const Duration(milliseconds: 100), () {
        _loadSecondaryData();
      });
    }
  }

  void _loadSecondaryData() {
    // Drawer Menu APIs
    _callApiIfNeeded('jewellery_filter', () => jewellery.fetchJewelleryFilter());
    _callApiIfNeeded('filter_category', () => category.fetchFilter());
    _callApiIfNeeded('jewellery_list', () => jewelleryfilter.jewellerylist());

    // Custom Jewellery
    _callApiIfNeeded('custom_order', () => customorder.fetchCustomorder());
    _callApiIfNeeded('clarity', () => clarity.clarity());

    // OverStore
    _callApiIfNeeded('city_list', () => citylist.citylist());
    _callApiIfNeeded('over_store', () => store.overStore());

    // Account Screen - Load only if user is logged in
    _callApiIfNeeded('profile', () => profileDetails.profiledetailscall());
    _callApiIfNeeded('wallet', () => wallet.wallet());
    _callApiIfNeeded('addresses', () => fech.fechaddresses());

    // Collection
    _callApiIfNeeded('collection', () => collection.collectiondata());
    _callApiIfNeeded('subcategory', () => subcategrory.subcategroryuser());

    // Home collections with delay between calls
    _loadHomeCollectionsWithDelay();

    _isLoading.value = false;
  }

  void _loadHomeCollectionsWithDelay() {
    // Stagger the home collection calls to prevent network congestion
    Future.delayed(const Duration(milliseconds: 100), () {
      _callApiIfNeeded('homecollction_2', () => homecollction.homecollction(section_no: '2'));
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _callApiIfNeeded('homecollction_3', () => homecollction.homecollction(section_no: '3'));
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _callApiIfNeeded('homecollction_4', () => homecollction.homecollction(section_no: '4'));
    });
  }

  void _callApiIfNeeded(String apiKey, Function apiCall) {
    if (!_isActive.value || _apiCallTracker[apiKey] == true) return;

    _apiCallTracker[apiKey] = true;
    apiCall();
  }

  // Add condition to all methods
  void someMethod() {
    if (!_isActive.value) return;
    // Your method logic here
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

  // Utility method to check if controller is busy
  bool get isBusy => _isLoading.value;
}
