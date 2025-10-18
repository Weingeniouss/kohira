// ignore_for_file: avoid_print, camel_case_types, prefer_const_constructors, strict_top_level_inference

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/modal/menu/category/subcategory/addtocart.dart';
import 'package:kohira/modal/menu/category/subcategory/addtowish.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:lottie/lottie.dart';
import '../../../view/screen/credentials/login.dart' show Login;
import '../../API/credentials/logout.dart';
import '../../user_inerface/menu/home/home.dart';

class localdatabase {
  static const String _jewelryItemsKeyCart = 'jewelry_items';
  static const String _jewelryItemsKeyWish = 'jewelry_items_wish';

  // Cart List
  // Save List Localiy  Guest User
  // Save jewelry items locally

  //wishlist
  static Future<void> saveJewelryItemsWish(List<JewelryItemWish> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await pref!.setString(_jewelryItemsKeyWish, json.encode(jsonList));
  }

  // Get jewelry items from local storage
  static Future<List<JewelryItemWish>> getJewelryItemsWish() async {
    final jsonString = pref!.getString(_jewelryItemsKeyWish);

    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((item) => JewelryItemWish.fromJson(item)).toList();
    }

    return [];
  }


  //Cart
  static Future<void> saveJewelryItems(List<JewelryItem> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await pref!.setString(_jewelryItemsKeyCart, json.encode(jsonList));
  }

  // Get jewelry items from local storage
  static Future<List<JewelryItem>> getJewelryItems() async {
    final jsonString = pref!.getString(_jewelryItemsKeyCart);

    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((item) => JewelryItem.fromJson(item)).toList();
    }

    return [];
  }

  // Add a single jewelry item
  static Future<void> addJewelryItem(JewelryItem newItem) async {
    final items = await getJewelryItems();
    items.add(newItem);
    await saveJewelryItems(items);
  }

  // Clear all jewelry items
  static Future<void> clearJewelryItems() async {
    await pref!.remove(_jewelryItemsKeyCart);
  }

  Future<void> deleteJewelryItem(int index) async {
    final String? jewelryItemsJson = pref!.getString(_jewelryItemsKeyCart);

    if (jewelryItemsJson != null) {
      List<dynamic> jewelryItems = jsonDecode(jewelryItemsJson);
      if (index >= 0 && index < jewelryItems.length) {
        print('Deleting jewelry item: ${jewelryItems[index]}');
        jewelryItems.removeAt(index);
        await pref!.setString(_jewelryItemsKeyCart, jsonEncode(jewelryItems));
        print('Jewelry item at index $index deleted successfully.');
      } else {
        print('Invalid index: $index');
      }
    } else {
      print('No jewelry items found in local storage.');
    }
  }

  Future<void> incrementItemCountInLocal(int index, int newCount) async {
    final String? jewelryItemsJson = pref!.getString(_jewelryItemsKeyCart);

    if (jewelryItemsJson != null) {
      List<dynamic> jewelryItems = jsonDecode(jewelryItemsJson);
      if (index >= 0 && index < jewelryItems.length) {
        var item = jewelryItems[index];
        item['count'] = newCount;
        jewelryItems[index] = item;
        await pref!.setString(_jewelryItemsKeyCart, jsonEncode(jewelryItems));
        print('Updated local jewelry item count at index $index → $newCount');
      } else {
        print('Invalid index: $index');
      }
    } else {
      print('No jewelry items found in local storage.');
    }
  }

  Future<void> decrementItemCountInLocal(int index, int newCount) async {
    final String? jewelryItemsJson = pref!.getString(_jewelryItemsKeyCart);

    if (jewelryItemsJson != null) {
      List<dynamic> jewelryItems = jsonDecode(jewelryItemsJson);
      if (index >= 0 && index < jewelryItems.length) {
        var item = jewelryItems[index];
        item['count'] = newCount;
        jewelryItems[index] = item;
        await pref!.setString(_jewelryItemsKeyCart, jsonEncode(jewelryItems));
        print('Updated local jewelry item count at index $index → $newCount');
      } else {
        print('Invalid index: $index');
      }
    } else {
      print('No jewelry items found in local storage.');
    }
  }

  void sinupstore({
    required String fristname,
    required String lastname,
    required String email,
    required String mobile,
    required String password,
    required String countrycode,
  }) {
    pref!.setString('fristname', fristname);
    pref!.setString('lastname', lastname);
    pref!.setString('email', email);
    pref!.setString('mobile', mobile);
    pref!.setString('password', password);
    pref!.setString('countrycode', countrycode);

    Fristname = pref!.getString('fristname')!;
    Lastname = pref!.getString('lastname')!;
    Email = pref!.getString('email')!;
    Mobile = pref!.getString('mobile')!;
    Password = pref!.getString('password')!;
    Countrycode = pref!.getString('countrycode')!;

    print('fristname :- $Fristname');
    print('lastname :- $Lastname');
    print('email :- $Email');
    print('mobile :- $Mobile');
    print('password :- $Password');
    print('countrycode :- $Countrycode');
  }

  void loginstrore({required String email, required String password}){
    pref!.setString('email', email);
    pref!.setString('password', password);

    Email = pref!.getString('email')!;
    Password = pref!.getString('password')!;

    print('email :- $Email');
    print('password :- $Password');

    pref!.setBool('login', true);
    islogin = pref!.getBool('login')?? false;

    print('tokan :- $tokans');
    print('isLogin :- $islogin');

    // if(Email == email && Password == password){
    //   pref!.setBool('login', true);
    //   islogin = pref!.getBool('login')!;
    //
    //   print('isLogin :- $islogin');
    // }
  }

  Future logout() async{
    Logout().logout();
   await pref!.setBool('login', false);
    islogin = pref!.getBool('login')?? false;
    print('isLogin :- $islogin');

    await pref!.remove('login');
    await pref!.remove('fristname');
    await pref!.remove('lastname');
    await pref!.remove('email');
    await pref!.remove('mobile');
    await pref!.remove('password');
    await pref!.remove('countrycode');
    await pref!.remove('tokan');

    // Reset variables
    islogin = false;
    Fristname = '';
    Lastname = '';
    Email = '';
    Mobile = '';
    Password = '';
    Countrycode = '';
    tokans = '';

    pref!.setString('fristname', '');
    pref!.setString('lastname', '');
    pref!.setString('email', '');
    pref!.setString('mobile', '');
    pref!.setString('password', '');
    pref!.setString('countrycode', '');
    await pref!.setString('tokan', '');

    Fristname = pref!.getString('fristname')!;
    Lastname = pref!.getString('lastname')!;
    Email = pref!.getString('email')!;
    Mobile = pref!.getString('mobile')!;
    Password = pref!.getString('password')!;
    Countrycode = pref!.getString('countrycode')!;
    tokans = pref!.getString('tokan') ?? '';

    print('fristname :- $Fristname');
    print('lastname :- $Lastname');
    print('email :- $Email');
    print('mobile :- $Mobile');
    print('password :- $Password');
    print('countrycode :- $Countrycode');
    print('token :- $tokans');
  }

  //Product details
  // Save to SharedPreferences
  Future<void> saveToWishlist(storageKey) async {
    try {
      List<String> currentList = pref!.getStringList(storageKey) ?? [];
      if (!currentList.contains(storageKey)) {
        currentList.add(storageKey);
        await pref!.setStringList(storageKey, currentList);
      }
      print('Saved wishlist: ${pref!.getStringList(storageKey)}');
    } catch (e) {
      print('Error saving to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String storageKey) async {
    try {
      List<String> currentList = pref!.getStringList(storageKey) ?? [];
      if (currentList.contains(storageKey)) {
        currentList.remove(storageKey);
        await pref!.setStringList(storageKey, currentList);
      }
      print('Removed from wishlist: ${pref!.getStringList(storageKey)}');
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }
}

void logoutUser() async {
  Get.dialog(Center(child: Lottie.asset(AppJson.loading2)), barrierDismissible: false);
  await Future.delayed(Duration(seconds: 2));
  Get.back();
  if (Get.isRegistered<HomeController>()) {
    Get.delete<HomeController>(force: true);
  }
  localdatabase().logout();
  await Future.delayed(Duration(milliseconds: 200));
  Get.offAll(() => Login());
}
