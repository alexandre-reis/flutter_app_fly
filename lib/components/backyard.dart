import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutterappfly/game_loop.dart';

class Backyard {
  final GameLoop gameLoop;
  Sprite bgSprite;

  Rect bgRect;

  Backyard(this.gameLoop) {
    bgSprite = Sprite("bg/backyard.png");

    bgRect = Rect.fromLTWH(
        0,
        gameLoop.screenSize.height - (gameLoop.tileSize * 23),
        gameLoop.tileSize * 9,
        gameLoop.tileSize * 23);
  }

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }

  void update(double time) {}
}
