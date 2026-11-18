// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, unused_local_variable

import 'dart:io';

void main() async {
  final libDir = Directory('C:/Users/soni/StudioProjects/kohira/lib');
  int count = 0;

  await for (var entity in libDir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final path = entity.path;
      if (path.contains('api_service.dart') ||
          path.contains('api_call.dart') ||
          path.contains('overStore') ||
          path.contains('dio_client.dart')) {
        continue;
      }

      bool updated = await processFile(entity);
      if (updated) {
        count++;
      }
    }
  }

}

Future<bool> processFile(File file) async {
  String content = await file.readAsString();
  String original = content;

  if (!content.contains('DioClient.dio')) {
    return false;
  }

  if (!content.contains("import 'package:kohira/api/api_call.dart';")) {
    int importsEnd = content.lastIndexOf("import '");
    if (importsEnd != -1) {
      int lineEnd = content.indexOf('\n', importsEnd);
      if (lineEnd != -1) {
        content = "${content.substring(0, lineEnd + 1)}import 'package:kohira/api/api_call.dart';\n${content.substring(lineEnd + 1)}";
      }
    } else {
      content = "import 'package:kohira/api/api_call.dart';\n" + content;
    }
  }

  content = content.replaceAll(RegExp(r"import 'package:kohira/view/utils/dio_client\.dart';\n?"), "");
  content = content.replaceAll(RegExp(r"import 'package:kohira/view/utils/API_headers\.dart';\n?"), "");
  content = content.replaceAll(RegExp(r"import 'package:dio/dio\.dart';\n?"), "");

  content = replaceDioCalls(content);

  if (content != original) {
    await file.writeAsString(content);
    return true;
  }
  return false;
}

String replaceDioCalls(String text) {
  int idx = 0;
  while (true) {
    int matchPost = text.indexOf('DioClient.dio.post(', idx);
    int matchGet = text.indexOf('DioClient.dio.get(', idx);

    if (matchPost == -1 && matchGet == -1) break;

    bool isPost = false;
    int start = -1;
    int prefixLen = 0;

    if (matchPost != -1 && (matchGet == -1 || matchPost < matchGet)) {
      start = matchPost;
      isPost = true;
      prefixLen = 'DioClient.dio.post('.length;
    } else {
      start = matchGet;
      prefixLen = 'DioClient.dio.get('.length;
    }

    int openParens = 1;
    int curr = start + prefixLen;
    while (curr < text.length && openParens > 0) {
      if (text[curr] == '(') openParens++;
      else if (text[curr] == ')') openParens--;
      curr++;
    }

    int end = curr;
    String callContent = text.substring(start + prefixLen, end - 1);

    List<String> parts = splitFirstCommaOutsideBrackets(callContent);
    String url = parts[0].trim();

    String dataStr = "";
    if (isPost && parts.length > 1) {
      RegExp dataRegex = RegExp(r"data\s*:\s*([^,]+)(?:,|$)");
      Match? dataMatch = dataRegex.firstMatch(parts[1]);
      if (dataMatch != null) {
        dataStr = ", data: ${dataMatch.group(1)!.trim()}";
      }
    }

    String useAuth = callContent.contains('tokans') ? "true" : "false";

    String newCall;
    if (isPost) {
      newCall = "ApiCall.postRequest($url$dataStr, useAuth: $useAuth)";
    } else {
      newCall = "ApiCall.getRequest($url, useAuth: $useAuth)";
    }

    text = text.substring(0, start) + newCall + text.substring(end);
    idx = start + newCall.length;
  }
  return text;
}

List<String> splitFirstCommaOutsideBrackets(String str) {
  int brackets = 0;
  for (int i = 0; i < str.length; i++) {
    if (str[i] == '(' || str[i] == '{' || str[i] == '[') brackets++;
    else if (str[i] == ')' || str[i] == '}' || str[i] == ']') brackets--;
    else if (str[i] == ',' && brackets == 0) {
      return [str.substring(0, i), str.substring(i + 1)];
    }
  }
  return [str];
}
