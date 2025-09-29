// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaWidget extends StatefulWidget {
  final String siteKey;
  final String baseUrl;
  final Function(String token) onVerified;
  final VoidCallback? onError;

  const RecaptchaWidget({
    Key? key,
    required this.siteKey,
    required this.baseUrl,
    required this.onVerified,
    this.onError,
  }) : super(key: key);

  @override
  State<RecaptchaWidget> createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (kDebugMode) {
              print('📄 Page started loading: $url');
            }
          },
          onPageFinished: (String url) {
            if (kDebugMode) {
              print('✅ Page finished loading: $url');
            }
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            if (kDebugMode) {
              print('❌ Web resource error: ${error.description}');
            }
            if (mounted) {
              widget.onError?.call();
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'RecaptchaChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (kDebugMode) {
            print('📨 Message received: ${message.message}');
          }

          if (message.message.startsWith('token:')) {
            String token = message.message.substring(6);
            if (kDebugMode) {
              print('✅ Token received: ${token.substring(0, 20)}...');
            }
            widget.onVerified(token);
          } else if (message.message == 'error') {
            if (kDebugMode) {
              print('❌ reCAPTCHA error callback triggered');
            }
            widget.onError?.call();
          } else if (message.message == 'expired') {
            if (kDebugMode) {
              print('⏰ reCAPTCHA expired');
            }
            widget.onError?.call();
          } else {
            if (kDebugMode) {
              print('ℹ️ Other message: ${message.message}');
            }
          }
        },
      )
      ..loadHtmlString(_getHtmlContent(), baseUrl: widget.baseUrl);
  }

  String _getHtmlContent() {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="https://www.google.com/recaptcha/api.js" async defer></script>
          <style>
            * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
              font-size: 13px;
            }
            body {
              display: flex;
              justify-content: center;
              align-items: center;
              min-height: 100vh;
              background-color: #FFFFFF;
              font-family: Arial, sans-serif;
              font-size: 12px;
            }
            .recaptcha-container {
              display: flex;
              flex-direction: column;
              align-items: center;
              justify-content: center;
              padding: 20px;
            }
            .loading {
              text-align: center;
              color: #666;
              margin-bottom: 20px;
              font-size: 13px;
            }
            #recaptcha-element {
              transform: scale(0.95);
              transform-origin: center;
            }
          </style>
        </head>
        <body>
          <div class="recaptcha-container">
            <div class="loading" id="loading-text">Loading reCAPTCHA...</div>
            <div id="recaptcha-element"></div>
          </div>
          
          <script>
            // Log for debugging
            console.log('reCAPTCHA script loaded');
            
            // Wait for reCAPTCHA API to load
            var checkRecaptchaLoaded = setInterval(function() {
              if (typeof grecaptcha !== 'undefined' && grecaptcha.render) {
                console.log('grecaptcha is ready');
                clearInterval(checkRecaptchaLoaded);
                initRecaptcha();
              }
            }, 100);
            
            function initRecaptcha() {
              try {
                document.getElementById('loading-text').style.display = 'none';
                
                grecaptcha.render('recaptcha-element', {
                  'sitekey': '${widget.siteKey}',
                  'callback': onSuccess,
                  'error-callback': onError,
                  'expired-callback': onExpired,
                  'theme': 'light',
                  'size': 'normal'
                });
                
                console.log('reCAPTCHA rendered successfully');
              } catch (e) {
                console.error('Error rendering reCAPTCHA:', e);
                RecaptchaChannel.postMessage('error');
              }
            }
            
            function onSuccess(token) {
              console.log('✅ reCAPTCHA success, token received');
              if (typeof RecaptchaChannel !== 'undefined') {
                RecaptchaChannel.postMessage('token:' + token);
              } else {
                console.error('RecaptchaChannel is not available');
              }
            }
            
            function onError() {
              console.log('❌ reCAPTCHA error');
              if (typeof RecaptchaChannel !== 'undefined') {
                RecaptchaChannel.postMessage('error');
              }
            }
            
            function onExpired() {
              console.log('⏰ reCAPTCHA expired');
              if (typeof RecaptchaChannel !== 'undefined') {
                RecaptchaChannel.postMessage('expired');
              }
            }
            
            // Timeout fallback
            setTimeout(function() {
              if (typeof grecaptcha === 'undefined') {
                console.error('reCAPTCHA failed to load within timeout');
                if (typeof RecaptchaChannel !== 'undefined') {
                  RecaptchaChannel.postMessage('error');
                }
              }
            }, 10000); // 10 second timeout
          </script>
        </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading verification...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}