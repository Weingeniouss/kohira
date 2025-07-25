// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderhistory.dart';
import 'package:kohira/view/screen/menu/account/wallet/wallet.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/inputField.dart';

import '../../../../view/utils/app_constants.dart';
import '../../../API/menu/account/profile.dart';

class AccountController extends GetxController{
  final profileDetails = Get.put(ProfiledetailsController());

  @override
  void onInit() {
    super.onInit();
    profileDetails.profiledetailscall();
  }

  listButton(index,context){
    //Order History
    if(index == 0) Get.to(() => Orderhistory(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Wistlist
    if(index == 1) print('Wishlist');

    //Wallet
    if(index == 2) Get.to(() => Wallet(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Password Change
    if(index == 4) ChagePasswprd().passwordchange(context);
  }
}

class ChagePasswprd{
  final profile = Get.put(ProfiledetailsController());
  final profileEdit = Get.put(ProfileEdit());
   void passwordchange(context){
     profile.profiledetailscall();
     final oldpasssword = TextEditingController();
     final newpasssword = TextEditingController();
     final confirmpasssword = TextEditingController();
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        backgroundColor: AppColor.white_color,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: () => Get.back(),child: button(AppString.cancel)),
              GestureDetector(
                onTap: (){
                  final info = profile.data['data'];
                  profileEdit.profileedit(
                    firstname: info['firstname'],
                    lastname: info['lastname'],
                    email: info['email'],
                    mobileno: info['mobileno'],
                    change_password: 'true',
                    old_password: oldpasssword.text,
                    password: newpasssword.text,
                    confirm_password: newpasssword.text,
                  );
                },
                child: button(AppString.submit),
              ),
            ],
          )
        ],
        content: Container(
          height: Get.height *0.3, width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Column(
            children: [
              SizedBox(height: Get.height / 20),
              inputField(controller: oldpasssword,hintText: AppString.oldpassword),
              inputField(controller: newpasssword, hintText: AppString.newpassword),
              inputField(controller: confirmpasssword, hintText: AppString.confirmpassword),
            ],
          ),
        ),
      );
    });
  }
}