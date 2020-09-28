import 'package:test/test.dart';
import 'beings.dart';
void main() {

  test("canEat works", () {
    expect(TestAnimal().canEat(TestPlant(() {})), equals(true));
    expect(TestAnimal().canEat(TestAnimal()), equals(false));
  });

  var times = 0;
  var world = World();
  Plan testPlan1 = Plan((World w) { times++; });
  test("World.tick ticks", () {
    world.tick(testPlan1);
    expect(times, equals(1));
  });

  Plan plantTestPlan = Plan.addBeing(() => TestPlant(() { times++; }));
  test("World.tick ticks beings", () {
    world.tick(plantTestPlan);
    expect(times, equals(2));
  });

  test("Plants have babies", (){
    world.tick(Plan.idle());
    world.tick(Plan.idle());
    world.tick(Plan.idle());
    world.tick(Plan.idle());
    expect(world.all.length, equals(2));
  });

  test("Feeding", () {
    Plant nut = TestPlant(() { });
    Animal mouse = HerbivoreTestAnimal();
    Animal cat = TestAnimal();
    World world = World();
    world.tick(Plan.addBeing(() => nut));
    world.tick(Plan.addBeing(() => mouse));
    world.tick(Plan.addBeing(() => cat));
    expect(mouse.canEat(nut), isTrue);
    expect(mouse.canEat(cat), isFalse);
    expect(cat.canEat(mouse), isTrue);
    expect(nut.dead, isFalse);
    world.tick(Plan.feed(mouse, nut));
    expect(nut.dead, isTrue);
    expect(mouse.dead, isFalse);
    world.tick(Plan.feed(cat, mouse));
    expect(mouse.dead, isTrue);
    expect(cat.dead, isFalse);
  });

  test("Feeding - fighting back", () {
    Animal mouse = HerbivoreTestAnimal();
    Animal cat = TestAnimal();
    World world = World();
    world.tick(Plan.addBeing(() => mouse));
    world.tick(Plan.addBeing(() => cat));
    expect(mouse.canEat(cat), isFalse);
    expect(cat.canEat(mouse), isTrue);
    world.tick(Plan.feed(mouse, cat));
    expect(mouse.dead, isTrue);
    expect(cat.dead, isFalse);
  });

  test("Breeding test (animals)", () {
    Animal cat1 = TestAnimal();
    Animal cat2 = TestAnimal();
    World world = World();
    Animal mouse = HerbivoreTestAnimal();
    world.tick(Plan.group([
      Plan.addBeing(() => cat1),
      Plan.addBeing(() => cat2),
      Plan.addBeing(() => mouse),
      Plan.feed(mouse, cat2),
    ]));
    for (int index = 0; index < 28; index += 1) {
      Animal mouse = HerbivoreTestAnimal();
      world.tick(Plan.group([
        Plan.addBeing(() => mouse),
        Plan.feed(mouse, cat1),
      ]));
      expect(mouse.dead, isTrue);
    }
    print(cat1.health);
    expect(cat2.dead, isTrue);
    expect(cat1.dead, isFalse);
    expect(world.all.length, 2);
  });
}

class TestPlant extends Plant {
  TestPlant(this.callback);
  Callback callback;
  TestPlant breed() => TestPlant((){});
  void tick(World w) {
   super.tick(w);
   callback();
  }
}

class TestAnimal extends Animal {
  TestAnimal breed() => TestAnimal();
}

class HerbivoreTestAnimal extends TestAnimal {
  bool canEat(Being being) {
    return being is! Animal;
  }
}
