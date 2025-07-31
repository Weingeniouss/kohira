// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kohira/view/utils/html/shipping.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kohira/view/utils/app_color.dart';

class Shipping extends StatelessWidget {
  const Shipping({super.key});

  void _launchURL(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
    else Get.snackbar("Error", "Could not open link: $url", snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.htmlbackgroud,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Html(
            data: shipping,
            onLinkTap: (url, attributes, element) => _launchURL(url),
          ),
        ),
      ),
    );
  }
}
