import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:english_words/english_words.dart';

class IOHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  static Future<File> _writeContent(String content, {bool overwrite = false}) async {
    final file = await _localFile;
    if (overwrite) {
      return file.writeAsString(content, mode: FileMode.write);
    }
    return file.writeAsString(content, mode: FileMode.append);
  }

  static Future<void> write(Set<WordPair> set) async {
    var list = await read();
    String res = "";
    for (var i in set) {
      if (!list.contains(i.asPascalCase)) res += "${i.asPascalCase} ";
    }
    await _writeContent(res);
  }

  static Future<void> overwrite(List<String> list) async {
    String res = "";
    for (var i in list) {
      res += "$i ";
    }
    await _writeContent(res, overwrite: true);
  }

  static Future<List<String>> read() async {
    String contents;
    try {
      final file = await _localFile;
      contents = await file.readAsString();
    } catch (e) {
      contents = '';
    }
    var res = contents.split(' ');
    for (int i = 0; i < res.length; i++)
    {
      if (res[i].trim() == '') res.removeAt(i);
    }
    return res;
  }
}
