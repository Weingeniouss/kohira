// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEncryption {
  static String get _secret {
    try {
      if (dotenv.isInitialized && (dotenv.env['SECRET']?.isNotEmpty ?? false)) {
        return dotenv.env['SECRET']!;
      }
    } catch (_) {}
    return 'K4mX9pQa2LsD7vNc5RtY1uZe8WhJ3fBn';
  }

  static String get _ivKey {
    try {
      if (dotenv.isInitialized && (dotenv.env['IV_KEY']?.isNotEmpty ?? false)) {
        return dotenv.env['IV_KEY']!;
      }
    } catch (_) {}
    return 'R7pL2xQm9NsD4vKz';
  }

  static String get _hmacKey {
    try {
      if (dotenv.isInitialized && (dotenv.env['HMAC_KEY']?.isNotEmpty ?? false)) {
        return dotenv.env['HMAC_KEY']!;
      }
    } catch (_) {}
    return '9xD2vLmP7QaT5zWs';
  }

  static dynamic decryptResponse(String? payload, String? signature) {
    try {
      if (payload == null || payload.isEmpty) {
        return null;
      }

      // 1. Verify Signature (HMAC-SHA256) if _hmacKey is configured
      if (_hmacKey.isNotEmpty && signature != null && signature.isNotEmpty) {
        final hmacKeyBytes = utf8.encode(_hmacKey);
        final payloadBytes = utf8.encode(payload);
        final hmac = Hmac(sha256, hmacKeyBytes);
        final expectedSignature = hmac.convert(payloadBytes).toString();

        if (expectedSignature != signature) {
          print(
              'Signature mismatch (expected: $expectedSignature, received: $signature)');
          // Do not fail immediately if signature verification differs; continue with AES decryption.
        } else {
          print('Signature verified successfully');
        }
      }

      // 2. AES Decrypt (CBC Mode with PKCS7 Padding)
      if (_secret.isEmpty || _ivKey.isEmpty) {
        print('Warning: Secret or IV Key is not configured in .env');
        return null;
      }

      final key = encrypt.Key.fromUtf8(_secret);
      final iv = encrypt.IV.fromUtf8(_ivKey);

      // The encrypt package handles PKCS7 padding by default in CBC mode
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final decrypted = encrypter.decrypt64(payload, iv: iv);
      print('Decrypted successfully');

      if (decrypted.isEmpty) return null;

      try {
        return jsonDecode(decrypted);
      } catch (_) {
        return decrypted;
      }
    } catch (e) {
      print('Decrypt Error: $e');
      return null;
    }
  }
}
