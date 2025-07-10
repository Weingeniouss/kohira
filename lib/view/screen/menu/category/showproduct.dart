// ignore_for_file: avoid_print, unused_local_variable, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/category/jewelleryDetail.dart' show JewellerydetailCall;
import 'package:kohira/controller/API/menu/category/recommendedJewelleryList.dart';
import 'package:kohira/controller/database/local/localstore.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/appconstants.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/video.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controller/API/menu/category/addtocart.dart';
import '../../../../controller/API/menu/category/wishlist.dart';
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
  Map<String, dynamic>? selectedShape;
  bool goldcolor = false;
  bool rosegoldcolor = false;
  bool graycolor = false;
  bool initialized = false;

  bool diamondQualityInitialized = false;
  List<String> diamondQualities = ['FG VVS', 'EF IF', 'G VS', 'H SI'];
  String? selectedDiamondQuality;

  bool productdetails = false;
  bool centerdiamondDetails = false;
  bool sidediamondDetails = false;
  bool priceBreakup = false;

  final jewellerydetail = Get.put(JewellerydetailCall());
  final recommendedjewellerylist = Get.put(Recommendedjewellerylist());
  final wishlist = Get.put(Wishlist());

  List<String> savewishlist = [];
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    loadJewelleryDetails();
  }

  Future<void> loadJewelleryDetails() async {
    await jewellerydetail.jewellerydetailservices(slug: widget.slug);
    await recommendedjewellerylist.recommendedjewellerylistFuction(slug: widget.slug);

    final jewellery = jewellerydetail.data['data'];
    if (jewellery != null) {
      final String storageKey = jewellery['id'].toString();
      List<String> loadedList = pref!.getStringList(storageKey) ?? [];

      setState(() {
        savewishlist = loadedList;
        isWishlisted = loadedList.contains(storageKey);
      });

      print('Loaded wishlist: $loadedList');
    } else {
      print("Error: jewellerydetail.data['data'] is null");
    }
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
          final jewellery = jewellerydetail.data['data'];
          final allRingSizes = jewellery['allRingSize'] ?? [];

          int selectedIndex = 0;

          return Container(
            height: Get.height * 0.070,
            color: AppColor.white_color,
            child: horizontalpadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                       if (Addtocart().isLoading.value) {
                         Get.dialog(Center(child: Lottie.asset(AppJson.loading2)));
                       } else {
                         Addtocart().addtocartservice(
                           jewelryid: jewellery['id'].toString(),
                           ringsize: selectedRingSize,
                           tokan: tokans,
                          );
                        }
                      },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.12, vertical: Get.height * 0.015),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Get.width / 50),
                        color: Colors.black,
                      ),
                      child: Text('Add To Cart', style: TextStyle(color: AppColor.white_color)),
                    ),
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isDialogOpen != true) {
                Get.dialog(
                  Center(child: Lottie.asset(AppJson.loading2)),
                  barrierDismissible: false,
                );
              }
            });
            return Scaffold(backgroundColor: Colors.transparent);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isDialogOpen == true) {  // Explicit null check
                Get.back();
              }
            });

            final jewellery = jewellerydetail.data['data'];
            final variants = jewellery['variants'] ?? [];
            final allRingSizes = jewellery['allRingSize'] ?? [];

            // Initialize selections
            if (!initialized && variants.isNotEmpty) {
              final defaultSize = allRingSizes.firstWhere((element) => element['default'] == 1, orElse: () => allRingSizes.isNotEmpty ? allRingSizes[0] : null);

              selectedRingSize = defaultSize != null ? defaultSize['paraname'] : null;

              // Find parent variant (default selection)
              final parentVariant = variants.firstWhere((v) => v['parentitemcode'] == '', orElse: () => variants.first);

              selectedMetalStamp = parentVariant['metal_stamp']?['paraname'] ?? '14k';
              selectedMetalType = parentVariant['metal_type']?['paraname'] ?? 'Yellow Gold';
              if (parentVariant['jewelry_diamonds'] != null && parentVariant['jewelry_diamonds'].isNotEmpty) {
                selectedShape = parentVariant['jewelry_diamonds'][0]['shape'];
              }

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

            final diamondQualitySet = <String>{};
            final diamondQualityMap = <String, Map<String, dynamic>>{};

            for (var variant in variants) {
              if (variant['metal_stamp']?['paraname'] == selectedMetalStamp && variant['metal_type']?['paraname'] == selectedMetalType && variant['jewelry_diamonds'] != null && variant['jewelry_diamonds'].isNotEmpty) {
                final diamond = variant['jewelry_diamonds'][0];
                final color = diamond['color'] as String;
                final clarity = diamond['clarity'] as String;
                final quality = '$color $clarity';

                // Only add if we haven't seen this quality before
                if (!diamondQualitySet.contains(quality)) {
                  diamondQualitySet.add(quality);
                  diamondQualityMap[quality] = variant;
                }
              }
            }

            final totaldiamonds =  currentVariant?['jewelry_diamonds']?[0]?['totaldiamonds'].toString();
            final totalweight = currentVariant?['jewelry_diamonds']?[0]?['totalweight'].toString();

            // Custom sorting for diamond qualities
            List<String> diamondQualities = diamondQualitySet.toList();
            diamondQualities.sort((a, b) {
              const colorOrder = ['EF', 'F', 'FG', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];
              const clarityOrder = ['FL', 'IF', 'VVS', 'VS', 'SI', 'I'];

              String normalizeClarity(String clarity) {
                if (clarity.startsWith('VVS')) return 'VVS';
                if (clarity.startsWith('VS')) return 'VS';
                if (clarity.startsWith('SI')) return 'SI';
                if (clarity.startsWith('I')) return 'I';
                return clarity;
              }

              final aParts = a.split(' ');
              final bParts = b.split(' ');

              if (aParts.length < 2 || bParts.length < 2) return 0;

              final aColor = aParts[0];
              final bColor = bParts[0];
              final aClarity = normalizeClarity(aParts[1]);
              final bClarity = normalizeClarity(bParts[1]);

              final colorIndexA = colorOrder.indexOf(aColor);
              final colorIndexB = colorOrder.indexOf(bColor);

              if (colorIndexA != colorIndexB) {
                return colorIndexA.compareTo(colorIndexB);
              }

              final clarityIndexA = clarityOrder.indexOf(aClarity);
              final clarityIndexB = clarityOrder.indexOf(bClarity);

              return clarityIndexA.compareTo(clarityIndexB);
            });

            if (!diamondQualityInitialized && diamondQualities.isNotEmpty) {
              selectedDiamondQuality = diamondQualities.contains('FG VVS')
                  ? 'FG VVS'
                  : diamondQualities.first;
              diamondQualityInitialized = true;
            }

            // 3. Filter variants by selected diamond quality
            List<Map<String, dynamic>> filteredVariants = [];
            Set<String> seenVariants = Set();

            for (var variant in variants) {
              if (variant['jewelry_diamonds'] == null || variant['jewelry_diamonds'].isEmpty) continue;

              final diamond = variant['jewelry_diamonds'][0];
              final quality = '${diamond['color']} ${diamond['clarity']}';

              // Check if quality matches and we haven't added a similar variant
              if (quality == selectedDiamondQuality) {
                final variantKey = '${variant['metal_type']?['paraname']}-${variant['metal_stamp']?['paraname']}';

                if (!seenVariants.contains(variantKey)) {
                  seenVariants.add(variantKey);
                  filteredVariants.add(variant);
                }
              }
            }

            for (var variant in filteredVariants) {
              if (variant['metal_stamp']?['paraname'] == selectedMetalStamp && variant['metal_type']?['paraname'] == selectedMetalType && variant['jewelry_ring_size']?['paraname'] == selectedRingSize) {
                currentVariant = variant;
                break;
              }
            }

            if (currentVariant == null && filteredVariants.isNotEmpty) {
              currentVariant = filteredVariants.first;
            }

            List<Map<String, dynamic>> getUniqueShapes(List variants, String diamondType) {
              List<Map<String, dynamic>> uniqueShapes = [];
              Set<int> shapeIds = {};

              for (var variant in variants) {
                if (variant['jewelry_diamonds'] is List) {
                  for (var diamond in variant['jewelry_diamonds']) {
                    if (diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase() &&
                        diamond['shape'] is Map &&
                        !shapeIds.contains(diamond['shape']['id'])) {
                      shapeIds.add(diamond['shape']['id']);
                      uniqueShapes.add(diamond['shape']);
                    }
                  }
                }
              }
              return uniqueShapes;
            }

            void filterVariantsByShape(Map<String, dynamic> shape) {
              setState(() {
                selectedShape = shape;
                // Find first variant that matches shape + metal type/stamp
                currentVariant = variants.firstWhere((variant) {
                    bool matchesMetal = variant['metal_stamp']?['paraname'] == selectedMetalStamp;
                    bool matchesType = variant['metal_type']?['paraname'] == selectedMetalType;
                    bool matchesShape = variant['jewelry_diamonds'].any((diamond) => diamond['diamondtype']?.toLowerCase() == 'center' && diamond['shape']['id'] == shape['id']);
                    return matchesMetal && matchesType && matchesShape;
                  },
                  orElse: () => variants.firstWhere((variant) => variant['jewelry_diamonds'].any((diamond) => diamond['diamondtype']?.toLowerCase() == 'center' && diamond['shape']['id'] == shape['id']),
                    orElse: () => variants.first,
                  ),
                );

                // Update diamond quality selection using only the center diamond
                if (currentVariant?['jewelry_diamonds'] != null) {
                  final diamond = currentVariant!['jewelry_diamonds'].firstWhere((d) => d['diamondtype']?.toLowerCase() == 'center',
                    orElse: () => null,
                  );

                  if (diamond != null) {
                    selectedDiamondQuality = '${diamond['color']} ${diamond['clarity']}';
                  }
                }
              });
            }

            // Update diamond quality selection
            if (currentVariant?['jewelry_diamonds'] != null && currentVariant!['jewelry_diamonds'].isNotEmpty) {
              final diamond = currentVariant!['jewelry_diamonds'][0];
              selectedDiamondQuality = '${diamond['color']} ${diamond['clarity']}';
            }

            final uniqueCarats = variants.map((v) {
              // Safely handle null values
              final carat = v['total_carat'];
              if (carat == null) return null;
              if (carat is double) return carat;
              if (carat is int) return carat.toDouble();
              if (carat is String) return double.tryParse(carat);
              return null;
            }).whereType<double>().toSet().toList()..sort();

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

            // Fallback to first variant if none found
            currentVariant ??= variants.isNotEmpty ? variants.first : null;

            // Use current variant for display
            final diamondList = currentVariant?['jewelry_diamonds'] ?? [];
            final allImages = currentVariant?['allImages'] ?? [];
            final video = currentVariant?['video'] ?? [];

            final list = recommendedjewellerylist.data['data'];
            String selectedDiamondType = 'center';
            final uniqueShapes = getUniqueShapes(variants, selectedDiamondType);

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
                            : (video.isNotEmpty ? horizontalpadding(child: VideoPlayerMenuContainer(videoUrl: video[0]['path']))
                            : Placeholder()),
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
                                child: Center(child: VideoPlayerMenuContainer(videoUrl: video[0]['path'])),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: Get.width / 1.5, child: Text(currentVariant?['title'] ?? 'Product Title', style: TextStyle(fontFamily: 'Lora', fontSize: Get.width * 0.045))),
                                  SizedBox(height: Get.width / 50),
                                  SizedBox(width: Get.width / 1.5,child: Text('SKU: ${currentVariant?['itemcode'] ?? 'N/A'}', style: TextStyle(fontSize: Get.width * 0.040, color: AppColor.grey_color))),
                                  SizedBox(height: Get.width / 50),
                                ],
                              ),
                              SizedBox(width: Get.width / 10),
                              GestureDetector(
                                onTap: () async {
                                  if (wishlist.isLoading.value) {
                                    Get.dialog(Center(child: Lottie.asset(AppJson.loading2)), barrierDismissible: false);
                                  } else {
                                    await wishlist.wishlistservice(
                                      ringsize: selectedRingSize,
                                      jewelryid: jewellery['id'].toString(),
                                      tokan: tokans,
                                    );

                                    final String storageKey = jewellery['id'].toString();
                                      localdatabase().saveToWishlist(storageKey);
                                    }
                                },
                                child: (isWishlisted)
                                    ? SvgPicture.asset(AppIcon.heart,width: 30,height: 30,color: AppColor.pink_color)
                                    : SvgPicture.asset(AppIcon.like,width: 30,height: 30),
                              ),
                              SizedBox(width: Get.width / 80),
                            ],
                          ),

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
                              SizedBox(width: Get.width / 50),
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

                          (uniqueShapes.isEmpty) ?  SizedBox() : Row(
                            children: [
                              Text('Shape:', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                              SizedBox(width: Get.width / 50),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: uniqueShapes.map((shape) {
                                      bool isSelected = selectedShape != null && selectedShape!['id'] == shape['id'];
                                      return GestureDetector(
                                        onTap: () => filterVariantsByShape(shape),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: isSelected ? Colors.amber : Colors.grey, width: isSelected ? 2 : 1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Image.network(shape['image'], width: 40, height: 40),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:Get.height / 50),

                          (uniqueCarats.isNotEmpty) ?  Row(
                            children: [
                              Text('Carat Weight : ', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                              SizedBox(width: Get.width / 50),
                              SizedBox(
                                height: Get.height / 20,
                                child: (uniqueCarats.isEmpty) ? Text('No carat available') : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: uniqueCarats.length,
                                  itemBuilder: (context, index) {
                                    final carat = uniqueCarats[index];
                                    final isSelected = currentVariant?['total_carat'] == carat;

                                    return Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        color: WidgetStatePropertyAll(Colors.amber.withOpacity(0.1)),
                                        label: Text('${carat.toStringAsFixed(3).replaceAll(RegExp(r'\.0+$'), '')} ..ct', style: TextStyle(color: Colors.amber)),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          if (selected) {
                                            final newVariant = variants.firstWhere((v) {
                                              final vCarat = v['total_carat'];
                                              if (vCarat == null) return false;
                                              if (vCarat is double) return vCarat == carat;
                                              if (vCarat is int) return vCarat == carat.toInt();
                                              if (vCarat is String) return double.tryParse(vCarat) == carat;
                                                return false;
                                              },
                                              orElse: () => currentVariant!,
                                            );
                                            setState(() => currentVariant = newVariant);
                                          }
                                        },
                                        backgroundColor: Colors.amber.withOpacity(0.1),
                                        selectedColor: Colors.amber.withOpacity(0.1),
                                        shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.amber : Colors.amber, width: 1.5)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ) : SizedBox(),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                                      setState(() {selectedRingSize = value;});
                                    },
                                    underline: SizedBox(),
                                    icon: SizedBox()
                                ),
                              ),
                              SizedBox(width: Get.width / 50),
                              Text('Find Ring Size'),
                            ],
                          ) : SizedBox(),
                          SizedBox(height: Get.height / 50),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Diamond Quality:', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                              SizedBox(width: Get.width / 40),
                              Expanded(
                                child: SizedBox(
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
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height / 50),

                          Text(currentVariant!['description'],style: TextStyle(color: AppColor.grey_color,fontSize: Get.width * 0.035)),
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
                                      Text('Product details', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                                      Text(productdetails ? '-' : '+', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  AnimatedCrossFade(
                                    firstChild: SizedBox.shrink(),
                                    secondChild: Column(
                                      children: [
                                        SizedBox(height: Get.height / 50),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Product Code :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['itemcode'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Category :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['metal_type']?['slug'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Product Weight(apx) :', style: TextStyle(color: AppColor.grey_color)),
                                            Text("${currentVariant!['metalweight'].toString()} gram", style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Diamond Weight(apx) :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['total_carat'].toString(),style: TextStyle(color: AppColor.grey_color)),
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
                                      Text('Side Diamond Details', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                                      Text(sidediamondDetails ? '-' : '+', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
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
                                            Text(currentVariant!['jewelry_diamonds']?[0]?['color'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Clarity :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['jewelry_diamonds']?[0]?['clarity'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Shape :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['jewelry_diamonds']?[0]?['shape']?['paraname'], style: TextStyle(color: AppColor.grey_color)),
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
                                      Text('Center Diamond Details', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
                                      Text(centerdiamondDetails ? '-' : '+', style: TextStyle(fontSize: Get.width * 0.040, fontWeight: FontWeight.w500)),
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
                                            Text(currentVariant!['jewelry_diamonds']?[0]?['shape']?['paraname'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Color :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['jewelry_diamonds']?[0]?['color'] ?? 'N/A', style: TextStyle(color: AppColor.grey_color)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Clarity :', style: TextStyle(color: AppColor.grey_color)),
                                            Text(currentVariant!['jewelry_diamonds']?[0]?['clarity'], style: TextStyle(color: AppColor.grey_color)),
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

                          (list != null) ? Column(
                            children: [
                              Text(AppString.youMay,style: TextStyle(fontFamily: 'Lora',fontSize: Get.width * 0.045)),
                              SizedBox(height: Get.height / 80),
                            ],
                          ) : SizedBox(),
                        ],
                      ),
                    ),
                    (list != null)? SizedBox(
                      height: Get.height * 0.25, // Adjust overall height responsively
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double imageSize = constraints.maxHeight * 0.65; // 65% of available height
                          double textHeight = constraints.maxHeight * 0.2;  // 20% for text spacing
                          double imageRadius = Get.width / 50;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              final recommended = list[index];
                              return Container(
                                margin: EdgeInsets.only(left: Get.width / 25, right: Get.width / 50),
                                width: Get.width * 0.35, // Make each card take ~35% of width
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: imageSize,
                                      width: imageSize,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(recommended['second_image']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(imageRadius),
                                      ),
                                    ),
                                    SizedBox(height: constraints.maxHeight * 0.05),
                                    SizedBox(
                                      height: textHeight,
                                      child: Text(
                                        recommended['title'],
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: AppColor.grey_color, fontSize: Get.width * 0.03),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ) : SizedBox(),
                    SizedBox(height: Get.height / 80),
                  ],
                ),
              ),
            );  // Replace with your actual content widget
          }
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