// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/myCart/fetchcart.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../../controller/API/menu/myCart/countcart.dart';
import '../../../../controller/API/menu/myCart/deletcart.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../menuwidget/drawer.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final fetchcart = Get.put(FetchcartCalling());
  final countcart = Get.put(CountCart());
  final deletcount = Get.put(Deletcart());

  double subTotal = 0.0;
  double discount = 0.0;
  double total = 0.0;


  List<int> itemCounts = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadCartData(); // Initialize data when screen loads
  }

  Future<void> _loadCartData() async {
    try {
      await fetchcart.fetchcartcall();
      if (!mounted) return;

      if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
        // Create new lists/objects to ensure state changes are detected
        final newItemCounts = fetchcart.data['carts'].map<int>((item) {
          return int.tryParse(item['qty'].toString()) ?? 1;
        }).toList();

        final newSubTotal = double.tryParse(fetchcart.data['old_gross_total'].toString()) ?? 0.0;
        final newDiscount = double.tryParse(fetchcart.data['discount_price'].toString()) ?? 0.0;
        final newTotal = newSubTotal - newDiscount;

        if (mounted) {
          setState(() {
            itemCounts = newItemCounts;
            subTotal = newSubTotal;
            discount = newDiscount;
            total = newTotal;
          });
        }
      }
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void initializeItemCounts() {
    if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
      itemCounts = List.generate(
        fetchcart.data['carts'].length, (index) => int.parse(fetchcart.data['carts'][index]['qty'].toString()),
      );
    }
  }

  void initializeCartData() {
    if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null) {
      // Initialize item counts with quantities from the cart
      itemCounts = fetchcart.data['carts'].map<int>((item) {
        return int.tryParse(item['qty'].toString()) ?? 1;
      }).toList();

      // Initialize totals
      subTotal = double.tryParse(fetchcart.data['old_gross_total'].toString()) ?? 0.0;
      discount = double.tryParse(fetchcart.data['discount_price'].toString()) ?? 0.0;
      total = subTotal - discount;

      setState(() {});
    }
  }

  void initializeCartTotals() {
    if (fetchcart.data.isNotEmpty) {
      subTotal = double.parse(fetchcart.data['old_gross_total'].toString());
      discount = double.parse(fetchcart.data['discount_price'].toString());
      total = subTotal - discount;

      // Initialize item counts with quantities from the cart
      itemCounts = List.generate(
        fetchcart.data['carts'].length,
            (index) => int.parse(fetchcart.data['carts'][index]['qty'].toString()),
      );
    }
  }

  void incrementValueOfCount(int index) {
    if (index >= itemCounts.length) return;

    final item = fetchcart.data['carts'][index];
    final price = double.parse(item['CartJewelryData']['offerprice'].toString());
    final cartId = item['id'].toString();
    final updatedQty = itemCounts[index] + 1;

    // Update UI immediately
    setState(() {
      itemCounts[index] = updatedQty;
      subTotal += price;
      total = subTotal - discount;
    });

    // Debounce API call
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () async {
      await fetchcart.fetchcartcall(
        flag: 'flag',
        cart: cartId,
        qty: updatedQty.toString(),
        type: 'mobile',
      );
      if (mounted) {
        setState(() {
          // Sync with server response
          subTotal = double.parse(fetchcart.data['old_gross_total'].toString());
          discount = double.parse(fetchcart.data['discount_price'].toString());
          total = subTotal - discount;
        });
      }
    });
  }

  void decrementValueOfCount(int index) {
    if (index >= itemCounts.length || itemCounts[index] <= 1) return;

    final item = fetchcart.data['carts'][index];
    final price = double.parse(item['CartJewelryData']['offerprice'].toString());
    final cartId = item['id'].toString();
    final updatedQty = itemCounts[index] - 1;

    // Update UI immediately
    setState(() {
      itemCounts[index] = updatedQty;
      subTotal -= price;
      total = subTotal - discount;
    });

    // Debounce API call
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 800), () async {
      await fetchcart.fetchcartcall(
        flag: 'flag',
        cart: cartId,
        qty: updatedQty.toString(),
        type: 'mobile',
      );
      if (mounted) {
        setState(() {
          // Sync with server response
          subTotal = double.parse(fetchcart.data['old_gross_total'].toString());
          discount = double.parse(fetchcart.data['discount_price'].toString());
          total = subTotal - discount;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Appbar(
        prefixicon: AppIcon.menu,
        prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
        hedingname: AppString.myCart,
      ),
      drawer: Drawers(),
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if (fetchcart.isLoading.value) {
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
                if (Get.isDialogOpen == true) {
                  Get.back();
                }
              });

              // Initialize item counts when data is loaded
              if (fetchcart.data.isNotEmpty && fetchcart.data['carts'] != null && itemCounts.length != fetchcart.data['carts'].length) {
                initializeItemCounts();
              }

              final fetch = fetchcart.data['carts'] ?? [];

              if (fetch.isEmpty) {
                return Center(child: Lottie.asset(AppJson.noData));
              }

              return horizontalpadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 50),
                    Text(
                      AppString.shoppingcart,
                      style: TextStyle(
                        color: AppColor.pink_color,
                        fontSize: Get.width / 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lora',
                      ),
                    ),
                    SizedBox(height: Get.height / 50),

                    // Add Cart List
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: fetch.length,
                        itemBuilder: (context, index) {
                          final item = fetch[index];
                          final fetchdata = item['CartJewelryData'];
                          final fetchimage = (fetchdata['allImages'].isNotEmpty)
                              ? fetchdata['allImages'][0]
                              : null;

                          // Ensure itemCounts is properly initialized for this index
                          if (index >= itemCounts.length) {
                            return Container(); // Or some loading/placeholder
                          }

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: Get.height / 120),
                            child: Row(
                              children: [
                                if (fetchimage != null)
                                  Image(
                                    image: NetworkImage(fetchimage['thumb']),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.error),
                                  ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          fetchdata['title'],
                                          style: TextStyle(fontSize: Get.width / 27),
                                        ),
                                        subtitle: Text(
                                          '₹${fetchdata['offerprice'].toString()}.00',
                                          style: TextStyle(
                                            color: AppColor.pink_color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Get.height / 300),
                                      horizontalpadding(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => decrementValueOfCount(index),
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(fontSize: Get.width / 20),
                                                  ),
                                                ),
                                                SizedBox(width: Get.width / 50),
                                                Text(itemCounts[index].toString()),
                                                SizedBox(width: Get.width / 50),
                                                GestureDetector(
                                                  onTap: () => incrementValueOfCount(index),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColor.textfild_color,
                                                      borderRadius: BorderRadius.circular(Get.width / 50),
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 1,
                                                    ),
                                                    child: Text(
                                                      '+',
                                                      style: TextStyle(fontSize: Get.width / 20),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              child: SvgPicture.asset(
                                                AppIcon.close,
                                                width: 10,
                                                height: 10,
                                              ),
                                              onTap: () async {
                                                final deletid = item['id'].toString();
                                                final diamondid = item['diamondid'].toString();
                                                final jewelryid = item['jewelryid'].toString();

                                                await deletcount.deletcartcall(
                                                  id: deletid,
                                                  jewelryid: jewelryid,
                                                  diamondid: diamondid,
                                                );

                                                // Update both lists
                                                setState(() {
                                                  fetch.removeAt(index);
                                                  if (index < itemCounts.length) {
                                                    itemCounts.removeAt(index);
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Details Cart List
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.CartTotal,
                            style: TextStyle(
                              fontSize: Get.width / 18,
                              fontWeight: FontWeight.w500,
                              color: AppColor.grey_color,
                              fontFamily: 'Lora',
                            ),
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.subTotal),
                              Text('₹${subTotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.discount),
                              Text('₹${fetchcart.data['discount_price'].toString()}.00'),
                            ],
                          ),
                          SizedBox(height: Get.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppString.shipping),
                              Text("Free"),
                            ],
                          ),
                          SizedBox(height: Get.height / 50),
                          Row(
                            children: [
                              Text(AppString.total),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
