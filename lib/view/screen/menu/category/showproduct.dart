// ignore_for_file: avoid_print, unused_local_variable, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/category/jewelleryDetail.dart'
    show JewellerydetailCall;
import 'package:kohira/controller/API/menu/category/recommendedJewelleryList.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/video.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/widget/aapbar.dart';

class Showproduct extends StatefulWidget {
  final String slug;

  const Showproduct({super.key, required this.slug});

  @override
  State<Showproduct> createState() => _ShowproductState();
}

class _ShowproductState extends State<Showproduct> {
  int selectindex = 0;
  String? selectedRingSize;
  int? selectedRingId;
  String? selectedMetalStamp;
  String? selectedMetalType;
  bool goldcolor = false;
  bool rosegoldcolor = false;
  bool graycolor = false;
  bool initialized = false;
  String? selectedDiamondQuality;

  bool productdetails = false;
  bool centerdiamondDetails = false;
  bool sidediamondDetails = false;
  bool priceBreakup = false;

  final jewellerydetail = Get.put(JewellerydetailCall());
  final recommendedjewellerylist = Get.put(Recommendedjewellerylist());

  @override
  void initState() {
    super.initState();
    jewellerydetail.jewellerydetailservices(slug: widget.slug);
    recommendedjewellerylist.recommendedjewellerylistFuction(slug: widget.slug);
  }

