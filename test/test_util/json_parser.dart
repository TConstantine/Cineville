import 'dart:convert';

class JsonParser {
  static Map<String, dynamic> parse(String jsonString) => json.decode(jsonString);
}
