// ignore_for_file: prefer_const_constructors, deprecated_member_use, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../view/screen/menu/account/addresses/addNewAddresses.dart';
import '../../../../view/utils/app_String.dart';
import '../../../../view/utils/app_color.dart';
import '../../../../view/utils/app_gif.dart';
import '../../../../view/utils/app_icon.dart';
import '../../../../view/utils/widget/button.dart';
import '../../../../view/utils/widget/horizontalpading.dart';
import '../../../API/menu/account/addresses.dart';

class Cheackout_Controller extends GetxController {
  bool get shouldScroll => !billing.value || !shipping.value || !shippingtype.value;

  final shipping = ValueNotifier<bool>(true);
  var billing = true.obs;
  var shippingtype = true.obs;

  void isshipping(ctx) {
    shipping.value = !shipping.value;
    if (shipping.value) {
      Get.back();
    }

    if (!shipping.value) {
      final fech = Get.put(Fechaddresses());
      final setDeflut = Get.put(SetDeflutAddress());
      fech.fechaddresses();
      showBottomSheet(
        context: ctx,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                height: Get.height / 1.3,
                color: AppColor.white_color,
                child: Column(
                  children: [
                    horizontalpadding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Text("Select Address"),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              setState(() {
                                shipping.value = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 50),
                              decoration: BoxDecoration(color: AppColor.white_color),
                              child: SvgPicture.asset(AppIcon.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: AppColor.dividercolor),
                    Expanded(
                      flex: 8,
                      child: horizontalpadding(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: fech.data['userAdddress'].length,
                          itemBuilder: (BuildContext context, int index) {
                            final fechs = fech.data['userAdddress'][index];
                            var defalut = fechs['isdefault'];
                            var id = fechs['id'].toString();
                            return GestureDetector(
                              onTap: ()  async{
                                setState((){});
                                 await setDeflut.setDefult(id: id);
                                 await fech.fechaddresses(); // refresh list
                                 print('id :- $id');
                                 setState((){});
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColor.white_color,
                                  border: Border.all(color: (defalut == 1) ? Colors.orange : Colors.transparent),
                                  boxShadow: kElevationToShadow[1],
                                  borderRadius: BorderRadius.circular(Get.width / 50),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppIcon.parson, color: AppColor.grey_color),
                                            SizedBox(width: Get.width / 50),
                                            Row(
                                              children: [
                                                Text(fechs['firstname']),
                                                SizedBox(width: Get.width / 100),
                                                Text(fechs['lastname']),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height / 80),
                                    Row(
                                      children: [
                                        Image.asset(AppGif.earth, scale: 1.9),
                                        SizedBox(width: Get.width / 50),
                                        SizedBox(
                                          width: Get.width / 1.5,
                                          child: Text(fechs['address']),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height / 50),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.mobile, color: AppColor.grey_color),
                                        SizedBox(width: Get.width / 50),
                                        Text(fechs['mobileno']),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              setState(() {
                                shipping.value = true;
                              });
                              Get.to(() => AddNewAddresses());
                            },
                            child: horizontalpadding(
                              child: button(AppString.addnewAddress),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Small gap instead of huge vertical padding
                          horizontalpadding(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                    border: Border.all(color: AppColor.grey_color),
                                  ),
                                  child: Text(AppString.clear),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColor.pink_color,
                                    borderRadius: BorderRadius.circular(Get.width / 50),
                                  ),
                                  child: Text(AppString.save, style: TextStyle(color: AppColor.white_color, fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  void isbilling() {
    billing.value = !billing.value;
    update();
  }

  void isshippingtype() {
    shippingtype.value = !shippingtype.value;
    update();
  }
}
