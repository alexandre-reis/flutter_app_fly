import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappfly/components/agile-fly.dart';
import 'package:flutterappfly/components/backyard.dart';
import 'package:flutterappfly/components/credits-button.dart';
import 'package:flutterappfly/components/drooler-fly.dart';
import 'package:flutterappfly/components/fly.dart';
import 'package:flutterappfly/components/help-button.dart';
import 'package:flutterappfly/components/house-fly.dart';
import 'package:flutterappfly/components/hungry-fly.dart';
import 'package:flutterappfly/components/macho-fly.dart';
import 'package:flutterappfly/components/score-display.dart';
import 'package:flutterappfly/components/start-button.dart';
import 'package:flutterappfly/controllers/spawner.dart';
import 'package:flutterappfly/view/credits-view.dart';
import 'package:flutterappfly/view/help-view.dart';
import 'package:flutterappfly/view/home-view.dart';
import 'package:flutterappfly/view/lost-view.dart';
import 'package:flutterappfly/view/view.dart';

class GameLoop extends Game {
  View activeView = View.home;

  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;
  Backyard backyard;

  HomeView homeView;
  LostView lostView;
  CreditsView creditsView;
  HelpView helpView;

  ScoreDisplay scoreDisplay;

  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;

  FlySpawner spawner;

  int score;

  GameLoop() {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    spawner = FlySpawner(this);

    backyard = Backyard(this);

    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);

    scoreDisplay = ScoreDisplay(this);

    score = 0;
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.0));
    double y = rnd.nextDouble() * (screenSize.height - (tileSize * 2.0));

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(AgileFly(this, x, y));
        break;
      case 2:
        flies.add(HungryFly(this, x, y));
        break;
      case 3:
        flies.add(DroolerFly(this, x, y));
        break;
      case 4:
        flies.add(MachoFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    backyard.render(canvas);

    if (activeView == View.playing) scoreDisplay.render(canvas);

    flies.forEach((fly) {
      fly.render(canvas);
    });

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      creditsButton.render(canvas);
      helpButton.render(canvas);
    }
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  void update(double t) {
    spawner.update(t);

    flies.forEach((fly) {
      fly.update(t);
    });
    flies.removeWhere((f) => f.isOffScreen);

    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails details) {
    if (startButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        score = 0;
        return;
      }
    }

    if (activeView == View.help || activeView == View.credits) {
      activeView = View.home;
      return;
    }

    // help button
    if (helpButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        return;
      }
    }

    // credits button
    if (creditsButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        return;
      }
    }

    bool didHitFly = false;
    List<Fly>.from(flies).forEach((fly) {
      if (fly.flyRect.contains(details.globalPosition) && !fly.isDead) {
        fly.onTapDown();
        didHitFly = !didHitFly;
        return;
      }
    });

    if (activeView == View.playing && !didHitFly) {
      activeView = View.lost;
    }
  }
}
