
// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../app_json.dart';

class LoadingState {
  static void show(text) {
    if (!Get.isDialogOpen!) {
      Get.dialog(Center(child: Lottie.asset(text)), barrierDismissible: false);
    }
  }

  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}

class LoadingDialog {
  static bool isShown = false;

  static void show() {
    if (!isShown) {
      isShown = true;
      Get.dialog(
        Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  AppJson.loading2,
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 16),
                Text('Loading...'),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hide() {
    if (isShown && Get.isDialogOpen!) {
      isShown = false;
      Get.back();
    }
  }
}
