
// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/screen/menu/account/account.dart';
import 'package:kohira/view/screen/menu/home/home.dart';
import 'package:kohira/view/screen/menu/myCart/myCart.dart';
import '../../../view/screen/menu/category/Category.dart';

class Bottamnavigation extends GetxController {
  //index the Swich Screen
  var selectindex = 0.obs;

  //Add Screen
  List<Widget> scrren = [
    Home(),
    Categorys(),
    Mycart(),
    Account(),
  ];

  //Swich the Screen
  Widget selectscreen(int index) {
    return scrren[index];
  }

  Widget get indexThreeScreen => scrren[2];

  //Button Fuction of selected of index
  indexOne() => selectindex.value = 0;
  indexTwo() => selectindex.value = 1;
  indexThree() => selectindex.value = 2;
  indexFour() => selectindex.value = 3;
}