import 'dart:io';

class FileReader {
  static final String _path = 'test/test_data/';

  static String read(String filename) => File('$_path$filename').readAsStringSync();
}
