// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import 'package:kohira/view/utils/app_color.dart';

void showFilterBottomSheet(
  BuildContext context, {
  String? category_slug,
  String? subcategory_slug,
  String? subcategrorysname,
  VoidCallback? onApply,
}) {
  final mediaQuery = MediaQuery.of(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    constraints: BoxConstraints(
      maxHeight: mediaQuery.size.height,
      minHeight: mediaQuery.size.height,
    ),
    backgroundColor: Colors.transparent,
    builder: (context) => FilterBottomSheet(
      category_slug: category_slug,
      subcategory_slug: subcategory_slug,
      subcategrorysname: subcategrorysname,
      onApply: onApply,
    ),
  );
}

class FilterBottomSheet extends StatefulWidget {
  final String? category_slug;
  final String? subcategory_slug;
  final String? subcategrorysname;
  final VoidCallback? onApply;

  const FilterBottomSheet({
    super.key,
    this.category_slug,
    this.subcategory_slug,
    this.subcategrorysname,
    this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final filterController = Get.put(FilterController());
  final categoryController = Get.put(JewelleryFilterCategory());
  final jewelleryFilter = Get.put(Jewelleryfilter());

  int selectedTabIndex = 0;

  final List<String> categories = [
    'Category',
    'Sub Category',
    'Metal Stamp',
    'Metal Type',
    'Diamond Type',
    'Price',
    'Weight',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFilterData();
      _initCurrentSelections();
    });
  }

  void _loadFilterData() {
    if (categoryController.filterData.value == null) {
      categoryController.fetchFilter();
    }
    if (jewelleryFilter.data.value == null) {
      jewelleryFilter.fetchJewelleryFilter();
    }
  }

  void _initCurrentSelections() {
    if (widget.category_slug != null &&
        filterController.selectedCategorySlug.value.isEmpty) {
      filterController.selectedCategorySlug.value = widget.category_slug!;
    }
    if (widget.subcategory_slug != null &&
        filterController.selectedSubcategorySlug.value.isEmpty) {
      filterController.selectedSubcategorySlug.value = widget.subcategory_slug!;
    }
    if (widget.subcategrorysname != null &&
        widget.subcategrorysname!.isNotEmpty &&
        filterController.selectedSubcategoryName.value.isEmpty &&
        filterController.selectedCategoryName.value.isEmpty) {
      filterController.selectedSubcategoryName.value =
          widget.subcategrorysname!;
    }
  }

