import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../API/menu/category/jewelleryDetail.dart';
import '../../../API/menu/category/recommendedJewelleryList.dart';

class JewelleryDetailController extends GetxController {
  final jewellerydetail = Get.put(JewellerydetailCall());
  final recommendedjewellerylist = Get.put(Recommendedjewellerylist());

  // Reactive variables
  var selectindex = 0.obs;
  @override
  var initialized = false;
  var diamondQualityInitialized = false.obs;
  var selectedRingSize = "".obs;
  var selectedMetalStamp = "14k".obs;
  var selectedMetalType = "Yellow Gold".obs;
  var goldcolor = false.obs;
  var rosegoldcolor = false.obs;
  var graycolor = false.obs;
  var selectedDiamondQuality = "".obs;
  var productdetails = false.obs;
  var sidediamondDetails = false.obs;
  var centerdiamondDetails = false.obs;
  var priceBreakup = false.obs;

  // Computed properties
  Map<String, dynamic> get jewellery => jewellerydetail.data['data'] ?? {};
  List<dynamic> get variants => jewellery['variants'] ?? [];
  List<dynamic> get allRingSizes => jewellery['allRingSize'] ?? [];

  List<String> get uniqueMetalStamps {
    final metalStamps = <String>{};
    for (var variant in variants) {
      if (variant['metal_stamp'] != null &&
          variant['metal_stamp']['paraname'] != null) {
        metalStamps.add(variant['metal_stamp']['paraname']);
      }
    }
    return metalStamps.toList()..sort((a, b) {
      final aVal = int.tryParse(a.replaceAll('k', '')) ?? 0;
      final bVal = int.tryParse(b.replaceAll('k', '')) ?? 0;
      return aVal.compareTo(bVal);
    });
  }

  Map<String, bool> get availableColors {
    final colors = <String, bool>{
      'Yellow Gold': false,
      'Rose Gold': false,
      'White Gold': false,
    };
    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp.value &&
          variant['metal_type']?['paraname'] != null) {
        colors[variant['metal_type']['paraname']] = true;
      }
    }
    return colors;
  }

  Map<String, dynamic>? get currentVariant {
    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp.value &&
          variant['metal_type']?['paraname'] == selectedMetalType.value) {
        return variant;
      }
    }
    return null;
  }

  List<String> get diamondQualities {
    final qualitySet = <String>{};
    final qualityMap = <String, Map<String, dynamic>>{};

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp.value &&
          variant['metal_type']?['paraname'] == selectedMetalType.value &&
          variant['jewelry_diamonds'] != null &&
          variant['jewelry_diamonds'].isNotEmpty) {

        final diamond = variant['jewelry_diamonds'][0];
        final quality = '${diamond['color']} ${diamond['clarity']}';

        if (!qualitySet.contains(quality)) {
          qualitySet.add(quality);
          qualityMap[quality] = variant;
        }
      }
    }

    return qualitySet.toList()..sort(_sortDiamondQualities);
  }

  int _sortDiamondQualities(String a, String b) {
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
  }

  String get formattedTotal {
    final double goldPrice = double.tryParse(currentVariant?['sync_metal_price']?.toString() ?? '0') ?? 0.0;
    final double makingCharge = double.tryParse(currentVariant?['sync_labour_charge_price']?.toString() ?? '0') ?? 0.0;
    final double diamondPrice = double.tryParse(currentVariant?['sync_dia_price']?.toString() ?? '0') ?? 0.0;
    final double total = goldPrice + makingCharge + diamondPrice;
    return '₹ ${NumberFormat('#,##0.00', 'en_IN').format(total)}';
  }

  void initializeSelections() {
    if (!initialized && variants.isNotEmpty) {
      final defaultSize = allRingSizes.firstWhere(
            (element) => element['default'] == 1,
        orElse: () => allRingSizes.isNotEmpty ? allRingSizes[0] : null,
      );

      selectedRingSize.value = defaultSize?['paraname'] ?? "";

      // Find parent variant
      final parentVariant = variants.firstWhere(
            (v) => v['parentitemcode'] == '',
        orElse: () => variants.first,
      );

      selectedMetalStamp.value = parentVariant['metal_stamp']?['paraname'] ?? '14k';
      selectedMetalType.value = parentVariant['metal_type']?['paraname'] ?? 'Yellow Gold';

      goldcolor.value = selectedMetalType.value == 'Yellow Gold';
      rosegoldcolor.value = selectedMetalType.value == 'Rose Gold';
      graycolor.value = selectedMetalType.value == 'White Gold';

      initialized = true;
    }
  }

  void updateMetalSelection(String stamp) {
    selectedMetalStamp.value = stamp;

    // Reset colors and find first available
    goldcolor.value = false;
    rosegoldcolor.value = false;
    graycolor.value = false;

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == stamp) {
        final type = variant['metal_type']?['paraname'];
        if (type == 'Yellow Gold') goldcolor.value = true;
        if (type == 'Rose Gold') rosegoldcolor.value = true;
        if (type == 'White Gold') graycolor.value = true;
        if (type != null) {
          selectedMetalType.value = type;
          break;
        }
      }
    }
  }

  void updateColorSelection(String color) {
    selectedMetalType.value = color;
    goldcolor.value = color == 'Yellow Gold';
    rosegoldcolor.value = color == 'Rose Gold';
    graycolor.value = color == 'White Gold';
  }
}