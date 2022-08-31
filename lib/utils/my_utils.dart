import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class MyUtils {
  static Future<void> copyToClipboard(BuildContext? context, String string) async {
    if(string.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: string));
      if(context != null) {
        // Snakbar().show_info_snakbar(context, "Copied");
      }
    }
  }

  String getSecureUrl(String url) {
    if(url.startsWith("http:")) {
      url = url.replaceFirst("http:", "https:");
    }
    return url;
  }
}