  bool _hasSelectionInTab(int index) {
    switch (index) {
      case 0:
        return filterController.selectedCategorySlug.value.isNotEmpty;
      case 1:
        return filterController.selectedSubcategorySlug.value.isNotEmpty;
      case 2:
        return filterController.metalstapid.value.isNotEmpty;
      case 3:
        return filterController.selectedMetalType.value.isNotEmpty;
      case 4:
        return filterController.diamondtype.value.isNotEmpty;
      case 5:
        return filterController.selectedPrice.value.isNotEmpty;
      case 6:
        return filterController.selectedWeight.value.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header Bar
            SizedBox(height: Get.height * 0.04),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.textfild_color,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.black_color,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    "Filters",
                    style: TextStyle(
                      color: AppColor.pink_color,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lora',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColor.black_color),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Main Body (2 Columns)
            Expanded(
              child: Row(
                children: [
                  // Left Vertical Tab Column
                  Container(
                    width: Get.width * 0.34,
                    color: Color(0xFFFDE8EC),
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isSelected = selectedTabIndex == index;
                          final hasSelection = _hasSelectionInTab(index);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTabIndex = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.pink_color
                                    : Color(0xFFFDE8EC),
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? AppColor.pink_color
                                        : Color(0xFFF7D4DC),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      categories[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColor.white_color
                                            : AppColor.black_color,
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  if (hasSelection) ...[
                                    SizedBox(width: 4),
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppColor.white_color
                                            : AppColor.pink_color,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),

                  // Right Options List Area
                  Expanded(
                    child: Container(
                      color: AppColor.white_color,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: _buildRightPanelContent(),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action Bar (APPLY & Reset)
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanelContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildCategoryContent();
      case 1:
        return _buildSubCategoryContent();
      case 2:
        return _buildMetalStampContent();
      case 3:
        return _buildMetalTypeContent();
      case 4:
        return _buildDiamondTypeContent();
      case 5:
        return _buildPriceContent();
      case 6:
        return _buildWeightContent();
      default:
        return Container();
    }
  }

  // 1. Category Content
  Widget _buildCategoryContent() {
    return Obx(() {
      final menuCategories = categoryController.menuCategories;
      final options = menuCategories.isNotEmpty
          ? menuCategories
              .map((e) =>
                  MapEntry(e.name.toUpperCase(), MapEntry(e.slug, e.name)))
              .toList()
          : [
              MapEntry("RINGS", MapEntry("rings", "Rings")),
              MapEntry("FOR HIM", MapEntry("for-him", "For Him")),
              MapEntry("EARRINGS", MapEntry("earrings", "Earrings")),
              MapEntry("PENDANTS", MapEntry("pendants", "Pendants")),
              MapEntry("NECKLACES", MapEntry("necklaces", "Necklaces")),
              MapEntry("NOSEPINS", MapEntry("nosepins", "Nosepins")),
              MapEntry(
                  "MANGALSUTRAS", MapEntry("mangalsutras", "Mangalsutras")),
              MapEntry("BANGLES & BRACELETS",
                  MapEntry("bangles-bracelets", "Bangles & Bracelets")),
              MapEntry("RAKHI", MapEntry("rakhi", "Rakhi")),
              MapEntry("ENGAGEMENT RINGS",
                  MapEntry("engagement-rings", "Engagement Rings")),
            ];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return Obx(() {
            final isChecked =
                filterController.selectedCategorySlug.value == item.value.key;

            return _buildCheckboxOption(
              label: item.key,
              isChecked: isChecked,
              onTap: () {
                filterController.setCategorySlug(
                    item.value.key, item.value.value);
              },
            );
          });
        },
      );
    });
  }

  // 2. Sub Category Content
  Widget _buildSubCategoryContent() {
    return Obx(() {
      final List<MapEntry<String, MapEntry<String, String>>>
          subcategoryOptions = [];

      final allData = categoryController.filterData.value?.data ?? [];
      for (var cat in allData) {
        if (filterController.selectedCategorySlug.value.isEmpty ||
            cat.slug == filterController.selectedCategorySlug.value) {
          for (var sub in cat.subcategory) {
            subcategoryOptions
                .add(MapEntry(sub.name, MapEntry(sub.slug, sub.name)));
          }
        }
      }

      final options = subcategoryOptions.isNotEmpty
          ? subcategoryOptions
          : [
              MapEntry("Daily or Office wear",
                  MapEntry("daily-or-office-wear", "Daily or Office wear")),
              MapEntry("Cocktail", MapEntry("cocktail", "Cocktail")),
              MapEntry(
                  "Promise Rings", MapEntry("promise-rings", "Promise Rings")),
              MapEntry("Venki Rings", MapEntry("venki-rings", "Venki Rings")),
              MapEntry("Eternity Bands",
                  MapEntry("eternity-bands", "Eternity Bands")),
              MapEntry("Solitaire", MapEntry("solitaire", "Solitaire")),
              MapEntry("Gemstone", MapEntry("gemstone", "Gemstone")),
              MapEntry("Bypass", MapEntry("bypass", "Bypass")),
              MapEntry(
                  "Couple Rings", MapEntry("couple-rings", "Couple Rings")),
              MapEntry("3 Stone", MapEntry("3-stone", "3 Stone")),
              MapEntry("Toi et Moi", MapEntry("toi-et-moi", "Toi et Moi")),
            ];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return Obx(() {
            final isChecked = filterController.selectedSubcategorySlug.value ==
                item.value.key;

            return _buildCheckboxOption(
              label: item.key,
              isChecked: isChecked,
              onTap: () {
                filterController.setSubcategorySlug(
                    item.value.key, item.value.value);
              },
            );
          });
        },
      );
    });
  }

  // 3. Metal Stamp Content
  Widget _buildMetalStampContent() {
    return Obx(() {
      final listFromApi = jewelleryFilter.data.value?.data.metalStamp ?? [];
      final options = listFromApi.isNotEmpty
          ? listFromApi.map((e) => MapEntry(e.name, e.slug)).toList()
          : [
              MapEntry("18K Gold", "18k"),
              MapEntry("14K Gold", "14k"),
              MapEntry("9K Gold", "9k"),
              MapEntry("22K Gold", "22k"),
            ];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return Obx(() {
            final isChecked = filterController.metalstapid.value == item.value;

            return _buildCheckboxOption(
              label: item.key,
              isChecked: isChecked,
              onTap: () {
                filterController.setMetalStamp(item.value);
              },
            );
          });
        },
      );
    });
  }

  // 4. Metal Type Content
  Widget _buildMetalTypeContent() {
    return Obx(() {
      final listFromApi = jewelleryFilter.data.value?.data.metalType ?? [];
      final options = listFromApi.isNotEmpty
          ? listFromApi.map((e) => MapEntry(e.name, e.slug)).toList()
          : [
              MapEntry("Gold", "gold"),
              MapEntry("White Gold", "white-gold"),
              MapEntry("Rose Gold", "rose-gold"),
              MapEntry("Platinum", "platinum"),
            ];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return Obx(() {
            final isChecked =
                filterController.selectedMetalType.value == item.value;

            return _buildCheckboxOption(
              label: item.key,
              isChecked: isChecked,
              onTap: () {
                filterController.setMetalType(item.value);
              },
            );
          });
        },
      );
    });
  }

