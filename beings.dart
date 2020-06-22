Set<Being> _beings = {};
abstract class Being {
  bool _dead = false;
  static Set<Being> get all => _beings.where((Being being) => !being._dead);
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
  bool canEat(Being being) => super.canEat(being) && being is Plant; 
}
enum AnimalType { test }
enum PlantType { test }