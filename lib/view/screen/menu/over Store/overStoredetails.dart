// ignore_for_file: prefer_const_constructors, file_names

import 'dart:io';

import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/overstore/overstoredetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/button.dart';

class OverstoredetailsScreen extends StatefulWidget {
  final String slug;
  const OverstoredetailsScreen({super.key, required this.slug});

  @override
  State<OverstoredetailsScreen> createState() => _OverstoredetailsScreenState();
}

class _OverstoredetailsScreenState extends State<OverstoredetailsScreen> {
  final overstoredetails = Get.put(OverStoreDetails());

  final String siteKey = Platform.isAndroid ? "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF" : "<IOS_SITE_KEY>";

  final TurnstileOptions options = TurnstileOptions(
    size: TurnstileSize.normal,
    theme: TurnstileTheme.light,
    language: 'ar',
    retryAutomatically: false,
    refreshTimeout: TurnstileRefreshTimeout.manual,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)  => overstoredetails.getOverStoreDetails(widget.slug));
    super.initState();
  }
  TextEditingController dateController = TextEditingController();
  TextEditingController enterfullname = TextEditingController();
  TextEditingController emailaddress = TextEditingController();
  TextEditingController talkabout = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  bool isCheck = false;
  DateTime? selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void isCheckValue(bool? val) {
    if (val == true) {
      showTurnstile();
    } else {
      setState(() {
        isCheck = false;
      });
    }
  }

  Future<void> showTurnstile() async {
    final token = await CloudflareTurnstile(
      siteKey: siteKey,
      options: options,
      baseUrl: 'https://next.weingenious.in/',
      onTokenReceived: (token) {
        print(token);
      },
    );

    if (token != null) {
      setState(() {
        isCheck = true;
      });
    } else {
      setState(() {
        isCheck = false;
      });
    }
  }

  // void isCheckValue(val) async {
  //   isCheck = val;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left,hedingname_2: AppString.OverStoreDetails),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx((){
          if (overstoredetails.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // check if response data is available
          if (overstoredetails.overStoreDetailsData.isEmpty || overstoredetails.overStoreDetailsData['data'] == null) {
            return const Center(child: Text('No Data Found'));
          }
          final storeDetail = overstoredetails.overStoreDetailsData['data']['storeDetail'];
          final image = storeDetail['store_image'];
          final imagetitle = storeDetail['store_title_image'];
          return SingleChildScrollView(
            child: horizontalpadding(
              child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 50),
                    Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    SizedBox(height: Get.height / 50),
                    Text(storeDetail['store_sub_title'],style: TextStyle(fontSize: Get.width / 18)),
                    SizedBox(height: Get.height / 90),
                    Text(storeDetail['store_sub_description']),
                    SizedBox(height: Get.height / 90),
                    Image.network(
                      imagetitle,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                             return SizedBox();
                          },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    SizedBox(height: Get.height / 90),
                    SizedBox(
                      height: Get.height * 0.25,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: storeDetail['collections'].length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final collection = storeDetail['collections'][index];
                          return Container(
                            margin: EdgeInsetsGeometry.only(right: 10),
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(collection['image1']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Text(storeDetail['street_name']),
                    SizedBox(height: Get.height / 90),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(color: AppColor.Appbercolor,borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Html(data: storeDetail['store_direction_step']),
                          SizedBox(height: Get.height / 90),
                          horizontalpadding(
                            child: Container(
                              width: Get.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColor.Appbercolordark,borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppString.schedule, style: TextStyle(fontSize: Get.width * 0.060, fontFamily: 'Zapf', fontWeight: FontWeight.w600)),
                                  inputField(hintText: AppString.name,textfildcolor: AppColor.grey_color,controller: enterfullname),
                                  inputField(hintText: AppString.address,textfildcolor: AppColor.grey_color,controller: emailaddress),
                                  inputField(hintText: AppString.number,textfildcolor: AppColor.grey_color,controller: phonenumber,textInputType: TextInputType.number,maxLength: 10),
                                  inputField(
                                    hintText: AppString.dates,textfildcolor: AppColor.grey_color,
                                    controller: dateController,
                                    suffixIcon: GestureDetector(
                                      onTap: () => selectDate(context),
                                      child: SvgPicture.asset(AppIcon.calendar,width: 5,height: 5),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: Get.height / 8,
                                      child: TextField(
                                        controller: talkabout,
                                        expands: true,
                                        maxLines: null,
                                        minLines: null,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(color: AppColor.black_color,fontSize: Get.width / 27),
                                          border: UnderlineInputBorder(),
                                          hintText: '${AppString.talkabout}*',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.height / 50),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.2,
                                        child: Checkbox(
                                          value: isCheck,
                                          onChanged: (val) => isCheckValue(val),
                                          overlayColor: WidgetStatePropertyAll(AppColor.pink_color),
                                          side: BorderSide(color: AppColor.pink_color, width: 2),
                                          checkColor: AppColor.white_color,
                                          activeColor: AppColor.pink_color,
                                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      SizedBox(width: Get.width / 50),
                                      Text(AppString.notarobot, style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w500, fontSize: Get.width * 0.04)),
                                    ],
                                  ),
                                  SizedBox(height: Get.height / 50),
                                  button(AppString.message),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height / 50),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height / 50),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
