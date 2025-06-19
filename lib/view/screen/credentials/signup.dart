// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable, avoid_print


// else if(validation.frist_controller.text.isEmpty){
//                               validation.firstname_type.value = true;
//                               validation.lastname_type.value = false;
//                               validation.email_type.value = false;
//                               validation.mobile_type.value = false;
//                               validation.password_type.value = false;
//                               validation.confirmpassword_type.value = false;
//                               ToastificationError.Error('Plsese Enter the FristName !');
//                             }else if(validation.last_controller.text.isEmpty){
//                               validation.firstname_type.value = false;
//                               validation.lastname_type.value = true;
//                               validation.email_type.value = false;
//                               validation.mobile_type.value = false;
//                               validation.password_type.value = false;
//                               validation.confirmpassword_type.value = false;
//                               ToastificationError.Error('Plsese Enter the LastName !');
//                             }else if(validation.email_controller.text.isEmpty){
//                               validation.firstname_type.value = false;
//                               validation.lastname_type.value = false;
//                               validation.email_type.value = true;
//                               validation.mobile_type.value = false;
//                               validation.password_type.value = false;
//                               validation.confirmpassword_type.value = false;
//                               ToastificationError.Error('Plsese Enter the Email !');
//                             }else if(validation.password_controller.text.isEmpty){
//                               validation.firstname_type.value = false;
//                               validation.lastname_type.value = false;
//                               validation.email_type.value = false;
//                               validation.mobile_type.value = false;
//                               validation.password_type.value = true;
//                               validation.confirmpassword_type.value = false;
//                               ToastificationError.Error('Plsese Enter the Password !');
//                             }else if(validation.confiim_password_controller.text.isEmpty){
//                               validation.firstname_type.value = false;
//                               validation.lastname_type.value = false;
//                               validation.email_type.value = false;
//                               validation.mobile_type.value = false;
//                               validation.password_type.value = false;
//                               validation.confirmpassword_type.value = true;
//                               ToastificationError.Error('Plsese Enter the ConfimPassword !');
//                             }

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/credentials/Sinup.dart';
import 'package:kohira/modal/credentials/country.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_gif.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../../controller/API/credentials/country.dart';
import '../../../controller/user_inerface/credentials/singup_controller.dart';
import '../../utils/app_String.dart';
import '../../utils/app_icon.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/connction.dart';
import '../../utils/widget/inputField.dart';
import '../../utils/widget/lodingstate.dart';
import '../../utils/widget/pop.dart';
import '../../utils/widget/set_logo.dart';
import '../../utils/widget/title_text.dart';

class Signup extends StatelessWidget {
  final Country = Get.put(CountryCalling());  //CountryAPI
  final validation = Get.put(SingupController()); // UserInterface
  final Sinup = Get.put(SinupCalling()); // SinupAPI

  Signup({super.key});
  @override
  Widget build(BuildContext context) {
    ever(Sinup.isLoading, (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isLoading) {
          LoadingState.show(AppJson.loading2);
        } else {
          LoadingState.hide();
        }
      });
    });
    final TextEditingController searchController = TextEditingController();
    return Obx(() {
      void sinup(){
        hasInternetConnection().then((connect){
          if(!connect){
            ToastificationError.Error('No Internet Connection! Conncet the Internet then try Agen !!');
            return;
          }
          else{
            if (validation.password_controller.value == validation.confiim_password_controller.value) {
              validation.SignupnTab(() {
              Sinup.registerUser(
              firstname: validation.frist_controller.text,
              lastname: validation.last_controller.text,
              email: validation.email_controller.text,
              password: validation.password_controller.text,
              passwordConfirmation: validation.confiim_password_controller.text,
              mobileno: validation.mobile_controller.text,
              captcha: 'xylsjjffdhbvjaz',
              countrycode: Country.selectedCountry.value!.countrycode.toString(),
              country_shortname: Country.selectedCountry.value!.countryShortname.toString(),
              login_type: 'mobile',
            );
          });
        } else {
          ToastificationError.Error('Password dose not mache !');
        }}
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
                    SizedBox(height: Get.height / 20),

                    //Inputfild
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            inputField(hintText: AppString.firstname, icon: AppIcon.parson, controller: validation.frist_controller, empty: validation.firstname_type.value),
                            inputField(hintText: AppString.lastname, icon: AppIcon.parson, controller: validation.last_controller, empty: validation.lastname_type.value),
                            inputField(hintText: AppString.hintemail, icon: AppIcon.mail, controller: validation.email_controller, empty: validation.email_type.value),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.textfild_color))),
                              child: Row(
                                children: [
                                  Image.asset(AppGif.earth, scale: 1.5),
                                  SizedBox(width: Get.width / 50),
                                  Expanded(
                                    child: DropdownButton2<Data>(
                                      value: Country.selectedCountry.value,
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: searchController,
                                        searchInnerWidgetHeight: 40,
                                        searchInnerWidget: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: TextField(
                                            controller: searchController,
                                            decoration: InputDecoration(
                                              hintText: 'Search...',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value?.label?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                                        },
                                      ),
                                      underline: SizedBox(),
                                      isExpanded: true,
                                      items: Country.countries.map((item) => DropdownMenuItem(value: item, child: Text("${item.label} (${item.countrycode})"))).toList(),
                                      onChanged: (newValue) {
                                        Country.selectedCountry.value = newValue!;
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        offset: Offset(0, -10),
                                        maxHeight: Get.height / 3,
                                        decoration: BoxDecoration(color: AppColor.white_color),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Get.height / 50),
                            inputField(hintText: AppString.hintmobile, icon: AppIcon.mobile, controller: validation.mobile_controller, empty: validation.mobile_type.value),
                            inputField(hintText: AppString.hintpassword, icon: AppIcon.password, controller: validation.password_controller, empty: validation.password_type.value),
                            inputField(hintText: AppString.hintconfirmpassword, icon: AppIcon.password, controller: validation.confiim_password_controller, empty: validation.confirmpassword_type.value),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                    value: validation.value.value,
                                    onChanged: validation.selectedcheak,
                                    overlayColor: WidgetStatePropertyAll(AppColor.pink_color),
                                    side: BorderSide(color: AppColor.pink_color, width: 2),
                                    checkColor: AppColor.white_color,
                                    activeColor: AppColor.pink_color,
                                  ),
                                ),
                                Text(AppString.notarobot, style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w500, fontSize: Get.width * 0.04)),
                              ],
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

// String? _recaptchaToken;
//   bool _isVerifying = false;
//
//   Future<void> _executeRecaptcha() async {
//   setState(() => _isVerifying = true);
//
//   try {
//     final token = await RecaptchaEnterprise.execute(
//       '6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF' as RecaptchaAction, // This is a positional argument
//     );
//
//     setState(() {
//       _recaptchaToken = token;
//       _isVerifying = false;
//     });
//
//     print("reCAPTCHA token: $token");
//
//   } catch (e) {
//     print("reCAPTCHA execution error: $e");
//     ToastificationError.Error("Failed to verify reCAPTCHA");
//     setState(() => _isVerifying = false);
//   }
// }

// if (_recaptchaToken == null) { // Add reCAPTCHA check
//       ToastificationError.Error('Complete reCAPTCHA verification!');
//       return;
//     }