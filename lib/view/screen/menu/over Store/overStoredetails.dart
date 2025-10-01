// ignore_for_file: prefer_const_constructors, file_names, unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/overstore/overstoredetails.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/inputField.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/RecaptchaWidget.dart';
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
  final String siteKey = "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF";
  final String baseUrl = "https://next.weingenious.in";

  TextEditingController dateController = TextEditingController();
  TextEditingController enterfullname = TextEditingController();
  TextEditingController emailaddress = TextEditingController();
  TextEditingController talkabout = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  bool isCheck = false;
  String? recaptchaToken;
  DateTime? selectedDate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => overstoredetails.getOverStoreDetails(widget.slug));
    super.initState();
  }

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

  // Show reCAPTCHA when checkbox is clicked
  void isCheckValue(bool? val) {
    if (val == true) {
      _showRecaptchaVerification();
    } else {
      setState(() {
        isCheck = false;
        recaptchaToken = null;
      });
    }
  }

  // Method to show reCAPTCHA
void _showRecaptchaVerification() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: AppColor.white_color,
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: Get.height * 0.6,
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Optional header or spacing
            SizedBox(height: 16),
            // Expanded must be direct child of Column (a Flex)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: RecaptchaWidget(
                  siteKey: siteKey,
                  baseUrl: baseUrl,
                  onVerified: (String token) {
                    if (kDebugMode) {
                      print('✅ reCAPTCHA Token: $token');
                    }

                    Navigator.pop(context);

                    setState(() {
                      isCheck = true;
                      recaptchaToken = token;
                    });

                    // Get.snackbar(
                    //   'Success',
                    //   'Verification completed!',
                    //   backgroundColor: Colors.green,
                    //   colorText: Colors.white,
                    //   snackPosition: SnackPosition.BOTTOM,
                    //   duration: Duration(seconds: 2),
                    //   margin: EdgeInsets.all(10),
                    // );
                    ToastificationSuccess.Success('Verification completed!');
                  },
                  onError: () {
                    if (kDebugMode) {
                      print('❌ reCAPTCHA Error');
                    }

                    Navigator.pop(context);

                    setState(() {
                      isCheck = false;
                      recaptchaToken = null;
                    });

                    // Get.snackbar(
                    //   'Error',
                    //   'Verification failed. Please try again.',
                    //   backgroundColor: Colors.red,
                    //   colorText: Colors.white,
                    //   snackPosition: SnackPosition.BOTTOM,
                    //   duration: Duration(seconds: 2),
                    //   margin: EdgeInsets.all(10),
                    // );
                    ToastificationError.Error('Verification failed. Please try again.');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ).then((_) {
    if (recaptchaToken == null) {
      setState(() => isCheck = false);
     }
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.OverStoreDetails),
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          if (overstoredetails.isLoading.value) {
            return Shimmer.fromColors(
              baseColor: AppColor.lodingcolor,
              highlightColor: AppColor.highlightColor,
              child: horizontalpadding(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    Container(
                      height: Get.height * 0.05,
                      decoration: BoxDecoration(
                        color: AppColor.white_color,
                        border: Border.all(color: AppColor.textfild_color),
                        borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                      ),
                    ),
                    SizedBox(height: Get.height / 50),
                    SizedBox(
                      height: Get.height / 10,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(40),
                            margin: EdgeInsets.only(right: Get.width / 50),
                            decoration: BoxDecoration(
                              color: AppColor.white_color,
                              borderRadius: BorderRadius.circular(Get.width / 50),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: Get.height / 50),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.white_color),
                              borderRadius: BorderRadius.circular(Get.width / 50),
                            ),
                            margin: EdgeInsets.only(bottom: Get.height / 80),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Get.width,vertical: 90),
                                  decoration: BoxDecoration(
                                    color: AppColor.white_color,
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                  ),
                                ),
                                SizedBox(height: Get.height / 80),
                                Container(
                                  width: Get.width / 1.4,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColor.white_color,
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                  ),
                                ),
                                SizedBox(height: Get.height / 80),
                                Container(
                                  width: Get.width / 1.7,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColor.white_color,
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                  ),
                                ),
                                SizedBox(height: Get.height / 80),
                                Container(
                                  width: Get.width / 1.9,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColor.white_color,
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (overstoredetails.overStoreDetailsData.isEmpty || overstoredetails.overStoreDetailsData['data'] == null) return const Center(child: Text('No Data Found'));
          final storeDetail = overstoredetails.overStoreDetailsData['data']['storeDetail'];
          final image = storeDetail['store_image'];
          final imagetitle = storeDetail['store_title_image'];
          return SafeArea(
            child: SingleChildScrollView(
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
                        errorBuilder: (context, error, stackTrace) => SizedBox(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      SizedBox(height: Get.height / 50),
                      Text(storeDetail['store_sub_title'], style: TextStyle(fontSize: Get.width / 18)),
                      SizedBox(height: Get.height / 90),
                      Text(storeDetail['store_sub_description']),
                      SizedBox(height: Get.height / 90),
                      Image.network(
                        imagetitle,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => SizedBox(),
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
                              margin: EdgeInsets.only(right: 10),
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
                      SizedBox(height: Get.height / 90),
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColor.Appbercolor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Html(data: storeDetail['store_direction_step']),
                            SizedBox(height: Get.height / 90),
                            horizontalpadding(
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColor.Appbercolordark,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppString.schedule, style: TextStyle(fontSize: Get.width * 0.060, fontFamily: 'Zapf', fontWeight: FontWeight.w600)),
                                    inputField(hintText: AppString.name, textfildcolor: AppColor.grey_color, controller: enterfullname),
                                    inputField(hintText: AppString.address, textfildcolor: AppColor.grey_color, controller: emailaddress),
                                    inputField(hintText: AppString.number, textfildcolor: AppColor.grey_color, controller: phonenumber, textInputType: TextInputType.number, maxLength: 10),
                                    inputField(
                                      hintText: AppString.dates,
                                      textfildcolor: AppColor.grey_color,
                                      controller: dateController,
                                      suffixIcon: GestureDetector(
                                        onTap: () => selectDate(context),
                                        child: SvgPicture.asset(AppIcon.calendar, width: 5, height: 5),
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
                                            hintStyle: TextStyle(color: AppColor.black_color, fontSize: Get.width / 27),
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
                                            materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        SizedBox(width: Get.width / 50),
                                        Text(
                                          AppString.notarobot,
                                          style: TextStyle(
                                            color: AppColor.pink_color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: Get.width * 0.04,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height / 50),
            
                                    // Your existing button - you handle the submit
                                    button(AppString.message),
            
                                    // Debug: Show if token is available
                                    if (kDebugMode && recaptchaToken != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text('Token: ${recaptchaToken!.substring(0, 20)}...', style: TextStyle(fontSize: 10, color: Colors.green)),
                                      ),
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
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    enterfullname.dispose();
    emailaddress.dispose();
    talkabout.dispose();
    phonenumber.dispose();
    super.dispose();
  }
}
