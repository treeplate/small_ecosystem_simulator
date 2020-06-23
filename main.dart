import 'dart:io';
import 'beings.dart';
void main() {
  stdout.write(Process.runSync("clear", [], runInShell: true).stdout);
  expect(TestAnimal().canEat(TestPlant()), "Test #1 failed");
  expect(!TestAnimal().canEat(TestAnimal()), "Test #2 failed");
}

void expect(bool boolean, String message) {
  if(!boolean) {
    throw message;
  }
}