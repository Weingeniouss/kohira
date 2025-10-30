// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, avoid_print, deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/credentials/Sinup.dart';
import 'package:kohira/modal/credentials/country.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../../controller/API/credentials/country.dart';
import '../../../controller/database/local/localstore.dart';
import '../../../controller/user_inerface/credentials/singup_controller.dart';
import '../../utils/app_String.dart';
import '../../utils/app_icon.dart';
import '../../utils/widget/RecaptchaWidget.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/connction.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/lodingstate.dart';
import '../../utils/widget/pop.dart';
import '../../utils/widget/set_logo.dart';
import '../../utils/widget/title_text.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Country = Get.put(CountryCalling());
  final validation = Get.put(SingupController());
  final Sinup = Get.put(SinupCalling());
  final String siteKey = "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF";
  final String baseUrl = "https://next.weingenious.in";

  bool isCheck = false;
  String? recaptchaToken;

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
    final TextEditingController searchController = TextEditingController();
    ever(Sinup.isLoading, (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isLoading) {
          LoadingState.show(AppJson.loading2);
        } else {
          LoadingState.hide();
        }
      });
    });

    return Obx(() {
      void sinup() {
        hasInternetConnection().then((connect) {
          if (!connect) {
            ToastificationError.Error('No Internet Connection! Conncet the Internet then try Agen !!');
            return;
          } else {
            if (validation.password_controller.value == validation.confiim_password_controller.value) {
              validation.SignupnTab(() {
                Sinup.registerUser(
                  firstname: validation.frist_controller.text,
                  lastname: validation.last_controller.text,
                  email: validation.email_controller.text,
                  password: validation.password_controller.text,
                  passwordConfirmation: validation.confiim_password_controller.text,
                  mobileno: validation.mobile_controller.text,
                  captcha: recaptchaToken.toString(),
                  countrycode: Country.selectedCountry.value!.countrycode.toString(),
                  country_shortname: Country.selectedCountry.value!.countryShortname.toString(),
                  login_type: 'mobile',
                );
                localdatabase().sinupstore(
                  fristname: validation.frist_controller.text,
                  lastname: validation.last_controller.text,
                  email: validation.email_controller.text,
                  mobile: validation.mobile_controller.text,
                  password: validation.password_controller.text,
                  countrycode: Country.selectedCountry.value!.countrycode.toString(),
                );
              });
            } else {
              ToastificationError.Error('Password dose not mache !');
            }
          }
        });
      }

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(color: AppColor.white_color),
          child: SafeArea(
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(color: AppColor.white_color),
              child: SafeArea(
                child: horizontalpadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setLogo(),
                        ],
                      ),
                      title_text(AppString.signin),
                      SizedBox(height: Get.height / 80),
                      sub_titel_text(AppString.subsignin),
                      SizedBox(height: Get.height / 80),

                      //Inputfild
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              inputField(hintText: AppString.firstname, icon: AppIcon.parson, controller: validation.frist_controller, empty: validation.firstname_type.value),
                              inputField(hintText: AppString.lastname, icon: AppIcon.parson, controller: validation.last_controller, empty: validation.lastname_type.value),
                              inputField(hintText: AppString.hintemail, icon: AppIcon.mail, controller: validation.email_controller, empty: validation.email_type.value),
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: 8),
                              //   decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                              //   child: Row(
                              //     children: [
                              //       SizedBox(width: Get.width / 60),
                              //       SvgPicture.asset(AppIcon.earth,width: 25,height: 25,color: AppColor.pink_color),
                              //       SizedBox(width: Get.width / 50),
                              //       Expanded(
                              //         child: DropdownButton2<Data>(
                              //           iconStyleData: IconStyleData(
                              //             icon: Icon(Icons.keyboard_arrow_down),
                              //             iconSize: 20,
                              //             iconEnabledColor: AppColor.grey_color,
                              //             iconDisabledColor: AppColor.grey_color,
                              //             openMenuIcon: Icon(Icons.keyboard_arrow_up),
                              //           ),
                              //           value: Country.selectedCountry.value,
                              //           dropdownSearchData: DropdownSearchData(
                              //             searchController: searchController,
                              //             searchInnerWidgetHeight: 40,
                              //             searchInnerWidget: Padding(
                              //               padding: EdgeInsets.all(8),
                              //               child: TextField(
                              //                 controller: searchController,
                              //                 decoration: InputDecoration(
                              //                   hintText: 'Search...',
                              //                   border: OutlineInputBorder(),
                              //                 ),
                              //               ),
                              //             ),
                              //             searchMatchFn: (item, searchValue) {
                              //               return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                              //             },
                              //           ),
                              //           underline: SizedBox(),
                              //           isExpanded: true,
                              //           items: Country.countries.map((item) => DropdownMenuItem(value: item, child: Text("${item.label} (${item.countrycode})"))).toList(),
                              //           onChanged: (newValue) {
                              //             Country.selectedCountry.value = newValue!;
                              //           },
                              //           dropdownStyleData: DropdownStyleData(
                              //             offset: Offset(0, -10),
                              //             maxHeight: Get.height / 3,
                              //             decoration: BoxDecoration(color: AppColor.white_color),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                                child: Row(
                                  children: [
                                    SizedBox(width: Get.width / 50),
                                    SvgPicture.asset(AppIcon.location, fit: BoxFit.cover, color: AppColor.pink_color, width: 22, height: 22),
                                    SizedBox(width: Get.width / 60),
                                    //Country
                                    Expanded(
                                      child: Obx(() {
                                        return DropdownButton2<Data>(
                                          value: Country.selectedCountry.value,
                                          hint: Text('Select Country *', style: TextStyle(color: AppColor.black_color, fontWeight: FontWeight.w400,fontSize: Get.width / 26)),
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          items: Country.countries.map((item) {
                                            return DropdownMenuItem<Data>(value: item, child: Text(item.label.toString()));
                                          }).toList(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: Get.width / 25,
                                            color: AppColor.black_color,
                                          ),
                                          onChanged: (newValue) => Country.selectedCountry.value = newValue!,
                                          dropdownStyleData: DropdownStyleData(offset: Offset(0, -10), maxHeight: Get.height / 3, decoration: BoxDecoration(color: AppColor.white_color)),
                                          iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_outlined, color: AppColor.dividercolor), iconSize: 24),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchController,
                                            searchInnerWidgetHeight: 40,
                                            searchInnerWidget: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: TextField(
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  hintText: 'Search Country...',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) =>  item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false,
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Get.height / 150),
                              inputField(hintText: AppString.hintmobile, icon: AppIcon.mobile, controller: validation.mobile_controller, empty: validation.mobile_type.value,maxLength: 10,textInputType: TextInputType.phone),
                              inputField(hintText: AppString.hintpassword, icon: AppIcon.password, controller: validation.password_controller, empty: validation.password_type.value,isVis: true),
                              inputField(hintText: AppString.hintconfirmpassword, icon: AppIcon.password, controller: validation.confiim_password_controller, empty: validation.confirmpassword_type.value,isVis: true),
                              SizedBox(height: Get.height / 50),
                              horizontalpadding(
                                child: Row(
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
                              ),
                              SizedBox(height: Get.height / 50),

                              //
                              Text(AppString.singupHading, style: TextStyle(fontSize: Get.width * 0.033)),
                              SizedBox(height: Get.height / 30),
                              GestureDetector(
                                onTap: sinup,
                                child: (Sinup.isLoading.value)
                                    ? circle(CircularProgressIndicator(color: AppColor.white_color))
                                    : button(AppString.signUp),
                              ),
                              SizedBox(height: Get.height / 50),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: Get.height * 0.050,
              decoration: BoxDecoration(color: AppColor.white_color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppString.donthaveanaccount, style: TextStyle(fontSize: Get.width * 0.04)),
                  SizedBox(width: Get.width / 100),
                  Text(
                    AppString.signin,
                    style: TextStyle(
                      fontSize: Get.width * 0.04,
                      fontWeight: FontWeight.w600,
                      color: AppColor.pink_color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
