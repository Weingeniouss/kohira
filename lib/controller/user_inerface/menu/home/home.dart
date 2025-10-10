// ignore_for_file: unnecessary_import, unused_import

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart';
import 'package:kohira/controller/API/menu/home/drawar/customJewellery/customorder.dart';
import 'package:kohira/controller/API/menu/others/drawer/collection.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';

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
import '../../../API/menu/others/count.dart';
import '../../../API/menu/others/drawer/Jewellery_list.dart';
import '../../../API/menu/overstore/citylist.dart';
import '../../../API/menu/overstore/overStore.dart';
import '../account/account.dart';
import '../account/orderhistory.dart';
import '../myCart/wishlist/wishlist.dart';

class HomeController extends GetxController {
  //HomeScreen APIs Calling
  final categories = Get.put(CategoriesCalling());
  final slider = Get.put(SliderCalling());
  final homecollction = Get.put(Homecollction());
  final homejewelry = Get.put(Homejewelry());

  //Wishlist
  final WishlistController wish = Get.put(WishlistController());

  //Account Scrren
  final profileDetails = Get.put(ProfiledetailsController());
  final account = Get.put(AccountController());
  final order = Get.put(OrderhistoryControll());
  final fech = Get.put(Fechaddresses());
  final wallet = Get.put(WalletController());

  //Cart
  final myCart = Get.put(MyCartValueChange());

  //count API Call
  final count = Get.put(CountController());

  //Drawer Menu APIs Calling
  final jewellery = Get.put(Jewelleryfilter());
  final category = Get.put(JewelleryFilterCategory());
  final jewelleryfilter = Get.put(JewelleryList());

    //Custom Jewellery Api
      final customorder = Get.put(Customorder());
      final clarity = Get.put(Clarity());

  //OverStore
  final store =  Get.put(Overstore_Controller());
  final citylist =  Get.put(Citylist());

  //Collection
  final collection = Get.put(Collection());
  final subcategrory = Get.put(Subcategrory());

  // //setDefalt
  // final setDeflut = Get.put(SetDeflutAddress());

  RxInt activeIndex = 0.obs;

  final pagecontroller = CarouselSliderController();

  @override
  void onInit() {
    super.onInit();

    //HomeScreen APIs Calling
    slider.slideruser();
    categories.categoriesuser();
    homejewelry.getHomejewelry();

    //Drawer Menu APIs Call
    jewellery.fetchJewelleryFilter();
    category.fetchFilter();
    jewelleryfilter.jewellerylist();
    count.counting();

     //Custom Jewellery Api
       customorder.fetchCustomorder();
       clarity.clarity();

    //Wishlist
    wish.onInit();
    wish.fetchwishlist.fechwishlist();

    //OverStore Screen
    citylist.citylist();
    store.overStore();

    //Account Scrren
    profileDetails.profiledetailscall();
    account.onInit();
    account.profileDetails.profiledetailscall();
    order.onInit();
    order.order.myOrder();
    wallet.wallet();
    fech.fechaddresses();

    //Cart
    myCart.loadCartData();

    //Collection
    collection.collectiondata();
    subcategrory.subcategroryuser();

    homecollction.homecollction(section_no: '2');
    homecollction.homecollction(section_no: '3');
    homecollction.homecollction(section_no: '4');
  }

  @override
  void dispose() {
     //HomeScreen APIs Calling
    slider.slideruser();
    categories.categoriesuser();

    //Drawer Menu APIs Call
    jewellery.fetchJewelleryFilter();
    category.fetchFilter();
    count.counting();

    //Wishlist
    wish.onInit();
    wish.fetchwishlist.fechwishlist();

    //OverStore Screen
    citylist.citylist();
    store.overStore();

    //Account Scrren
    profileDetails.profiledetailscall();
    account.onInit();
    account.profileDetails.profiledetailscall();
    order.onInit();
    order.order.myOrder();
    wallet.wallet();
    fech.fechaddresses();


    homecollction.homecollction(section_no: '2');
    homecollction.homecollction(section_no: '3');
    homecollction.homecollction(section_no: '4');
    super.dispose();
  }


  var kohiraDiamonds = false.obs;
  var dreemJewwlry = false.obs;

  final pageController = CarouselController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void changeCarouselIndex(int index, dynamic reason) {
   activeIndex.value = index;
  }

  void toggleKohiraDiamonds() {
    kohiraDiamonds.value = !kohiraDiamonds.value;
  }

  void toggleDreemJewwlry() {
    dreemJewwlry.value = !dreemJewwlry.value;
  }
}
