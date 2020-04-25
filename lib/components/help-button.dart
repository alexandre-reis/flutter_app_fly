import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutterappfly/game_loop.dart';
import 'package:flutterappfly/view/view.dart';


class HelpButton {
  final GameLoop game;
  Rect rect;
  Sprite sprite;

  HelpButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * .25,
      game.screenSize.height - (game.tileSize * 1.25),
      game.tileSize,
      game.tileSize,
    );
    sprite = Sprite('ui/icon-help.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void onTapDown() {
    game.activeView = View.help;
  }
}