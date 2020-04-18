import 'dart:ui';

import 'package:flutterappfly/game_loop.dart';

class Fly {
  Rect flyRect;
  Paint flyPaint;
  final GameLoop gameLoop;
  bool isDead = false;
  bool isOffScreen = false;

  Fly(this.gameLoop, double x, double y) {
    flyRect = Rect.fromLTWH(x, y, gameLoop.tileSize, gameLoop.tileSize);
    flyPaint = Paint();
    flyPaint.color = Color(0xff6ab04c);
  }

  void render(Canvas canvas) {
    canvas.drawRect(flyRect, flyPaint);
  }

  void update(double time) {
    if (isDead) {
      flyRect = flyRect.translate(0, gameLoop.tileSize * 12 * time);

      if (flyRect.top > gameLoop.screenSize.height) {
        isOffScreen = true;
      }
    }
  }

  void onTapDown() async {
    isDead = true;
    flyPaint.color = Color(0xffff4757);
  }
}
