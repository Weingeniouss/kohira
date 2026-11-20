import os
import re

lib_dir = r"C:\Users\soni\StudioProjects\kohira\lib"

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    if 'DioClient.dio' not in content:
        return False

    if "import 'package:kohira/api/api_call.dart';" not in content:
        imports_end = content.rfind("import '")
        if imports_end != -1:
            line_end = content.find('\n', imports_end)
            content = content[:line_end+1] + "import 'package:kohira/api/api_call.dart';\n" + content[line_end+1:]
        else:
            content = "import 'package:kohira/api/api_call.dart';\n" + content

    content = re.sub(r"import 'package:kohira/view/utils/dio_client\.dart';\n?", "", content)
    content = re.sub(r"import 'package:kohira/view/utils/API_headers\.dart';\n?", "", content)
    content = re.sub(r"import 'package:dio/dio\.dart';\n?", "", content)

    def replace_dio_calls(text):
        idx = 0
        while True:
            match_post = text.find('DioClient.dio.post(', idx)
            match_get = text.find('DioClient.dio.get(', idx)

            if match_post == -1 and match_get == -1:
                break

            is_post = False
            if match_post != -1 and (match_get == -1 or match_post < match_get):
                start = match_post
                is_post = True
                prefix_len = len('DioClient.dio.post(')
            else:
                start = match_get
                prefix_len = len('DioClient.dio.get(')

            open_parens = 1
            curr = start + prefix_len
            while curr < len(text) and open_parens > 0:
                if text[curr] == '(': open_parens += 1
                elif text[curr] == ')': open_parens -= 1
                curr += 1

            end = curr
            call_content = text[start+prefix_len:end-1]

            parts = call_content.split(',', 1)
            url = parts[0].strip()

            data_str = ""
            if is_post and len(parts) > 1:
                data_match = re.search(r"data\s*:\s*([^,]+)(?:,|$)", parts[1])
                if data_match:
                    data_str = ", data: " + data_match.group(1).strip()

            use_auth = "true" if 'tokans' in call_content else "false"

            if is_post:
                new_call = f"ApiCall.postRequest({url}{data_str}, useAuth: {use_auth})"
            else:
                new_call = f"ApiCall.getRequest({url}, useAuth: {use_auth})"

            text = text[:start] + new_call + text[end:]
            idx = start + len(new_call)

        return text

    # Check for DioClient.dio.request (like in api_service.dart or similar)
    content = content.replace("DioClient.dio.request", "ApiCall.getRequest")

    content = replace_dio_calls(content)

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

count = 0
for root, _, files in os.walk(lib_dir):
    if "api_service.dart" in root: continue
    for file in files:
        if file.endswith('.dart'):
            if "api_service.dart" in file: continue
            if "overStore" in file: continue
            if "api_call.dart" in file: continue
            if "dio_client.dart" in file: continue
            if process_file(os.path.join(root, file)):
                count += 1
                print(f"Updated {file}")

print(f"Total files updated: {count}")
