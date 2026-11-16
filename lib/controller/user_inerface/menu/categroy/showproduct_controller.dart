// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:get/get.dart';
import '../../../../modal/menu/category/subcategory/addtowish.dart';

class ShowproductController extends GetxController {
  var selectindex = 0.obs;

  var selectedRingSize = RxnString();
  var selectedRingSizeParaname = RxnString();
  var selectedRingSizeId = RxnString();
  var selectedMetalStamp = RxnString();
  var selectedMetalType = RxnString();
  var selectedShape = Rxn<Map<String, dynamic>>();
  var selectedDiamondQuality = RxnString();
  var selectedCaratWeight = RxnDouble();

  var goldcolor = false.obs;
  var rosegoldcolor = false.obs;
  var graycolor = false.obs;
  var isInitialized = false.obs;
  var diamondQualityInitialized = false.obs;

  // Wishlist reactive states
  var isWishlistedGuest = false.obs;
  var isWishlisted = false.obs;
  var existingItemsWish = <JewelryItemWish>[].obs;
  var savewishlist = <String>[].obs;

  // Accordion toggle states
  var productdetails = false.obs;
  var centerdiamondDetails = false.obs;
  var metal = false.obs;
  var sidediamondDetails = false.obs;
  var priceBreakup = false.obs;

  void toggleProductDetails() {
    productdetails.value = !productdetails.value;
    sidediamondDetails.value = false;
    centerdiamondDetails.value = false;
    metal.value = false;
    priceBreakup.value = false;
  }

  void toggleSideDiamondDetails() {
    sidediamondDetails.value = !sidediamondDetails.value;
    productdetails.value = false;
    centerdiamondDetails.value = false;
    metal.value = false;
    priceBreakup.value = false;
  }

  void toggleCenterDiamondDetails() {
    centerdiamondDetails.value = !centerdiamondDetails.value;
    sidediamondDetails.value = false;
    productdetails.value = false;
    metal.value = false;
    priceBreakup.value = false;
  }

  void toggleMetal() {
    metal.value = !metal.value;
    sidediamondDetails.value = false;
    centerdiamondDetails.value = false;
    productdetails.value = false;
    priceBreakup.value = false;
  }

  void togglePriceBreakup() {
    priceBreakup.value = !priceBreakup.value;
    metal.value = false;
    sidediamondDetails.value = false;
    centerdiamondDetails.value = false;
    productdetails.value = false;
  }

  void initSelections(Map<String, dynamic> jewellery) {
    if (isInitialized.value) return;

    final variants = jewellery['variants'] as List? ?? [];
    final allRingSizes = jewellery['allRingSize'] as List? ?? [];

    if (variants.isNotEmpty) {
      final defaultSize = allRingSizes.firstWhere(
        (element) => element['default'] == 1,
        orElse: () => allRingSizes.isNotEmpty ? allRingSizes[0] : null,
      );

      selectedRingSize.value =
          defaultSize != null ? defaultSize['paraname']?.toString() : null;

      final parentVariant = variants.firstWhere(
        (v) => v['parentitemcode'] == '',
        orElse: () => variants.first,
      );

      selectedMetalStamp.value =
          parentVariant['metal_stamp']?['paraname']?.toString() ?? '14k';
      selectedMetalType.value =
          parentVariant['metal_type']?['paraname']?.toString() ?? 'Yellow Gold';

      if (parentVariant['jewelry_diamonds'] != null &&
          (parentVariant['jewelry_diamonds'] as List).isNotEmpty) {
        selectedShape.value = parentVariant['jewelry_diamonds'][0]['shape'];
      }

      updateColorState(selectedMetalType.value ?? '');
      isInitialized.value = true;
    }
  }

  void updateColorState(String type) {
    goldcolor.value = type == 'Yellow Gold';
    rosegoldcolor.value = type == 'Rose Gold';
    graycolor.value = type == 'White Gold';
    selectedMetalType.value = type;
  }

