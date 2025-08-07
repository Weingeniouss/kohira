import 'package:intl/intl.dart';

class JewelryConfigurationController {
  // Data
  Map<String, dynamic>? jewelryData;
  List<dynamic> variants = [];
  List<dynamic> allRingSizes = [];

  // Selections
  String? selectedMetalStamp;
  String? selectedMetalType;
  String? selectedRingSize;
  String? selectedRingSizeParaname;
  String? selectedRingSizeId;
  String? selectedDiamondQuality;
  Map<String, dynamic>? selectedShape;
  double? selectedCaratWeight;
  String selectedDiamondType = 'center';

  // UI States
  bool goldcolor = false;
  bool rosegoldcolor = false;
  bool graycolor = false;
  bool initialized = false;
  bool diamondQualityInitialized = false;

  // Current variant
  Map<String, dynamic>? currentVariant;

  // Initialize with data
  void initialize(Map<String, dynamic> data) {
    jewelryData = data;
    variants = data['variants'] ?? [];
    allRingSizes = data['allRingSize'] ?? [];

    if (!initialized && variants.isNotEmpty) {
      _initializeDefaultSelections();
      initialized = true;
    }
  }

  void _initializeDefaultSelections() {
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

    if (parentVariant['jewelry_diamonds'] != null && parentVariant['jewelry_diamonds'].isNotEmpty) {
      selectedShape = parentVariant['jewelry_diamonds'][0]['shape'];
    }

    // Set initial color state
    goldcolor = selectedMetalType == 'Yellow Gold';
    rosegoldcolor = selectedMetalType == 'Rose Gold';
    graycolor = selectedMetalType == 'White Gold';

    // Initialize diamond quality
    _initializeDiamondQuality();
  }

  void _initializeDiamondQuality() {
    final diamondQualities = getDiamondQualities();

    if (!diamondQualityInitialized && diamondQualities.isNotEmpty) {
      selectedDiamondQuality = diamondQualities.contains('FG VVS')
          ? 'FG VVS'
          : diamondQualities.first;
      diamondQualityInitialized = true;
    }
  }

  // Get unique metal stamps
  List<String> getMetalStamps() {
    final metalStamps = <String>{};
    for (var variant in variants) {
      if (variant['metal_stamp'] != null && variant['metal_stamp']['paraname'] != null) {
        metalStamps.add(variant['metal_stamp']['paraname']);
      }
    }

    // Sort metal stamps (9k, 10k, 14k, 18k)
    return metalStamps.toList()..sort((a, b) {
      final aVal = int.tryParse(a.replaceAll('k', '')) ?? 0;
      final bVal = int.tryParse(b.replaceAll('k', '')) ?? 0;
      return aVal.compareTo(bVal);
    });
  }

