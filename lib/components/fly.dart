import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutterappfly/components/callout.dart';
import 'package:flutterappfly/game_loop.dart';
import 'package:flutterappfly/view/view.dart';

class Fly {
  Rect flyRect;
  final GameLoop gameLoop;
  bool isDead = false;
  bool isOffScreen = false;

  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;

  double get speed => gameLoop.tileSize * 3;

  Offset targetLocation;

  Callout callout;

  Fly(this.gameLoop) {
    setTargetLocation();

    callout = Callout(this);
  }

  void setTargetLocation() {
    double x = gameLoop.rnd.nextDouble() *
        (gameLoop.screenSize.width - (gameLoop.tileSize * 2.0));
    double y = gameLoop.rnd.nextDouble() *
        (gameLoop.screenSize.height - (gameLoop.tileSize * 2.0));
    targetLocation = Offset(x, y);
  }

  void render(Canvas canvas) {
    if (isDead) {
      deadSprite.renderRect(canvas, flyRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(canvas, flyRect.inflate(2));

      if (gameLoop.activeView == View.playing) {
        callout.render(canvas);
      }
    }
  }

  void update(double time) {
    if (isDead) {
      flyRect = flyRect.translate(0, gameLoop.tileSize * 12 * time);

      if (flyRect.top > gameLoop.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      flyingSpriteIndex += 30 * time;
      if (flyingSpriteIndex >= flyingSprite.length) {
        flyingSpriteIndex -= flyingSpriteIndex.toInt();
      }

      double stepDistance = speed * time;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }

      callout.update(time);
    }
  }

  void onTapDown() {

    if (!isDead) {
      isDead = true;

      if (gameLoop.activeView == View.playing) {
        gameLoop.score += 1;

        if (gameLoop.score > (gameLoop.storage.getInt('highscore') ?? 0)) {
          gameLoop.storage.setInt('highscore', gameLoop.score);
          gameLoop.highscoreDisplay.updateHighscore();
        }
      }
    }

  }

}
