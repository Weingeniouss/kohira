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

      bool updated = await fixFile(entity);
      if (updated) {
        count++;
        print('Fixed: ${entity.path}');
      }
    }
  }

  print('Total files fixed: $count');
}

Future<bool> fixFile(File file) async {
  String content = await file.readAsString();
  String original = content;

  // Since we replaced Dio with ApiCall, we need to fix usage of the response variable.
  // Variables are usually named 'responce', 'response', 'responses', 'responcse' etc.

  // Replace `if (response.statusCode == 200 || response.statusCode == 201)`
  // with `if (response != null)`
  // Actually, since ApiService throws if not 200/201, `if (true)` works, or `if (response.isNotEmpty)`.
  // The safest is replacing the whole condition with `if (true)` or removing it.

  // Let's use a regex to match the if condition with statusCode
  RegExp statusCodeRegex = RegExp(r"if\s*\(\s*(\w+)\.statusCode\s*==\s*200(?:\s*\|\|\s*\1\.statusCode\s*==\s*201)?\s*\)\s*\{");
  content = content.replaceAllMapped(statusCodeRegex, (match) {
    String varName = match.group(1)!;
    return "if ($varName != null) {";
  });

  // Replace `.data` access
  // Sometimes it's `response.data.toString()`, sometimes `response.data is Map`
  // We need to replace `response.data` with `response`
  // Because response is now a Map<String, dynamic>.
  // Be careful not to replace `model.data` or `data.value`. Only the variable from the statusCode match.

  // It's safer to find the variable name from the ApiCall assignment.
  RegExp apiCallRegex = RegExp(r"(?:final|var|dynamic)?\s*(\w+)\s*=\s*await\s*ApiCall\.(?:get|post)Request");
  Iterable<Match> matches = apiCallRegex.allMatches(content);

  for (Match match in matches) {
    String varName = match.group(1)!;

    // Replace `varName.statusCode == ...` again just in case
    content = content.replaceAll(RegExp(r"if\s*\(\s*" + varName + r"\.statusCode\s*==\s*200.*?\)\s*\{"), "if ($varName != null) {");

    // Replace `$varName.data.toString()` with `jsonEncode($varName)`
    content = content.replaceAll(varName + r".data.toString()", "jsonEncode(" + varName + ")");

    // Replace `$varName.data` with `$varName`
    content = content.replaceAll(varName + r".data", varName);

    // Replace `$varName.statusCode` with `200`
    content = content.replaceAll(varName + r".statusCode", "200");
  }

  // To fix import issue, since we'll use jsonEncode, we need dart:convert
  if (content != original && !content.contains("import 'dart:convert';")) {
    int importsEnd = content.lastIndexOf("import '");
    if (importsEnd != -1) {
      int lineEnd = content.indexOf('\n', importsEnd);
      if (lineEnd != -1) {
        content = content.substring(0, lineEnd + 1) +
                  "import 'dart:convert';\n" +
                  content.substring(lineEnd + 1);
      }
    } else {
      content = "import 'dart:convert';\n" + content;
    }
  }

  if (content != original) {
    await file.writeAsString(content);
    return true;
  }
  return false;
}