  // Get available colors for selected metal stamp
  Map<String, bool> getAvailableColors() {
    final availableColors = <String, bool>{
      'Yellow Gold': false,
      'Rose Gold': false,
      'White Gold': false,
    };

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp &&
          variant['metal_type']?['paraname'] != null) {
        availableColors[variant['metal_type']['paraname']] = true;
      }
    }

    return availableColors;
  }

  // Update current variant based on selections
  void updateCurrentVariant() {
    // First try to find exact match
    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp &&
          variant['metal_type']?['paraname'] == selectedMetalType) {

        // If we have diamond quality selection, match that too
        if (selectedDiamondQuality != null && variant['jewelry_diamonds'] != null) {
          for (var diamond in variant['jewelry_diamonds']) {
            if ('${diamond['color']} ${diamond['clarity']}' == selectedDiamondQuality) {
              currentVariant = variant;
              return;
            }
          }
        } else {
          currentVariant = variant;
          return;
        }
      }
    }

    // Fallback to first variant if no exact match found
    currentVariant = variants.isNotEmpty ? variants.first : null;
  }

  // Get diamond qualities for current selections
  List<String> getDiamondQualities() {
    final diamondQualitySet = <String>{};

    for (var variant in variants) {
      if (variant['metal_stamp']?['paraname'] == selectedMetalStamp &&
          variant['metal_type']?['paraname'] == selectedMetalType &&
          variant['jewelry_diamonds'] != null &&
          variant['jewelry_diamonds'].isNotEmpty) {

        final diamond = variant['jewelry_diamonds'][0];
        final color = diamond['color'] as String;
        final clarity = diamond['clarity'] as String;
        diamondQualitySet.add('$color $clarity');
      }
    }

    return _sortDiamondQualities(diamondQualitySet.toList());
  }

  List<String> _sortDiamondQualities(List<String> qualities) {
    qualities.sort((a, b) {
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

    return qualities;
  }

  // Get unique shapes
  List<Map<String, dynamic>> getUniqueShapes(String diamondType) {
    List<Map<String, dynamic>> uniqueShapes = [];
    Set<int> shapeIds = {};

    for (var variant in variants) {
      final diamonds = variant['jewelry_diamonds'];
      if (diamonds is List) {
        for (var diamond in diamonds) {
          final typeMatches = (diamond['diamondtype']?.toLowerCase() ?? '') == diamondType.toLowerCase();
          final shapeMap = diamond['shape'];
          if (typeMatches && shapeMap is Map && shapeMap['id'] is int && !shapeIds.contains(shapeMap['id'])) {
            shapeIds.add(shapeMap['id']);
            uniqueShapes.add(Map<String, dynamic>.from(shapeMap));
          }
        }
      }
    }

    return uniqueShapes;
  }

  // Update selected shape
  void updateSelectedShape(Map<String, dynamic>? shape, String diamondType) {
    if (shape == null) return;

    selectedShape = shape;
    selectedDiamondType = diamondType;

    // Find matching variant
    currentVariant = variants.firstWhere((variant) {
      final matchesMetal = variant['metal_stamp']?['paraname'] == selectedMetalStamp;
      final matchesType = variant['metal_type']?['paraname'] == selectedMetalType;

      final hasMatchingShape = (variant['jewelry_diamonds'] as List?)?.any((diamond) {
        return (diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase()) &&
            (diamond['shape']?['id'] == shape['id']);
      }) ?? false;

      return matchesMetal && matchesType && hasMatchingShape;
    }, orElse: () {
      // Fallback: find any variant with matching shape + diamondType
      return variants.firstWhere((variant) {
        return (variant['jewelry_diamonds'] as List?)?.any((diamond) {
          return (diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase()) &&
              (diamond['shape']?['id'] == shape['id']);
        }) ?? false;
      }, orElse: () => variants.first);
    });

    // Update diamond quality
    final centerDiamond = (currentVariant?['jewelry_diamonds'] as List?)?.firstWhere(
          (d) => d['diamondtype']?.toLowerCase() == diamondType.toLowerCase(),
      orElse: () => null,
    );

    if (centerDiamond != null) {
      selectedDiamondQuality = '${centerDiamond['color']} ${centerDiamond['clarity']}';
    }
  }

  // Get unique carats
  List<double> getUniqueCarats({String? diamondType}) {
    final Set<double> seen = {};
    final uniqueCarats = <double>[];

    for (var variant in variants) {
      if (variant is! Map<String, dynamic>) continue;

      if (variant.containsKey('total_carat')) {
        final carat = variant['total_carat'];
        if (carat is num && seen.add(carat.toDouble())) {
          uniqueCarats.add(carat.toDouble());
        }
      }
      else if (diamondType != null && variant.containsKey('jewelry_diamonds')) {
        final diamonds = variant['jewelry_diamonds'];
        if (diamonds is List) {
          for (var diamond in diamonds) {
            if (diamond is Map<String, dynamic> &&
                (diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase())) {
              final carat = diamond['carat'];
              if (carat is num && seen.add(carat.toDouble())) {
                uniqueCarats.add(carat.toDouble());
              }
            }
          }
        }
      }
    }

    uniqueCarats.sort();
    return uniqueCarats;
  }

  // Update selected carat
  void updateSelectedCarat(double? selectedCarat, {String? diamondType}) {
    if (selectedCarat == null) return;

    selectedCaratWeight = selectedCarat;
    Map<String, dynamic>? matchedVariant;

    // Matching strategy
    for (final variant in variants) {
      if (variant is! Map<String, dynamic>) continue;

      double? variantCarat;
      if (diamondType == null) {
        variantCarat = (variant['total_carat'] as num?)?.toDouble();
      } else {
        final diamonds = variant['jewelry_diamonds'] as List?;
        if (diamonds != null) {
          for (var diamond in diamonds) {
            if (diamond is Map<String, dynamic> &&
                diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase()) {
              variantCarat = (diamond['carat'] as num?)?.toDouble();
              break;
            }
          }
        }
      }

      if (variantCarat == null) continue;

      final caratMatch = (variantCarat - selectedCarat).abs() < 0.001;
      if (!caratMatch) continue;

      final variantMetal = variant['metal_type']?['paraname'];
      final variantStamp = variant['metal_stamp']?['paraname'];

      if (variantMetal == selectedMetalType && variantStamp == selectedMetalStamp) {
        matchedVariant = variant;
        break;
      }

      if (matchedVariant == null && variantMetal == selectedMetalType) {
        matchedVariant = variant;
      }

      matchedVariant ??= variant;
    }

    // If no exact match, find closest
    if (matchedVariant == null) {
      double? closestDiff;
      for (final variant in variants) {
        if (variant is! Map<String, dynamic>) continue;

        double? variantCarat;
        if (diamondType == null) {
          variantCarat = (variant['total_carat'] as num?)?.toDouble();
        } else {
          final diamonds = variant['jewelry_diamonds'] as List?;
          if (diamonds != null) {
            for (var diamond in diamonds) {
              if (diamond is Map<String, dynamic> &&
                  diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase()) {
                variantCarat = (diamond['carat'] as num?)?.toDouble();
                break;
              }
            }
          }
        }

        if (variantCarat == null) continue;

        final diff = (variantCarat - selectedCarat).abs();
        if (diff <= 0.1 && (closestDiff == null || diff < closestDiff)) {
          closestDiff = diff;
          matchedVariant = variant;
        }
      }
    }

    currentVariant = matchedVariant ?? variants.first;

    // Update dependent selections
    selectedMetalType = currentVariant?['metal_type']?['paraname'];
    selectedMetalStamp = currentVariant?['metal_stamp']?['paraname'];

    if (diamondType != null) {
      final diamonds = currentVariant?['jewelry_diamonds'] as List?;
      if (diamonds != null) {
        for (var diamond in diamonds) {
          if (diamond is Map<String, dynamic> &&
              diamond['diamondtype']?.toLowerCase() == diamondType.toLowerCase()) {
            selectedDiamondQuality = '${diamond['color']} ${diamond['clarity']}';
            break;
          }
        }
      }
    }
  }

  // Get price breakdown
  Map<String, String> getPriceBreakdown() {
    final double goldPrice = double.tryParse(currentVariant?['sync_metal_price']?.toString() ?? '0') ?? 0.0;
    final double makingCharge = double.tryParse(currentVariant?['sync_labour_charge_price']?.toString() ?? '0') ?? 0.0;
    final double diamondPrice = double.tryParse(currentVariant?['sync_dia_price']?.toString() ?? '0') ?? 0.0;
    final double total = goldPrice + makingCharge + diamondPrice;

    return {
      'goldPrice': '₹ ${NumberFormat('#,##0.00', 'en_IN').format(goldPrice)}',
      'makingCharge': '₹ ${NumberFormat('#,##0.00', 'en_IN').format(makingCharge)}',
      'diamondPrice': '₹ ${NumberFormat('#,##0.00', 'en_IN').format(diamondPrice)}',
      'total': '₹ ${NumberFormat('#,##0.00', 'en_IN').format(total)}',
    };
  }
}