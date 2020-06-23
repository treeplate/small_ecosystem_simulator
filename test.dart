import 'package:test/test.dart';
import 'beings.dart';
void main() {
  test("canEat works", () {
    expect(TestAnimal().canEat(TestPlant()), equals(true));
    expect(TestAnimal().canEat(TestAnimal()), equals(false));
  });
  var times = 0;
  var world = World();
  Plan plan = Plan(() => times++);
  test("World.tick ticks"), () {
    world.tick(plan);
    expect(times == 1);
  });
}
