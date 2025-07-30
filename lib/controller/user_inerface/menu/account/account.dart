// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/profile.dart';
import 'package:kohira/controller/API/menu/account/profiledetails.dart';
import 'package:kohira/controller/database/local/localstore.dart';
import 'package:kohira/view/screen/menu/account/addresses/addresses.dart';
import 'package:kohira/view/screen/menu/account/order%20history/orderhistory.dart';
import 'package:kohira/view/screen/menu/account/retray%20&%20refund%20policy/retray.dart';
import 'package:kohira/view/screen/menu/account/returns%20&%20Exchanges/returns.dart';
import 'package:kohira/view/screen/menu/account/shipping%20&%20delivery%20policy/shipping.dart';
import 'package:kohira/view/screen/menu/account/terms%20&%20condition/terms.dart';
import 'package:kohira/view/screen/menu/account/wallet/wallet.dart';
import 'package:kohira/view/screen/menu/account/warranty%20&%20jewellery%20cleam/warranty.dart';
import 'package:kohira/view/screen/menu/myCart/wishList/wishlist.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/button.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import '../../../../view/screen/menu/account/compliance policy/compliance.dart';
import '../../../../view/screen/menu/account/privacy policy/privacy.dart';
import '../../../../view/utils/widget/pop.dart';

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
    if(index == 1) Get.to(() => WishlistScreen(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Wallet
    if(index == 2) Get.to(() => Wallet(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Address
    if(index == 3) Get.to(() => Addresses(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Password Change
    if(index == 4) ChangePassword().passwordchange(context);

    //Shipping & Delivery Policy
    if(index == 6) Get.to(() => Shipping(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Retary & Refunad
    if(index == 7) Get.to(() => Retray(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Privacy Policy
    if(index == 8) Get.to(() => Privacy(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Terms & Condition
    if(index == 9) Get.to(() => Terms(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Returns & Exchanges
    if(index == 10) Get.to(() => Returns(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Warranty & Jewellery Cleam
    if(index == 11) Get.to(() => Warranty(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Compliance policy
    if(index == 12) Get.to(() => Compliance(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 800));

    //Logout
    if(index == 13) logoutUser();
  }
}

class ChangePassword {
  final profile = Get.put(ProfiledetailsController());
  final profileEdit = Get.put(ProfileEdit());

  void passwordchange(BuildContext context) {
    profile.profiledetailscall();
    final oldPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: AppColor.white_color,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: () => Get.back(), child: button(AppString.cancel)),
                GestureDetector(
                  onTap: () async {
                    final info = profile.data['data'];
                    final result = await profileEdit.profileedit(
                      firstname: info['firstname'],
                      lastname: info['lastname'],
                      email: info['email'],
                      mobileno: info['mobileno'],
                      change_password: 'true',
                      old_password: oldPassword.text,
                      password: newPassword.text,
                      confirm_password: confirmPassword.text,
                    );

                    if (result['success'] == true && result['message'] != null) {
                      ToastificationSuccess.Success(result['message']);
                      Get.back();
                    } else {
                      if (result['errors'] != null) {
                        final errors = result['errors'];
                        if (errors.containsKey('old_password')) ToastificationError.Error(errors['old_password'][0]);
                        if (errors.containsKey('password')) ToastificationError.Error(errors['password'][0]);
                        if (errors.containsKey('confirm_password')) ToastificationError.Error(errors['confirm_password'][0]);
                        if (errors.containsKey('email')) ToastificationError.Error(errors['email'][0]);
                        if (errors.containsKey('firstname')) ToastificationError.Error(errors['firstname'][0]);
                        if (errors.containsKey('lastname')) ToastificationError.Error(errors['lastname'][0]);
                      } else {
                        ToastificationError.Error(result['message'] ?? 'Unknown error occurred');
                      }
                    }
                  },
                  child: button(AppString.submit),
                ),
              ],
            )
          ],
          content: Container(
            height: Get.height * 0.3,
            width: Get.width,
            decoration: BoxDecoration(color: AppColor.white_color),
            child: Column(
              children: [
                SizedBox(height: Get.height / 20),
                inputField(controller: oldPassword, hintText: AppString.oldpassword),
                inputField(controller: newPassword, hintText: AppString.newpassword),
                inputField(controller: confirmPassword, hintText: AppString.confirmpassword),
              ],
            ),
          ),
        );
      },
    );
  }
}
