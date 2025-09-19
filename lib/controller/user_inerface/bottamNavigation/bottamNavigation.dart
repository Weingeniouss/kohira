
// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/screen/menu/account/account.dart';
import 'package:kohira/view/screen/menu/home/home.dart';
import 'package:kohira/view/screen/menu/myCart/buynow.dart';
import '../../../view/screen/menu/category/Category.dart';
import '../../../view/screen/menu/over Store/overStore.dart';

class Bottamnavigation extends GetxController {
  //index the Swich Screen

  RxInt selectindex = 0.obs;

  //Add Screen
  List<Widget> scrren = [
    Home(),
    Categorys(),
    Buynow(),
    Overstore(),
    Account(),
  ];

  void indexOne() => selectindex.value = 0;
  void indexTwo() => selectindex.value = 1;
  void indexThree() => selectindex.value = 2;
  void indexFour() => selectindex.value = 3;
  void indexFive() => selectindex.value = 4;

  //Swich Screen
  Widget selectscreen(int index) {
    switch (index) {
      case 0: return Home();
      case 1: return Categorys();
      case 2: return Buynow();
      case 3: return Overstore();
      case 4: return Account();
      default: return Home();
    }
  }
}