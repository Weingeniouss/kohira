// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/account/profile.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/API/menu/account/profiledetails.dart';
import '../../../../utils/app_icon.dart';
import '../../../../utils/widget/aapbar.dart';

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
      if (errors != null && errors.containsKey('zip')) {
        ToastificationError.Error(errors['zip'][0]);
      }
      if (errors != null && errors.containsKey('firstname')) {
        ToastificationError.Error(errors['firstname'][0]);
      }
      if (errors != null && errors.containsKey('lastname')) {
        ToastificationError.Error(errors['lastname'][0]);
      }
      if (errors != null && errors.containsKey('email')) {
        ToastificationError.Error(errors['email'][0]);
      }
      if (errors != null && errors.containsKey('address')) {
        ToastificationError.Error(errors['address'][0]);
      }
      if (errors != null && errors.containsKey('city')) {
        ToastificationError.Error(errors['city'][0]);
      }
      if (errors != null && errors.containsKey('state')) {
        ToastificationError.Error(errors['state'][0]);
      }
      if (errors != null && errors.containsKey('country')) {
        ToastificationError.Error(errors['country'][0]);
      }
      if (errors != null && errors.containsKey('countrycode')) {
        ToastificationError.Error(errors['countrycode'][0]);
      }
      if (errors != null && errors.containsKey('mobileno')) {
        ToastificationError.Error(errors['mobileno'][0]);
      }
      if (errors != null && errors.containsKey('id')) {
        ToastificationError.Error(errors['mobileno'][0]);
      }
      if (errors != null && errors.containsKey('isdefault')) {
        ToastificationError.Error(errors['isdefault'][0]);
      }
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
          hedingname_2: "Profile Details",
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.white_color,
              border: Border(top: BorderSide(color: AppColor.borderGrey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        profile.profiledetailscall();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColor.containerBg,
                        side: BorderSide(color: AppColor.borderGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColor.black_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: editvalue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.pink_color,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: AppColor.white_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: SafeArea(
            child: horizontalpadding(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Obx(() {
                  if (profile.isLoading.value) {
                    return Shimmer.fromColors(
                      baseColor: AppColor.lodingcolor,
                      highlightColor: AppColor.highlightColor,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: AppColor.white_color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.white_color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.borderGrey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black_color,
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildLabeledField("First Name *", fristname),
                            SizedBox(height: 16),
                            _buildLabeledField("Last Name *", lastname),
                            SizedBox(height: 16),
                            _buildLabeledField("Email ID *", email,
                                keyboardType: TextInputType.emailAddress),
                            SizedBox(height: 16),
                            _buildMobileField(),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(
    String label,
    TextEditingController? controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.borderGrey),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 15,
                color: AppColor.black_color,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mobile No *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 50,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.borderGrey),
              ),
              child: Center(
                child: Image.asset(AppIcon.india, width: 28),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.borderGrey),
                ),
                child: Center(
                  child: TextField(
                    controller: mobile,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.black_color,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
