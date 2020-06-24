abstract class Being {
  bool _dead = false;
  void _tick(World W) {}
}

typedef PlanCallback = void Function(World w);
typedef AnimalFactory = Animal Function();
typedef PlantFactory = Plant Function();
typedef Callback = void Function();

class Plan {
  Plan(this._callback);
  factory Plan.idle() => Plan((World w) {});
  factory Plan.addPlant(PlantFactory create) => Plan((World w) {w._addPlant(create);});
  factory Plan.addAnimal(AnimalFactory create) => Plan((World w) {w._addAnimal(create);});
  factory Plan.feed(Animal a, Being f) => Plan((World w) {
    assert(w.all.contains(a));
    assert(w.all.contains(f));
    if (a.canEat(f)) {
      a.eat(f);
    } else if (f is Animal && f.canEat(a)) {
      f.eat(a);
    }
  });
  factory Plan.group(List<Plan> plans) => Plan((World w) {
    for(Plan plan in plans) {
      plan._callback(w);
    }
  });
  final PlanCallback _callback;
}

class World {
  Set<Being> _beings = {};
  void _addPlant(PlantFactory create) {
    _beings.add(create());
  }
  void _addAnimal(AnimalFactory create) {
    _beings.add(create());
  }
  void tick(Plan plan) {
    plan._callback(this);
    for (Being being in _beings) {
      being._tick(this);
    }
  }
  Set<Being> get all => _beings.where((Being being) => !being._dead).toSet();
}

abstract class Plant extends Being {
  /// Should be entirely based on [runtimeType]
  int ticks = 0;
  Plant create();
  void _tick(World w) {
    ticks++;
    if(ticks == 5) {
      w._addPlant(create);
    }
  }
  PlantType get type;
}

abstract class Animal extends Being {
  /// For non-cannabalistic [Animal]s (cannabalistic ones don't call [super.canEat])
  bool canEat(Being being) {
    return being is! Animal || !((being as Animal).type == type);
  }

  void eat(Being other) {
    assert(canEat(other));
    other._dead = true;
  }

  /// Should be entirely based on [runtimeType] 
  AnimalType get type;

  // an [int]? a List<[Being]>?
  var _food;
}

class TestPlant extends Plant {
  PlantType get type => PlantType.test;
  TestPlant(this.callback);
  Callback callback;
  TestPlant create() => TestPlant((){});
  void _tick(World w) {
   super._tick(w);
   callback();
  }
}

class TestAnimal extends Animal{
  AnimalType get type => AnimalType.test;
}

enum AnimalType { test }
enum PlantType { test }