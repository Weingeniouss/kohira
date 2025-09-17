// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/profile.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/API/menu/account/profiledetails.dart';
import '../../../../utils/app_String.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/widget/aapbar.dart';
import '../../../../utils/widget/button.dart';
import '../../../../utils/widget/inputField.dart';

class Profileedit extends StatefulWidget {
  const Profileedit({super.key});

  @override
  State<Profileedit> createState() => _ProfileeditState();
}

class _ProfileeditState extends State<Profileedit> {
  final profile = Get.put(ProfiledetailsController());
  final profileEdit = Get.put(ProfileEdit());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController? fristname;
  TextEditingController? lastname;
  TextEditingController? email;
  TextEditingController? mobile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profile.profiledetailscall();
      final info = profile.data['data'];
      setState(() {
        fristname = TextEditingController(text: info['firstname'] ?? '');
        lastname = TextEditingController(text: info['lastname'] ?? '');
        email = TextEditingController(text: info['email'] ?? '');
        mobile = TextEditingController(text: info['mobileno'] ?? '');
      });
    });
  }

  Future<void> editvalue() async {
    await profileEdit.profileedit(
      firstname: fristname!.text,
      lastname: lastname!.text,
      email: email!.text,
      mobileno: mobile!.text,
      change_password: 'false',
    );

    if (profileEdit.data['status'] == 'error') {
      final errors = profileEdit.data['errors'];
      if (errors != null && errors.containsKey('zip')) ToastificationError.Error(errors['zip'][0]);
      if (errors != null && errors.containsKey('firstname')) ToastificationError.Error(errors['firstname'][0]);
      if (errors != null && errors.containsKey('lastname')) ToastificationError.Error(errors['lastname'][0]);
      if (errors != null && errors.containsKey('email')) ToastificationError.Error(errors['email'][0]);
      if (errors != null && errors.containsKey('address')) ToastificationError.Error(errors['address'][0]);
      if (errors != null && errors.containsKey('city')) ToastificationError.Error(errors['city'][0]);
      if (errors != null && errors.containsKey('state')) ToastificationError.Error(errors['state'][0]);
      if (errors != null && errors.containsKey('country')) ToastificationError.Error(errors['country'][0]);
      if (errors != null && errors.containsKey('countrycode')) ToastificationError.Error(errors['countrycode'][0]);
      if (errors != null && errors.containsKey('mobileno')) ToastificationError.Error(errors['mobileno'][0]);
      if (errors != null && errors.containsKey('id')) ToastificationError.Error(errors['mobileno'][0]);
      if (errors != null && errors.containsKey('isdefault')) ToastificationError.Error(errors['isdefault'][0]);
    }

    if (profileEdit.data['success'] == true) {
      ToastificationSuccess.Success(profileEdit.data['message']);
    }
    Get.back();
    await profile.profiledetailscall();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        profile.profiledetailscall();
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          lefticon: AppIcon.left,
          onTaplefticon: () {
            Get.back();
            profile.profiledetailscall();
          },
          hedingname_2: AppString.editprofile,
        ),
        bottomNavigationBar: SafeArea(
          child: Obx((){
            if(profile.isLoading.value){
              return SizedBox();
            }else{
             return Container(
                color: AppColor.white_color,
                height: Get.height * 0.080,
                child: horizontalpadding(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: editvalue,
                          child: button(AppString.save),
                        ),
                        SizedBox(height: Get.height / 50),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: horizontalpadding(
            child: Obx(() {
              if (profile.isLoading.value) {
                return Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Shimmer.fromColors(
                        baseColor: AppColor.lodingcolor,
                        highlightColor: AppColor.highlightColor,
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColor.white_color,
                                borderRadius: BorderRadius.circular(Get.width / 80),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: Get.width),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: AppColor.lodingcolor,
                        highlightColor: AppColor.highlightColor,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColor.white_color,
                            borderRadius: BorderRadius.circular(Get.width / 50),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height / 80),
                  ],
                );
              }
              return Column(
                children: [
                  SizedBox(height: Get.height / 50),
                  inputField(icon: AppIcon.parson, controller: fristname),
                  inputField(icon: AppIcon.parson, controller: lastname),
                  inputField(icon: AppIcon.mail, controller: email),
                  inputField(icon: AppIcon.mobile, controller: mobile),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