  void selectMetalStamp(String stamp, List variants) {
    selectedMetalStamp.value = stamp;
    goldcolor.value = false;
    rosegoldcolor.value = false;
    graycolor.value = false;

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == stamp) {
        final type = variant['metal_type']?['paraname']?.toString();
        if (type != null) {
          updateColorState(type);
          break;
        }
      }
    }
  }

  List<String> getUniqueMetalStamps(List variants) {
    final metalStamps = <String>{};
    for (var variant in variants) {
      if (variant['metal_stamp'] != null &&
          variant['metal_stamp']['paraname'] != null) {
        metalStamps.add(variant['metal_stamp']['paraname'].toString());
      }
    }

    final list = metalStamps.toList()
      ..sort((a, b) {
        final aVal = int.tryParse(a.replaceAll('k', '')) ?? 0;
        final bVal = int.tryParse(b.replaceAll('k', '')) ?? 0;
        return aVal.compareTo(bVal);
      });
    return list;
  }

  Map<String, bool> getAvailableColors(List variants) {
    final availableColors = <String, bool>{
      'Yellow Gold': false,
      'Rose Gold': false,
      'White Gold': false,
    };

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp.value &&
          variant['metal_type']?['paraname'] != null) {
        availableColors[variant['metal_type']['paraname']] = true;
      }
    }
    return availableColors;
  }

  Map<String, dynamic>? getCurrentVariant(List variants) {
    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp.value &&
          variant['metal_type']?['paraname'] == selectedMetalType.value) {
        return variant as Map<String, dynamic>;
      }
    }
    return variants.isNotEmpty ? variants.first as Map<String, dynamic> : null;
  }

  List<String> getDiamondQualities(List variants) {
    final diamondQualitySet = <String>{};

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp.value &&
          variant['metal_type']?['paraname'] == selectedMetalType.value &&
          variant['jewelry_diamonds'] != null &&
          (variant['jewelry_diamonds'] as List).isNotEmpty) {
        final diamond = variant['jewelry_diamonds'][0];
        final color = diamond['color'] as String?;
        final clarity = diamond['clarity'] as String?;
        if (color != null && clarity != null) {
          diamondQualitySet.add('$color $clarity');
        }
      }
    }

    List<String> qualities = diamondQualitySet.toList();
    qualities.sort((a, b) {
      const colorOrder = [
        'EF',
        'F',
        'FG',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N'
      ];
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

    if (!diamondQualityInitialized.value && qualities.isNotEmpty) {
      selectedDiamondQuality.value =
          qualities.contains('FG VVS') ? 'FG VVS' : qualities.first;
      diamondQualityInitialized.value = true;
    }

    return qualities;
  }

  List<Map<String, dynamic>> getUniqueShapes(
      List variants, String diamondType) {
    List<Map<String, dynamic>> uniqueShapes = [];
    Set<int> shapeIds = {};
    for (var variant in variants) {
      final diamonds = variant['jewelry_diamonds'];
      if (diamonds is List) {
        for (var diamond in diamonds) {
          final typeMatches = (diamond['diamondtype']?.toLowerCase() ?? '') ==
              diamondType.toLowerCase();
          final shapeMap = diamond['shape'];
          if (typeMatches &&
              shapeMap is Map &&
              shapeMap['id'] is int &&
              !shapeIds.contains(shapeMap['id'])) {
            shapeIds.add(shapeMap['id']);
            uniqueShapes.add(Map<String, dynamic>.from(shapeMap));
          }
        }
      }
    }
    return uniqueShapes;
  }

  void filterVariantsByShape({
    required Map<String, dynamic>? shape,
    required String diamondType,
    required List variants,
  }) {
    if (shape == null) return;
    selectedShape.value = shape;

    final matched = variants.firstWhere(
      (variant) {
        final matchesMetal =
            variant['metal_stamp']?['paraname'] == selectedMetalStamp.value;
        final matchesType =
            variant['metal_type']?['paraname'] == selectedMetalType.value;

        final hasMatchingShape =
            (variant['jewelry_diamonds'] as List?)?.any((diamond) {
                  return (diamond['diamondtype']?.toLowerCase() ==
                          diamondType.toLowerCase()) &&
                      (diamond['shape']?['id'] == shape['id']);
                }) ??
                false;

        return matchesMetal && matchesType && hasMatchingShape;
      },
      orElse: () {
        return variants.firstWhere(
          (variant) {
            return (variant['jewelry_diamonds'] as List?)?.any((diamond) {
                  return (diamond['diamondtype']?.toLowerCase() ==
                          diamondType.toLowerCase()) &&
                      (diamond['shape']?['id'] == shape['id']);
                }) ??
                false;
          },
          orElse: () => variants.first,
        );
      },
    );

    final centerDiamond = (matched['jewelry_diamonds'] as List?)?.firstWhere(
      (d) => d['diamondtype']?.toLowerCase() == diamondType.toLowerCase(),
      orElse: () => null,
    );

    if (centerDiamond != null &&
        centerDiamond['color'] != null &&
        centerDiamond['clarity'] != null) {
      selectedDiamondQuality.value =
          '${centerDiamond['color']} ${centerDiamond['clarity']}';
    }
  }

  List<double> getUniqueCarats(List variants, {String? diamondType}) {
    final Set<double> seen = {};
    final uniqueCarats = <double>[];

    for (var variant in variants) {
      if (variant is! Map<String, dynamic>) continue;

      num? caratNum;
      if (variant['all_total_carat'] != null &&
          variant['all_total_carat'] is num) {
        caratNum = variant['all_total_carat'] as num;
      } else if (variant['total_carat'] != null &&
          variant['total_carat'] is num) {
        caratNum = variant['total_carat'] as num;
      }

      if (caratNum != null && seen.add(caratNum.toDouble())) {
        uniqueCarats.add(caratNum.toDouble());
      }

      final diamonds = variant['jewelry_diamonds'];
      if (diamonds is List) {
        for (var diamond in diamonds) {
          if (diamond is Map<String, dynamic>) {
            final c = diamond['carat'] ?? diamond['totalweight'];
            if (c is num && c > 0 && seen.add(c.toDouble())) {
              uniqueCarats.add(c.toDouble());
            }
          }
        }
      }
    }

    if (uniqueCarats.isEmpty) {
      return [0.30, 0.50, 0.75, 1.00, 1.50, 2.00, 3.00];
    }

    uniqueCarats.sort();
    return uniqueCarats;
  }

  void filterVariantsByCarat(double? selectedCarat,
      {String? diamondType, required List variants}) {
    if (selectedCarat == null) return;

    selectedCaratWeight.value = selectedCarat;
    Map<String, dynamic>? matchedVariant;

    for (final variant in variants) {
      if (variant is! Map<String, dynamic>) continue;

      double? variantCarat;
      if (variant['all_total_carat'] != null &&
          variant['all_total_carat'] is num) {
        variantCarat = (variant['all_total_carat'] as num).toDouble();
      } else if (variant['total_carat'] != null &&
          variant['total_carat'] is num) {
        variantCarat = (variant['total_carat'] as num).toDouble();
      }

      if (variantCarat == null) continue;

      final caratMatch = (variantCarat - selectedCarat).abs() < 0.001;
      if (!caratMatch) continue;

      final variantMetal = variant['metal_type']?['paraname'];
      final variantStamp = variant['metal_stamp']?['paraname'];

      if (variantMetal == selectedMetalType.value &&
          variantStamp == selectedMetalStamp.value) {
        matchedVariant = variant;
        break;
      }

      if (matchedVariant == null && variantMetal == selectedMetalType.value) {
        matchedVariant = variant;
      }

      matchedVariant ??= variant;
    }

    final finalVariant = matchedVariant ?? variants.first;
    selectedMetalType.value = finalVariant['metal_type']?['paraname'];
    selectedMetalStamp.value = finalVariant['metal_stamp']?['paraname'];
  }

  void resetState() {
    selectindex.value = 0;
    selectedRingSize.value = null;
    selectedRingSizeParaname.value = null;
    selectedRingSizeId.value = null;
    selectedMetalStamp.value = null;
    selectedMetalType.value = null;
    selectedShape.value = null;
    selectedDiamondQuality.value = null;
    selectedCaratWeight.value = null;
    goldcolor.value = false;
    rosegoldcolor.value = false;
    graycolor.value = false;
    isInitialized.value = false;
    diamondQualityInitialized.value = false;
    isWishlistedGuest.value = false;
    isWishlisted.value = false;
    existingItemsWish.clear();
    savewishlist.clear();
    productdetails.value = false;
    centerdiamondDetails.value = false;
    metal.value = false;
    sidediamondDetails.value = false;
    priceBreakup.value = false;
  }
}
