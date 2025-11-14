import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/route_manager.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/html/retray.dart';
import 'package:url_launcher/url_launcher.dart';

class Retray extends StatelessWidget {
  const Retray({super.key});

  Future<void> _launchURL(String? url) async {
    if (url == null) return;
    final lower = url.toLowerCase();

    // -----------------------------------------
    // AUTO OPEN EMAIL APP (mailto)
    // -----------------------------------------
    if (lower.startsWith("mailto:")) {
      final uri = Uri.parse(url);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // <-- important for Android
      );

      if (!launched) {
        Get.snackbar("Error", "Unable to open email application", snackPosition: SnackPosition.BOTTOM);
      }

      return;
    }

    // -----------------------------------------------------
    // OPTIONAL: Prevent phone numbers from opening dial-pad
    // -----------------------------------------------------
    // PHONE → custom action, NO dialer
    if (lower.startsWith("phone:")) {
      final number = url.replaceFirst("phone:", "").trim();

      // Create the tel URL
      final telUrl = 'tel:$number';

      // Launch the dialer
      if (await canLaunchUrl(Uri.parse(telUrl))) {
        await launchUrl(Uri.parse(telUrl));
      } else {
        // Fallback if dialer can't be opened
        Get.snackbar("Error", "Could not launch dialer");
      }

      return;
    }

    // -----------------------------------------
    // OPEN NORMAL LINKS
    // -----------------------------------------
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open: $url", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.htmlbackgroud,
      body: Container(
        width: Get.width, height: Get.height,
        decoration: BoxDecoration(color: AppColor.htmlbackgroud),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Html(
              data: retray,
              onLinkTap: (url, attributes, element) {
                _launchURL(url);
              },
            ),
          ),
        ),
      ),
    );
  }
}
