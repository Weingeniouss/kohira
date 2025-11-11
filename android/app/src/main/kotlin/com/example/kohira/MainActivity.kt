package com.example.kohira

import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import android.webkit.JavascriptInterface
import android.app.AlertDialog
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.recaptcha"
    private val SITE_KEY = "6Lcy6h8qAAAAAGiDEKlXSd1I80BOCgD5-hY3jnBF"
    private var methodChannel: MethodChannel? = null
    private var pendingResult: MethodChannel.Result? = null
    private var recaptchaDialog: AlertDialog? = null
    private var recaptchaWebView: WebView? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "verifyRecaptcha") {
                pendingResult = result
                showRecaptchaWebView()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun showRecaptchaWebView() {
        val html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <script src="https://www.google.com/recaptcha/api.js"></script>
                <style>
                    body { 
                        margin: 0; 
                        padding: 20px; 
                        background: #fff; 
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    }
                    .container { 
                        display: flex; 
                        justify-content: center; 
                        align-items: center; 
                        min-height: 100vh;
                    }
                    .recaptcha-wrapper {
                        background: white;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="recaptcha-wrapper">
                        <form id="recaptcha-form">
                            <div class="g-recaptcha" data-sitekey="$SITE_KEY" data-callback="onRecaptchaVerified"></div>
                        </form>
                    </div>
                </div>
                <script>
                    function onRecaptchaVerified(token) {
                        if (token && token.length > 0) {
                            RecaptchaChannel.onToken(token);
                        }
                    }
                </script>
            </body>
            </html>
        """.trimIndent()

        // Create WebView
        recaptchaWebView = WebView(this).apply {
            settings.apply {
                javaScriptEnabled = true
                domStorageEnabled = true
                databaseEnabled = true
            }
            webViewClient = object : WebViewClient() {
                override fun onPageFinished(view: WebView?, url: String?) {
                    super.onPageFinished(view, url)
                }
            }
            addJavascriptInterface(RecaptchaJSInterface(), "RecaptchaChannel")
        }

        // Create Dialog
        val dialogBuilder = AlertDialog.Builder(this)
        dialogBuilder.setView(recaptchaWebView)
        dialogBuilder.setOnCancelListener {
            pendingResult?.error("CANCELLED", "reCAPTCHA verification cancelled", null)
            pendingResult = null
        }

        recaptchaDialog = dialogBuilder.create()
        recaptchaDialog?.show()

        // Load reCAPTCHA
        recaptchaWebView?.loadDataWithBaseURL(
            "https://next.weingenious.in",
            html,
            "text/html",
            "UTF-8",
            null
        )
    }

    private inner class RecaptchaJSInterface {
        @JavascriptInterface
        fun onToken(token: String) {
            runOnUiThread {
                println("Full reCAPTCHA Token: $token")
                pendingResult?.success(token)
                recaptchaDialog?.dismiss()
                recaptchaDialog = null
                recaptchaWebView = null
                pendingResult = null
            }
        }
    }
}