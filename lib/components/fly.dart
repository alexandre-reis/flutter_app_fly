import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutterappfly/components/callout.dart';
import 'package:flutterappfly/game_loop.dart';
import 'package:flutterappfly/view/view.dart';
import 'dart:developer' as developer;

class Fly {
  Rect flyRect;
  final GameLoop gameLoop;
  bool isDead = false;
  bool isOffScreen = false;

  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;

  double get speed => gameLoop.tileSize * 3;
  int get pointValue => 1;
  int tapsToKill = 3;

  Offset targetLocation;

  Callout callout;

  Fly(this.gameLoop) {
    setTargetLocation();

    callout = Callout(this);
  }

  void setTargetLocation() {
    double x = gameLoop.rnd.nextDouble() * (gameLoop.screenSize.width - (gameLoop.tileSize * 1.35));
    double y = (gameLoop.rnd.nextDouble() * (gameLoop.screenSize.height - (gameLoop.tileSize * 2.85))) + (gameLoop.tileSize * 1.5);



    targetLocation = Offset(x, y);
  }

  void render(Canvas canvas) {
//    canvas.drawRect(
//        flyRect.inflate(flyRect.width / 2), Paint()..color = Color(0x77ffffff));

    if (isDead) {
      deadSprite.renderRect(canvas, flyRect.inflate(flyRect.width / 2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(canvas, flyRect.inflate(flyRect.width / 2));
      if (gameLoop.activeView == View.playing) {
        callout.render(canvas);
      }
    }

//    canvas.drawRect(flyRect, Paint()..color = Color(0x88000000));
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
    tapsToKill = tapsToKill - 1;
    if(tapsToKill == 0){
      developer.log('matou');
      isDead= true;
      if (!isDead) {
        Flame.audio
            .play('sfx/ouch${(gameLoop.rnd.nextInt(11) + 1).toString()}.ogg');
        isDead = true;

        if (gameLoop.soundButton.isEnabled) {
          Flame.audio.play(
              'sfx/ouch' + (gameLoop.rnd.nextInt(11) + 1).toString() + '.ogg');
        }

        if (gameLoop.activeView == View.playing) {
          gameLoop.score += pointValue;

          if (gameLoop.score > (gameLoop.storage.getInt('highscore') ?? 0)) {
            gameLoop.storage.setInt('highscore', gameLoop.score);
            gameLoop.highscoreDisplay.updateHighscore();
          }
        }
      }
    }

  }
}
