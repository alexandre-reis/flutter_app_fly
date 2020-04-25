import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutterappfly/game_loop.dart';


class HomeView {
  final GameLoop game;
  Rect titleRect;
  Sprite titleSprite;

  HomeView(this.game) {
    titleRect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 2) - (game.tileSize * 4),
      game.tileSize * 7,
      game.tileSize * 4,
    );
    titleSprite = Sprite('branding/title.png');
  }

  void render(Canvas canvas) {
    titleSprite.renderRect(canvas, titleRect);
  }

  void update(double time) {}
}