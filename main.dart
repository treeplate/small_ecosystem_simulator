import 'dart:io';
import 'beings.dart';
import 'test.dart' as test;
void main() async {
  //stdout.write(Process.runSync("clear", [], runInShell: true).stdout);
  stdout.write('\x1B[2J\x1B[3J:hi');
  test.main();
}