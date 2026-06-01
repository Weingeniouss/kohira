// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEncryption {
  static String get _secret => dotenv.env['SECRET'] ?? '';
  static String get _ivKey => dotenv.env['IV_KEY'] ?? '';
  static String get _hmacKey => dotenv.env['HMAC_KEY'] ?? '';

  static dynamic decryptResponse(String? payload, String? signature) {
    try {
      if (payload == null ||
          signature == null ||
          payload.isEmpty ||
          signature.isEmpty) {
        return null;
      }

      // 1. Verify Signature (HMAC-SHA256)
      final hmacKeyBytes = utf8.encode(_hmacKey);
      final payloadBytes = utf8.encode(payload);
      final hmac = Hmac(sha256, hmacKeyBytes);
      final expectedSignature = hmac.convert(payloadBytes).toString();

      if (expectedSignature != signature) {
        print('Signature mismatch');
        return null;
      }

      // 2. AES Decrypt (CBC Mode with PKCS7 Padding)
      final key = encrypt.Key.fromUtf8(_secret);
      final iv = encrypt.IV.fromUtf8(_ivKey);

      // The encrypt package handles PKCS7 padding by default in CBC mode
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final decrypted = encrypter.decrypt64(payload, iv: iv);
      print('Decrypted successfully');

      if (decrypted.isEmpty) return null;

      return jsonDecode(decrypted);
    } catch (e) {
      print('Decrypt Error: $e');
      return null;
    }
  }
}
