// ignore_for_file: avoid_print, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:lottie/lottie.dart';

import '../../../view/screen/credentials/login.dart' show Login;

class localdatabase {
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
   await pref!.setBool('login', false);
    islogin = pref!.getBool('login')?? false;
    print('isLogin :- $islogin');

    pref!.setString('fristname', '');
    pref!.setString('lastname', '');
    pref!.setString('email', '');
    pref!.setString('mobile', '');
    pref!.setString('password', '');
    pref!.setString('countrycode', '');

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
  localdatabase().logout();
  await Future.delayed(Duration(milliseconds: 200));
  Get.offAll(() => Login());
}
