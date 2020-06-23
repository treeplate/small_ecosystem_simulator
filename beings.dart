abstract class Being {
  bool _dead = false;
  void _tick() {}
}
class Plan {
  Plan(this._callback);
  factory Plan.idle() => Plan((World w) {});
  factory Plan.addPlant(Plant Function() create) => Plan((World w) {w._addPlant(create);});
  factory Plan.addAnimal(Animal Function() create) => Plan((World w) {w._addAnimal(create);});
  final void Function(World w) _callback;
}
class World {
  Set<Being> _beings = {};
  void _addPlant(Plant Function() create) {
    _beings.add(create());
  }
  void _addAnimal(Animal Function() create) {
    _beings.add(create());
  }
  void tick(Plan plan) {
    plan._callback(this);
    for (Being being in _beings) {
      being._tick();
    }
  }
  Set<Being> get all => _beings.where((Being being) => !being._dead).toSet();
}
abstract class Plant extends Being {
  /// Should be entirely based on [runtimeType]
  PlantType get type;
}
abstract class Animal extends Being {
  ///For non-carniverous [Animal]s (carniverous ones don't call [super.canEat])
  bool canEat(Being being) {
    return being is! Animal || !((being as Animal).type == type);
  }
  /// Should be entirely based on [runtimeType] 
  AnimalType get type;
  // an [int]? a List<[Being]>?
  var _food;
}

class TestPlant extends Plant {
  PlantType get type => PlantType.test;
}

class TestAnimal extends Animal{
  AnimalType get type => AnimalType.test;
}
enum AnimalType { test }
enum PlantType { test }