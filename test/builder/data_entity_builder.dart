import 'package:meta/meta.dart';

import '../test_util/file_reader.dart';
import '../test_util/json_parser.dart';

abstract class DataEntityBuilder<T> {
  @protected
  String filename;
  @protected
  String key;

  T build();

  Map<String, dynamic> buildAsJson() {
    return parseList().first;
  }

  List<T> buildList();

  String buildListAsJsonString() {
    return FileReader.read(filename);
  }

  @protected
  List<dynamic> parseList() {
    return JsonParser.parse(buildListAsJsonString())[key];
  }
}
