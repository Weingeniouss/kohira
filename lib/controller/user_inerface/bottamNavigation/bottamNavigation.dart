// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/menu/account/account.dart';
import 'package:kohira/view/screen/menu/home/home.dart';
import 'package:kohira/view/screen/menu/myCart/myCart.dart';
import 'package:kohira/view/utils/app_constants.dart';
import '../../../view/screen/menu/category/Category.dart';
import '../../../view/screen/menu/over Store/overStore.dart';

class Bottamnavigation extends GetxController {
  // index the Switch Screen
  RxInt selectindex = 0.obs;

  // Add Screen
  late final List<Widget> scrren = [
    Home(),
    Categorys(),
    Mycart(),
    Overstore(),
    Account(),
  ];

  void indexOne() => selectindex.value = 0;
  void indexTwo() => selectindex.value = 1;
  void indexThree() {
    selectindex.value = 2;
    final myCart = Get.isRegistered<MyCartValueChange>()
        ? Get.find<MyCartValueChange>()
        : Get.put(MyCartValueChange());
    myCart.loadCartData();
  }
  void indexFour() => selectindex.value = 3;
  void indexFive() {
    if (islogin && tokans.isNotEmpty) {
      selectindex.value = 4;
    }
  }

  // Switch Screen
  Widget selectscreen(int index) {
    if (index >= 0 && index < scrren.length) {
      return scrren[index];
    }
    return scrren[0];
  }
}
