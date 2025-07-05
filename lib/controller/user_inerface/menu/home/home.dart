// ignore_for_file: unnecessary_import

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../API/menu/home/categories.dart';
import '../../../API/menu/home/homecollction.dart';
import '../../../API/menu/home/slider.dart';

class HomeController extends GetxController {
  final categories = Get.put(CategoriesCalling());
  final slider = Get.put(SliderCalling());
  final homecollction = Get.put(Homecollction());
  RxInt activeIndex = 0.obs;

  final pagecontroller = CarouselSliderController();

  @override
  void onInit() {
    super.onInit();
    slider.slideruser();
    categories.categoriesuser();
    homecollction.homecollction(section_no: '2');
    homecollction.homecollction(section_no: '3');
    homecollction.homecollction(section_no: '4');
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
