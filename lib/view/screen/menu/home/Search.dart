// ignore_for_file: file_names, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/home/Search.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/horizontalpading.dart';
import '../../../utils/widget/inputField.dart';
import '../category/showproduct.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final search = Get.put(SearchProduct());

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.Searchs),
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Column(
          children: [
            SizedBox(height: Get.height / 50),

            //SearchBar Start
            horizontalpadding(child: searchField(focusNode: focusNode,onChanged: (val) => search.searchQuery.value = val)),

            //List of Product
            Expanded(
              child: Obx(() {
                final controller = Get.find<SearchProduct>();

                if (controller.isLoading.value) {
                  return Center(child: Lottie.asset(AppJson.loading2));
                }

                // Check if data is not null and contains 'jewelry'
                final jewelryList = controller.data['jewelry'];

                if (jewelryList == null || jewelryList.isEmpty) {
                  return Center(child: Lottie.asset(AppJson.noData));
                }

                return ListView.builder(
                  itemCount: jewelryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = jewelryList[index];
                    return horizontalpadding(
                      child: GestureDetector(
                        onTap: (){
                          print(jewelryList[index]['slug']);
                         Get.to(() => Showproduct(slug: jewelryList[index]['slug'].toString(), categoryslug: jewelryList[index]['category_slug'],));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.textfild_color),
                            borderRadius: BorderRadius.circular(Get.width * 0.04)
                          ),
                          child: ListTile(
                            leading: Image.network(item['default_image']),
                            title: Text(item['title'] ?? 'No Title'),
                            subtitle: Text('₹ ${item['setting_price'].toString()} /-',style: TextStyle(color: AppColor.pink_color,fontWeight: FontWeight.w500),),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
