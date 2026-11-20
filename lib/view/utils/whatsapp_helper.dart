// ignore_for_file: avoid_print

import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  static const String defaultPhone = '917851005200';

  /// Launch WhatsApp with an optional custom message and phone number
  static Future<void> launchWhatsApp({
    String phone = defaultPhone,
    String message = "Hello Kohira, I have an inquiry.",
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final encodedMessage = Uri.encodeComponent(message);

    final waMeUrl = Uri.parse("https://wa.me/$cleanPhone?text=$encodedMessage");
    if (await canLaunchUrl(waMeUrl)) {
      await launchUrl(waMeUrl, mode: LaunchMode.externalApplication);
      return;
    }

    final whatsappSchemeUrl = Uri.parse("whatsapp://send?phone=$cleanPhone&text=$encodedMessage");
    if (await canLaunchUrl(whatsappSchemeUrl)) {
      await launchUrl(whatsappSchemeUrl, mode: LaunchMode.externalApplication);
      return;
    }

    final webUrl = Uri.parse("https://api.whatsapp.com/send?phone=$cleanPhone&text=$encodedMessage");
    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  /// Make a direct phone call
  static Future<void> makePhoneCall({String phone = '+917851005200'}) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final url = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  /// Open mail client
  static Future<void> sendEmail({String email = 'support@kohira.com', String subject = 'Kohira Inquiry'}) async {
    final url = Uri.parse('mailto:$email?subject=${Uri.encodeComponent(subject)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
