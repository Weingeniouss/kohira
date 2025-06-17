
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


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
