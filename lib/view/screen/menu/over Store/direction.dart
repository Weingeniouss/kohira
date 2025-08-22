import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';

class Directions extends StatefulWidget {
  final String data;
  const Directions({super.key, required this.data});

  @override
  State<Directions> createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: SafeArea(child: SingleChildScrollView(child: Html(data: widget.data))),
      ),
    );
  }
}
