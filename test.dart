import 'package:test/test.dart';
import 'beings.dart';
void main() {
  test("canEat works", () {
    expect(TestAnimal().canEat(TestPlant((World w) {})), equals(true));
    expect(TestAnimal().canEat(TestAnimal()), equals(false));
  });
  var times = 0;
  var world = World();
  Plan testPlan1 = Plan((World w) { times++; });
  test("World.tick ticks", () {
    world.tick(testPlan1);
    expect(times, equals(1));
  });
  Plan plantTestPlan = Plan.addPlant(() => TestPlant((World w) { times++; }));
  test("World.tick ticks beings", () {
    world.tick(plantTestPlan);
    expect(times, equals(2));
  });
}
