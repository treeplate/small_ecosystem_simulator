import 'package:meta/meta.dart';
import 'package:test/test.dart';

typedef PlanCallback = void Function(World w);
typedef BeingFactory = Being Function();
typedef Callback = void Function();

class Plan {
  Plan(this._callback);
  
  factory Plan.idle() => Plan((World w) {});

  factory Plan.addBeing(BeingFactory create) => Plan((World w) {w._addBeing(create);});

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
    for (Plan plan in plans) {
      plan._callback(w);
    }
  });

  final PlanCallback _callback;
}

class World {
  Set<Being> _beings = {};

  void _addBeing(BeingFactory create) {
    Being being = create();
    assert(!being.dead);
    assert(being.age == 0);
    _beings.add(being);
  }

  void tick(Plan plan) {
    assert(_afterPlans == null);
    _afterPlans = [];
    plan._callback(this);
    for (Being being in all) {
      being.tick(this);
    }
    Plan.group(_afterPlans)._callback(this);
    _afterPlans = null;
  }
  
  List<Plan> _afterPlans;
  Set<Being> get all => _beings.where((Being being) => !being.dead).toSet();
}

abstract class Being {
  int get health => _health;
  int _health = 10;
  
  bool get dead => _health <= 0;

  int get age => _ticks;
  int _ticks = 0;

  Being breed();

  @protected
  @mustCallSuper
  void tick(World w) {
    _health--;
    _ticks++;
  }
}

abstract class Plant extends Being {
  void tick(World w) {
    super.tick(w);
    if (_ticks % 5 == 0) {
      w._afterPlans.add(Plan.addBeing(breed));
    }
  }
}

abstract class Animal extends Being {
  /// For non-cannabalistic [Animal]s (cannabalistic ones don't call [super.canEat])
  bool canEat(Being being) {
    return being.runtimeType != runtimeType;
  }

  void eat(Being other) {
    assert(canEat(other));
    _health += other._health;
    other._health = 0;
    _food.add(other);
  }

  void tick(World w) {
    super.tick(w);
    if (age == 20 && health > 50) {
      if (w._beings.any((Being other) => other != this && other.runtimeType == runtimeType)) {
        w._afterPlans.add(Plan.addBeing(breed));
      }
    }
  }

  List<Being> _food = <Being>[];
}
