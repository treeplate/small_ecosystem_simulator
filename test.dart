import 'package:test/test.dart';
import 'beings.dart';
void main() {
  test("canEat works", () {
    expect(TestAnimal().canEat(TestPlant()), equals(true));
    expect(TestAnimal().canEat(TestAnimal()), equals(false));
  });
}