  void select(int index) {
    setState(() {
      selectindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname: AppString.Searchs,
        suffixicon_1: AppIcon.like,
        suffixicon_2: AppIcon.shop,
      ),
      bottomNavigationBar: SafeArea(child: Obx(() {
        if (jewellerydetail.isLoading.value) {
          return SizedBox();
        } else {
          return Container(
            height: Get.height * 0.070,
            color: AppColor.white_color,
            child: horizontalpadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.12, vertical: Get.height * 0.015),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Get.width / 50),
                      color: Colors.black,
                    ),
                    child: Text('Add To Cart', style: TextStyle(color: AppColor.white_color)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.14, vertical: Get.height * 0.015),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Get.width / 50),
                      color: Colors.black,
                    ),
                    child: Text('Buy Now', style: TextStyle(color: AppColor.white_color)),
                  ),
                ],
              ),
            ),
          );
        }
      })),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Obx(() {
           if (jewellerydetail.isLoading.value) {
            return Center(child: Lottie.asset(AppJson.loading2));
          }

          final jewellery = jewellerydetail.data['data'];
          final variants = jewellery['variants'] ?? [];
          final allRingSizes = jewellery['allRingSize'] ?? [];

          // Initialize selections
          if (!initialized && variants.isNotEmpty) {
            final defaultSize = allRingSizes.firstWhere(
              (element) => element['default'] == 1,
              orElse: () => allRingSizes.isNotEmpty ? allRingSizes[0] : null,
            );

            selectedRingSize = defaultSize != null ? defaultSize['paraname'] : null;

            // Find parent variant (default selection)
            final parentVariant = variants.firstWhere(
              (v) => v['parentitemcode'] == '',
              orElse: () => variants.first,
            );

            selectedMetalStamp = parentVariant['metal_stamp']?['paraname'] ?? '14k';
            selectedMetalType = parentVariant['metal_type']?['paraname'] ?? 'Yellow Gold';

            // Set initial color state
            goldcolor = selectedMetalType == 'Yellow Gold';
            rosegoldcolor = selectedMetalType == 'Rose Gold';
            graycolor = selectedMetalType == 'White Gold';

            initialized = true;
          }

          // Get unique metal stamps
          final metalStamps = <String>{};
          for (var variant in variants) {
            if (variant['metal_stamp'] != null && variant['metal_stamp']['paraname'] != null) {
              metalStamps.add(variant['metal_stamp']['paraname']);
            }
          }

          // Sort metal stamps (9k, 10k, 14k, 18k)
          final uniqueMetalStamps = metalStamps.toList()..sort((a, b) {
              final aVal = int.tryParse(a.replaceAll('k', '')) ?? 0;
              final bVal = int.tryParse(b.replaceAll('k', '')) ?? 0;
              return aVal.compareTo(bVal);
            });

          // Get available colors for selected metal stamp
          final availableColors = <String, bool>{
            'Yellow Gold': false,
            'Rose Gold': false,
            'White Gold': false,
          };

          for (var variant in variants) {
            if (variant['metal_stamp']?['paraname'] == selectedMetalStamp && variant['metal_type']?['paraname'] != null) {
              availableColors[variant['metal_type']['paraname']] = true;
            }
          }

          // Find current variant based on selections
          Map<String, dynamic>? currentVariant;
          for (var variant in variants) {
            if (variant['metal_stamp']?['paraname'] == selectedMetalStamp && variant['metal_type']?['paraname'] == selectedMetalType) {
              currentVariant = variant;
              break;
            }
          }

          final diamondQualities = <String>[];
          final diamondQualityMap = <String, Map<String, dynamic>>{};

          for (var variant in variants) {
            if (variant['metal_stamp']?['paraname'] == selectedMetalStamp
                && variant['metal_type']?['paraname'] == selectedMetalType
                && variant['jewelry_diamonds'] != null
                && variant['jewelry_diamonds'].isNotEmpty) {
              final diamond = variant['jewelry_diamonds'][0];
              final quality = '${diamond['color']} ${diamond['clarity']}';
              if (!diamondQualityMap.containsKey(quality)) {
                diamondQualities.add(quality);
                diamondQualityMap[quality] = variant;
              }
            }
          }
           final totaldiamonds =  currentVariant?['jewelry_diamonds']?[0]?['totaldiamonds'].toString();
           final totalweight = currentVariant?['jewelry_diamonds']?[0]?['totalweight'].toString();

           // Get values and safely parse them to double
           final double goldPrice = double.tryParse(currentVariant?['sync_metal_price']?.toString() ?? '0') ?? 0.0;
           final double makingCharge = double.tryParse(currentVariant?['sync_labour_charge_price']?.toString() ?? '0') ?? 0.0;
           final double diamondPrice = double.tryParse(currentVariant?['sync_dia_price']?.toString() ?? '0') ?? 0.0;

           // Calculate total
          final double total = goldPrice + makingCharge + diamondPrice;

          // Format values
          final goldPrices = '₹ ${NumberFormat('#,##0.00', 'en_IN').format(goldPrice)}';
          final makingChargs = '₹ ${NumberFormat('#,##0.00', 'en_IN').format(makingCharge)}';
          final diamoinds = '₹ ${NumberFormat('#,##0.00', 'en_IN').format(diamondPrice)}';
          final totals = '₹ ${NumberFormat('#,##0.00', 'en_IN').format(total)}';

          // Custom sorting for diamond qualities
diamondQualities.sort((a, b) {
  // Define the order of diamond colors from best to worst
  const colorOrder = ['EF', 'F', 'FG', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];

  // Define the order of diamond clarities from best to worst
  const clarityOrder = ['FL', 'IF', 'VVS1', 'VVS2', 'VS1', 'VS2', 'SI1', 'SI2', 'I1', 'I2', 'I3'];

  // Extract color and clarity from quality strings
  final aParts = a.split(' ');
  final bParts = b.split(' ');

  if (aParts.length < 2 || bParts.length < 2) return 0;

  final aColor = aParts[0];
  final bColor = bParts[0];
  final aClarity = aParts[1];
  final bClarity = bParts[1];

  // Compare colors first
  final colorIndexA = colorOrder.indexOf(aColor);
  final colorIndexB = colorOrder.indexOf(bColor);

  if (colorIndexA != colorIndexB) {
    // Lower index means better quality
    return colorIndexA.compareTo(colorIndexB);
  }

  // If colors are same, compare clarities
  final clarityIndexA = clarityOrder.indexOf(aClarity);
  final clarityIndexB = clarityOrder.indexOf(bClarity);

  return clarityIndexA.compareTo(clarityIndexB);
});

          // Fallback to first variant if none found
          currentVariant ??= variants.isNotEmpty ? variants.first : null;

          // Use current variant for display
          final diamondList = currentVariant?['jewelry_diamonds'] ?? [];
          final allImages = currentVariant?['allImages'] ?? [];
          final video = currentVariant?['video'] ?? [];


           final list = recommendedjewellerylist.data['data'];

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height / 80),

                  // Image Gallery Section
                  horizontalpadding(
                    child: Container(
                      height: video.isNotEmpty ? Get.height / 2 : null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                        border: Border.all(color: AppColor.textfild_color),
                      ),
                      child: selectindex < allImages.length
                          ? Image.network(allImages[selectindex]['feature'], fit: BoxFit.cover)
                          : (video.isNotEmpty ? horizontalpadding(child: VideoPlayerMenu(videoUrl: video[0]['path'])) : Placeholder()),
                    ),
                  ),
                  SizedBox(height: Get.height / 80),

                  // Thumbnail List
                  SizedBox(
                    height: Get.height * 0.11,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: allImages.length + video.length,
                      itemBuilder: (context, index) {
                        if (index < allImages.length) {
                          return GestureDetector(
                            onTap: () => setState(() => selectindex = index),
                            child: Container(
                              width: Get.width / 4.5,
                              margin: EdgeInsets.only(left: Get.width / 25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                                border: Border.all(color: AppColor.textfild_color),
                                image: DecorationImage(
                                  image: NetworkImage(allImages[index]['feature']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          final videoIndex = index - allImages.length;
                          return GestureDetector(
                            onTap: () => setState(() => selectindex = allImages.length + videoIndex),
                            child: Container(
                              width: Get.width / 4.5,
                              margin: EdgeInsets.only(right: Get.width / 50,left: Get.width / 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                                  border: Border.all(color: AppColor.textfild_color),
                              ),
                              // child: Center(child: VideoPlayerMenu(videoUrl: video[0]['path'])),
                              child: Center(child: Icon(Icons.record_voice_over)),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Product Details
                  horizontalpadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height / 50),

                        Text(currentVariant?['title'] ?? 'Product Title', style: TextStyle(fontFamily: 'Lora', fontSize: Get.width * 0.045)),
                        SizedBox(height: Get.width / 50),
                        Text('SKU: ${currentVariant?['itemcode'] ?? 'N/A'}', style: TextStyle(fontSize: Get.width * 0.040, color: AppColor.grey_color)),
                        SizedBox(height: Get.width / 50),
                    
                        // Price
                        Row(
                          children: [
                            Text('₹${currentVariant?['setting_price']?.toString() ?? '0'}.00', style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w600, fontSize: Get.width * 0.045)),
                            SizedBox(width: Get.width / 150),
                            Text("(inclusive of all taxes)", style: TextStyle(color: AppColor.grey_color)),
                          ],
                        ),
                    
                        SizedBox(height: Get.height / 50),
                    
                    
                        // Metal Stamp Selection
                        Row(
                          children: [
                            Text('Metal:', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                            SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: uniqueMetalStamps.length,
                                  itemBuilder: (context, index) {
                                    final stamp = uniqueMetalStamps[index];
                                    final isSelected = selectedMetalStamp == stamp;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedMetalStamp = stamp;
                                          goldcolor = false;
                                          rosegoldcolor = false;
                                          graycolor = false;

                                          // Find first available color for this stamp
                                          for (var variant in variants) {
                                            if (variant['metal_stamp']?['paraname'] == stamp) {
                                              final type = variant['metal_type']?['paraname'];
                                              if (type == 'Yellow Gold') goldcolor = true;
                                              if (type == 'Rose Gold') rosegoldcolor = true;
                                              if (type == 'White Gold') graycolor = true;
                                              if (type != null) {selectedMetalType = type;
                                                break;
                                              }
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: isSelected ? Colors.amber : AppColor.textfild_color),
                                          color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.transparent,
                                        ),
                                        child: Text(
                                          stamp,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Get.width / 30,
                                            color: isSelected ? Colors.amber : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:Get.height / 50),
                    
                        // Color Selection
                        Row(
                          children: [
                            Text('Color:', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                            SizedBox(width: 10),
                            if (availableColors['Yellow Gold']!) ...[
                              _buildColorButton(
                                border: BoxBorder.all(color: AppColor.glodcolor),
                                color: AppColor.glodcolor,
                                isSelected: goldcolor,
                                onTap: () => setState(() {
                                  goldcolor = true;
                                  rosegoldcolor = false;
                                  graycolor = false;
                                  selectedMetalType = 'Yellow Gold';
                                }),
                              ),
                              SizedBox(width: Get.width / 80),
                            ],
                            if (availableColors['Rose Gold']!) ...[
                              _buildColorButton(
                                border: BoxBorder.all(color: AppColor.rosegoldcolor),
                                color: AppColor.rosegoldcolor,
                                isSelected: rosegoldcolor,
                                onTap: () => setState(() {
                                  rosegoldcolor = true;
                                  goldcolor = false;
                                  graycolor = false;
                                  selectedMetalType = 'Rose Gold';
                                }),
                              ),
                              SizedBox(width: Get.width / 80),
                            ],
                            if (availableColors['White Gold']!) ...[
                              _buildColorButton(
                                border: BoxBorder.all(color: AppColor.graycolor),
                                color: AppColor.graycolor,
                                isSelected: graycolor,
                                onTap: () => setState(() {
                                  graycolor = true;
                                  goldcolor = false;
                                  rosegoldcolor = false;
                                  selectedMetalType = 'White Gold';
                                }),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height:Get.height / 50),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                             children: [
                               Text('Shape :', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                               SizedBox(width: Get.width / 50),
                               Row(
                                 children: diamondList.map<Widget>((diamond) {
                                   return Container(
                                     margin: EdgeInsets.only(right: 10),
                                     decoration: BoxDecoration(
                                       border: Border.all(color: AppColor.textfild_color),
                                       borderRadius: BorderRadius.circular(Get.width / 50),
                                     ),
                                     padding: EdgeInsets.all(10),
                                     child: Image.network(diamond['shape']['image'], width: 40, height: 40, fit: BoxFit.contain),
                                   );
                                 }).toList(),
                               ),
                             ],
                           ),
                        ),
                        SizedBox(height:Get.height / 50),

                        Row(
                          children: [
                            Text('Carat Weight : ', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                            SizedBox(width: Get.width / 50),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.textfild_color),
                                borderRadius: BorderRadiusDirectional.circular(Get.width / 100),
                              ),
                              child: Text(currentVariant!['total_carat'].toString()),
                            ),
                          ],
                        ),
                        SizedBox(height:Get.height / 50),
                    
                        // Ring Size
                        (allRingSizes.isNotEmpty) ?  Row(
                          children: [
                            Text('Ring Size:', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                            SizedBox(width: Get.width / 50),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.textfild_color),
                                borderRadius: BorderRadius.circular(8)),
                              child: DropdownButton<String>(
                                menuMaxHeight: Get.height /5,
                                borderRadius: BorderRadius.circular(Get.width / 50),
                                value: selectedRingSize,
                                items: allRingSizes.map<DropdownMenuItem<String>>((ring) {
                                  return DropdownMenuItem<String>(
                                    value: ring['paraname']?.toString() ?? '',
                                    child: Text(ring['paraname']?.toString() ?? ''),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRingSize = value;
                                  });
                                  },
                                underline: SizedBox(),
                                icon: SizedBox()
                              ),
                            ),
                            SizedBox(width: Get.width / 50),
                            Text('Find Ring Size'),
                          ]) : SizedBox(),
                        SizedBox(height: Get.height / 50),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Diamond Quality:', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                            SizedBox(height: Get.height / 150),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: diamondQualities.length,
                                itemBuilder: (context, index) {
                                  final quality = diamondQualities[index];
                                  final isSelected = selectedDiamondQuality == quality;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDiamondQuality = quality;
                                      });
                                      },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: isSelected ? Colors.amber : AppColor.textfild_color),
                                        color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.transparent,
                                      ),
                                      child: Text(quality, style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width / 30, color: isSelected ? Colors.amber : Colors.black)),
                                    ),
                                  );},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height / 50),

                        Text(currentVariant['description'],style: TextStyle(color: AppColor.grey_color,fontSize: Get.width * 0.035)),
                        SizedBox(height: Get.height / 50),

                         //Product Details
                        GestureDetector(
                           onTap: () {
                             setState(() {
                                productdetails = !productdetails;
                             });
                             },
                           child: AnimatedContainer(
                             duration: Duration(milliseconds: 300),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       'Product details',
                                       style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                     ),
                                     Text(
                                       productdetails ? '-' : '+',
                                       style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                     ),
                                   ],
                                 ),
                                 AnimatedCrossFade(
                                   firstChild: SizedBox.shrink(),
                                   secondChild: Column(
                                     children: [
                                       SizedBox(height: 8),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text('Product Code :', style: TextStyle(color: AppColor.grey_color)),
                                           Text(currentVariant['itemcode'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                         ],
                                       ),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text('Category :', style: TextStyle(color: AppColor.grey_color)),
                                           Text(currentVariant['metal_type']?['slug'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                         ],
                                       ),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text('Product Weight(apx) :', style: TextStyle(color: AppColor.grey_color)),
                                           Text("${currentVariant['metalweight'].toString()} gram", style: TextStyle(color: AppColor.grey_color)),
                                         ],
                                       ),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text('Diamond Weight(apx) :', style: TextStyle(color: AppColor.grey_color)),
                                           Text(currentVariant['total_carat'].toString(),style: TextStyle(color: AppColor.grey_color)),
                                         ],
                                       ),
                                     ],
                                   ),
                                   crossFadeState: productdetails ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                   duration: Duration(milliseconds: 300),
                                 ),
                               ],
                             ),
                           ),
                         ),
                        SizedBox(height: Get.height / 150),

                        //Side Diamond Details
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sidediamondDetails = !sidediamondDetails;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Side Diamond Details',
                                      style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      sidediamondDetails ? '-' : '+',
                                      style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                AnimatedCrossFade(
                                  firstChild: SizedBox.shrink(),
                                  secondChild: Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Color :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(currentVariant['jewelry_diamonds']?[0]?['color'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Clarity :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(currentVariant['jewelry_diamonds']?[0]?['clarity'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Shape :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(currentVariant['jewelry_diamonds']?[0]?['shape']?['paraname'], style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Pieces :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(totaldiamonds!,style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Weight :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(totalweight!,style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  crossFadeState: sidediamondDetails ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 300),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 150),

                        //Center Diamond Details
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              centerdiamondDetails = !centerdiamondDetails;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Center Diamond Details',
                                      style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      centerdiamondDetails ? '-' : '+',
                                      style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                AnimatedCrossFade(
                                  firstChild: SizedBox.shrink(),
                                  secondChild: Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Shape :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(currentVariant['jewelry_diamonds']?[0]?['shape']?['paraname'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Color :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(currentVariant['jewelry_diamonds']?[0]?['color'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Clarity :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(currentVariant['jewelry_diamonds']?[0]?['clarity'], style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Pieces :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(totaldiamonds,style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Weight :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(totalweight,style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  crossFadeState: centerdiamondDetails ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 300),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 150),

                        //Price Breakup
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              priceBreakup = !priceBreakup;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price Breakup',
                                      style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      priceBreakup ? '-' : '+',
                                      style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                AnimatedCrossFade(
                                  firstChild: SizedBox.shrink(),
                                  secondChild: Column(
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Gold Price :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(goldPrices, style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Making Charges :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(makingChargs, style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Diamond Price :', style: TextStyle(color: AppColor.grey_color)),
                                          Text(diamoinds, style: TextStyle(color: AppColor.grey_color)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total :', style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 27,fontWeight: FontWeight.w600)),
                                          Text(totals, style: TextStyle(color: AppColor.grey_color,fontSize: Get.width / 27,fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  crossFadeState: priceBreakup ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 300),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 50),
                        Divider(color: AppColor.textfild_color),
                        SizedBox(height: Get.height / 50),

                        Row(
                          children: [
                            SvgPicture.asset(AppIcon.support,color: AppColor.graycolor,width: 28),
                            SizedBox(width: Get.width / 30),
                            Text('24 / 7 Customer Service Live Chat',style: TextStyle(fontSize: Get.width / 28)),
                          ],
                        ),
                        SizedBox(height: Get.height / 150),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcon.mobileIcon,color: AppColor.graycolor,width: 28),
                            SizedBox(width: Get.width / 30),
                            SizedBox(
                              width: Get.width / 1.3,
                                child: Text('Call us at +917851005200 (9:30 AM to 8:00 PM)',style: TextStyle(fontSize: Get.width / 28))),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(AppIcon.mail,color: AppColor.graycolor,width: 28),
                            SizedBox(width: Get.width / 30),
                            Text('Have a question? Send us an email',style: TextStyle(fontSize: Get.width / 28)),
                          ],
                        ),
                        SizedBox(height: Get.height / 50),
                        Divider(color: AppColor.textfild_color),
                        SizedBox(height: Get.height / 50),

                        Text(AppString.headingMade,style: TextStyle(fontFamily: 'Lora',fontSize: Get.width * 0.045)),
                        SizedBox(height: Get.height / 150),
                        Text(AppString.conceptMade, style: TextStyle(fontSize: Get.width * 0.035, color: AppColor.grey_color)),
                        SizedBox(height: Get.height / 50),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.showcontainercolor,
                            borderRadius: BorderRadius.circular(Get.width / 80),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  SvgPicture.asset(AppIcon.puzzle,color: AppColor.graycolor,width: 50),
                                  SizedBox(height: Get.height / 80),
                                  Text(textAlign: TextAlign.center, 'Ethical\nSourcing',style: TextStyle(fontSize: Get.width / 28,color: AppColor.grey_color)),
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.asset(AppIcon.warranty,color: AppColor.graycolor,width: 50),
                                  SizedBox(height: Get.height / 80),
                                  Text(textAlign: TextAlign.center, 'Lifetime\nWarranty',style: TextStyle(fontSize: Get.width / 28,color: AppColor.grey_color)),
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.asset(AppIcon.social,color: AppColor.graycolor,width: 50),
                                  SizedBox(height: Get.height / 80),
                                  Text(textAlign: TextAlign.center, 'IGI Certified\nDiamonds',style: TextStyle(fontSize: Get.width / 28,color: AppColor.grey_color)),
                                ],
                              ),
                              Column(
                                children: [
                                  SvgPicture.asset(AppIcon.diamond,color: AppColor.graycolor,width: 50),
                                  SizedBox(height: Get.height / 80),
                                  Text(textAlign: TextAlign.center, 'BIS\nHallmark',style: TextStyle(fontSize: Get.width / 28,color: AppColor.grey_color)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height / 50),

                        Text(AppString.youMay,style: TextStyle(fontFamily: 'Lora',fontSize: Get.width * 0.045)),
                        SizedBox(height: Get.height / 80),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.2,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        final recommended = list[index];
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: Get.width / 25),
                              padding: EdgeInsets.all(70),
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(recommended['second_image'],scale: 15),fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(Get.width / 50),
                              ),
                            ),
                            SizedBox(height: Get.height / 150),
                            SizedBox(
                              width: Get.width / 2.9,
                              child: Text(textAlign: TextAlign.center, recommended['title'],style: TextStyle(color:AppColor.grey_color)),
                            ),
                          ],
                        );
                      },),
                  ),
                  SizedBox(height: Get.height / 80),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildColorButton({
  required Color color,
  required bool isSelected,
  required VoidCallback onTap, required BoxBorder border,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? border : null,
      ),
      child: CircleAvatar(backgroundColor: color, radius: 16),
    ),
  );
}
