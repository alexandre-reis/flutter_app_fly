import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappfly/components/backyard.dart';
import 'package:flutterappfly/components/fly.dart';

class GameLoop extends Game {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;
  Backyard backyard;

  GameLoop() {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());
    backyard = Backyard(this);
    spawnFly();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    flies.add(Fly(this, x, y));
  }

  void render(Canvas canvas) {
//    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
//    Paint bgPaint = Paint();
//    bgPaint.color = Color(0xff576574);
//    canvas.drawRect(bgRect, bgPaint);

    backyard.render(canvas);

    flies.forEach((fly) {
      fly.render(canvas);
    });
  }

  void update(double t) {
    flies.forEach((fly) {
      fly.update(t);
    });
    flies.removeWhere((f) => f.isOffScreen);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails details) {
    flies.forEach((fly) {
      if (fly.flyRect.contains(details.globalPosition)) {
        fly.onTapDown();
        spawnFly();
      }
    });
  }
}
