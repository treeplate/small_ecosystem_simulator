import 'package:test/test.dart';
import 'beings.dart';
void main() {
  test("canEat works", () {
    expect(TestAnimal().canEat(TestPlant()), equals(true));
    expect(TestAnimal().canEat(TestAnimal()), equals(false));
  });
  var times = 0;
  var world = World();
  Plan testPlan1 = Plan(() => times++);
  test("World.tick ticks"), () {
    world.tick(testPlan1);
    expect(times == 1);
  });
  Plan plantTestPlan = Plan.addPlant(() => TestPlant(() => times++));
  test("World.tick ticks beings", () {
    world.tick(plantTestPlan);
    expect(times == 2);
  });
}
