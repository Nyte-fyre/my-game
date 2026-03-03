import 'package:flame/components.dart';
import 'path_of_fyre_game.dart';
import 'enemy.dart';
import 'sky.dart';

class EnemySpawner extends Component with HasGameReference<PathOfFyreGame> {
  final Sky target;
  double _spawnTimer = 0;
  double _spawnInterval = 3.0;
  int _enemiesSpawned = 0;

  EnemySpawner({required this.target});

  @override
  void update(double dt) {
    if (game.isGameOver || game.isLevelingUp) return;

    _spawnTimer += dt;

    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _enemiesSpawned++;
      game.add(Enemy(target: target));

      if (_enemiesSpawned % 5 == 0 && _spawnInterval > 0.5) {
        _spawnInterval -= 0.3;
      }
    }
  }
}