  // 5. Diamond Type Content (Shapes & Settings)
  Widget _buildDiamondTypeContent() {
    return Obx(() {
      final listFromApi = jewelleryFilter.data.value?.data.shape ?? [];
      final options = listFromApi.isNotEmpty
          ? listFromApi
              .map((e) => MapEntry(e.name, MapEntry(e.slug, e.id.toString())))
              .toList()
          : [
              MapEntry("Solitaire", MapEntry("solitaire", "1")),
              MapEntry("Round", MapEntry("round", "2")),
              MapEntry("Oval", MapEntry("oval", "3")),
              MapEntry("Princess", MapEntry("princess", "4")),
              MapEntry("Pear", MapEntry("pear", "5")),
              MapEntry("Emerald", MapEntry("emerald", "6")),
              MapEntry("Heart", MapEntry("heart", "7")),
              MapEntry("Marquise", MapEntry("marquise", "8")),
              MapEntry("Cushion", MapEntry("cushion", "9")),
            ];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return Obx(() {
            final isChecked =
                filterController.diamondtype.value == item.value.key;

            return _buildCheckboxOption(
              label: item.key,
              isChecked: isChecked,
              onTap: () {
                filterController.setDiamondType(
                    item.value.key, item.value.value);
              },
            );
          });
        },
      );
    });
  }

  // 6. Price Content
  Widget _buildPriceContent() {
    final options = filterController.price;

    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final item = options[index];
        return Obx(() {
          final isChecked = filterController.selectedPrice.value == item;

          return _buildCheckboxOption(
            label: item,
            isChecked: isChecked,
            onTap: () {
              filterController.setPrice(item);
            },
          );
        });
      },
    );
  }

  // 7. Weight Content
  Widget _buildWeightContent() {
    final options = filterController.weightlist;

    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final item = options[index];
        return Obx(() {
          final isChecked = filterController.selectedWeight.value == item;

          return _buildCheckboxOption(
            label: item,
            isChecked: isChecked,
            onTap: () {
              filterController.setWeight(item);
            },
          );
        });
      },
    );
  }

  // Common Checkbox Option Tile
  Widget _buildCheckboxOption({
    required String label,
    required bool isChecked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      isChecked ? AppColor.pink_color : AppColor.textfild_color,
                  width: 1.5,
                ),
                color: isChecked ? AppColor.pink_color : AppColor.white_color,
              ),
              child: isChecked
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: AppColor.white_color,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isChecked ? AppColor.pink_color : AppColor.black_color,
                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Action Bar (APPLY on Left, Reset on Right)
  Widget _buildBottomActionBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white_color,
          border: Border(
            top: BorderSide(color: AppColor.textfild_color, width: 1.0),
          ),
        ),
        child: Row(
          children: [
            // APPLY Button (Pink Filled)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    if (widget.onApply != null) {
                      widget.onApply!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.pink_color,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "APPLY",
                    style: TextStyle(
                      color: AppColor.white_color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Reset Button (Outlined)
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    filterController.clearFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.pink_color, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: AppColor.pink_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
