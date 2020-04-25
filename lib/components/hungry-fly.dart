import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutterappfly/components/fly.dart';
import 'package:flutterappfly/game_loop.dart';

class HungryFly extends Fly {
  int tapsToKill = 1;
  HungryFly(GameLoop gameLoop, double x, double y) : super(gameLoop) {
    flyRect = Rect.fromLTWH(x, y, gameLoop.tileSize * 1.1, gameLoop.tileSize * 1.1);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/hungry-fly-1.png"));
    flyingSprite.add(Sprite("flies/hungry-fly-2.png"));
    deadSprite = Sprite("flies/hungry-fly-dead.png");
  }
}
