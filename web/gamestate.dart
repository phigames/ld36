part of ld36;

abstract class GameState {

  void update(num time);

  void draw();

}

class GameStateLoading extends GameState {

  void update(num time) {
    if (Resources.doneLoading) {
      gameState = new GameStateMenu();
    }
  }

  void draw() {
    bufferContext.textAlign = 'center';
    bufferContext.font = '30px "Bree Serif"';
    bufferContext.fillStyle = '#000000';
    bufferContext.fillText('Loading...', canvasWidth / 2, canvasHeight / 2);
  }

}

class GameStateMenu extends GameState {

  MenuButton introButton, freestyleButton, challengeButton, creditsButton;

  GameStateMenu() {
    introButton = new MenuButton(-200, -95, 400, 50, '#BB8888', '#885555', '#FFCCCC', 'Intro');
    freestyleButton = new MenuButton(-200, -25, 190, 50, '#8888BB', '#555588', '#CCCCFF', 'Freestyle');
    challengeButton = new MenuButton(10, -25, 190, 50, '#8888BB', '#555588', '#CCCCFF', 'Challenge');
    creditsButton = new MenuButton(-200, 45, 400, 50, '#88BB88', '#558855', '#CCFFCC', 'Credits');
  }

  void update(num time) {
    introButton.update();
    freestyleButton.update();
    challengeButton.update();
    creditsButton.update();
    if (introButton.pressed) {
      gameState = new GameStateIntro();
      introButton.pressed = false;
    } else if (freestyleButton.pressed) {
      gameState = new GameStateFreestyle();
      freestyleButton.pressed = false;
    } else if (challengeButton.pressed) {
      gameState = new GameStateChallenge();
      challengeButton.pressed = false;
    } else if (creditsButton.pressed) {
      gameState = new GameStateCredits();
      creditsButton.pressed = false;
    }
  }

  void draw() {
    bufferContext.textAlign = 'center';
    bufferContext.font = '60px "Bree Serif"';
    bufferContext.fillStyle = '#444444';
    bufferContext.fillText('Sounds of Samos', canvasWidth / 2, canvasHeight / 2 - 180);
    introButton.draw();
    freestyleButton.draw();
    challengeButton.draw();
    creditsButton.draw();
    bufferContext.font = '15px "Bree Serif"';
    bufferContext.fillStyle = '#000000';
    bufferContext.fillText('made in 48h for Ludum Dare 36', canvasWidth / 2, canvasHeight / 2 + 170);
  }

}

class GameStateIntro extends GameState {

  ImageElement templeImage, squaresImage, gear1Image, gear2Image, gear3Image;
  num timer;

  GameStateIntro() {
    templeImage = Resources.images['temple'];
    squaresImage = Resources.images['squares'];
    gear1Image = Resources.images['gear_8'];
    gear2Image = Resources.images['gear_5'];
    gear3Image = Resources.images['gear_4'];
    timer = 0;
  }

  void update(num time) {
    timer += time / 1000;
    if (Input.leftMouseDown) {
      gameState = new GameStateMenu();
      Input.leftMouseDown = false;
    }
  }

  void draw() {
    bufferContext.save();
    bufferContext.globalAlpha = 0.5;
    bufferContext.drawImage(templeImage, canvasWidth / 2 - templeImage.naturalWidth / 2, canvasHeight / 2 - templeImage.naturalHeight / 2);
    bufferContext.globalAlpha = max(0, min(timer % 10 / 10, 1 - timer % 10 / 10)) / 2;
    bufferContext.drawImage(squaresImage, canvasWidth / 2 - 400 + sin(timer) * 80, canvasHeight / 2 + 400 - (timer % 10) * 80);
    bufferContext.globalAlpha = max(0, min((timer + 3) % 10 / 10, 1 - (timer + 3) % 10 / 10)) / 2;
    bufferContext.drawImage(gear1Image, canvasWidth / 2 + 200 + sin(timer + 3) * 80, canvasHeight / 2 + 200 - ((timer + 3) % 10) * 80);
    bufferContext.drawImage(gear2Image, canvasWidth / 2 + 300 + sin(timer + 3) * 80, canvasHeight / 2 + 300 - ((timer + 3) % 10) * 80);
    bufferContext.drawImage(gear3Image, canvasWidth / 2 + 145 + sin(timer + 3) * 80, canvasHeight / 2 + 250 - ((timer + 3) % 10) * 80);
    bufferContext.restore();
    bufferContext.textAlign = 'center';
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillStyle = '#000000';
    bufferContext.fillText('Thousands of years ago, philosophers in Samos', canvasWidth / 2, canvasHeight / 2 - 250, canvasWidth);
    bufferContext.fillText('reinvented mathematics and science.', canvasWidth / 2, canvasHeight / 2 - 220, canvasWidth);
    bufferContext.fillText('The concepts and methods they developed are still being used today.', canvasWidth / 2, canvasHeight / 2 - 180, canvasWidth);
    bufferContext.font = '25px "Bree Serif"';
    bufferContext.fillText('However, one ancient invention has been long forgotten.', canvasWidth / 2, canvasHeight / 2 - 130, canvasWidth);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('It is the most stunning piece of technology an archaeologist has ever laid eyes on.', canvasWidth / 2, canvasHeight / 2 - 60, canvasWidth);
    bufferContext.font = '40px "Bree Serif"';
    bufferContext.fillText('The world\'s first loop station.', canvasWidth / 2, canvasHeight / 2 + 50, canvasWidth);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('And now you are the chosen one to bring it back to life again.', canvasWidth / 2, canvasHeight / 2 + 150, canvasWidth);
    bufferContext.font = '10px "Bree Serif"';
    bufferContext.fillText('(Better be careful, that thing costs a f***ing fortune...)', canvasWidth / 2, canvasHeight / 2 + 200, canvasWidth);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('Click to continue.', canvasWidth / 2, canvasHeight / 2 + 288, canvasWidth);
  }

}

class GameStateFreestyle extends GameState {

  MenuButton resumeButton, returnButton;
  bool menuOpened;
  bool helpOpened;
  ImageElement helpImage;

  GameStateFreestyle() {
    currentLevel = new Level(false);
    resumeButton = new MenuButton(-200, -60, 400, 50, '#888888', '#555555', '#CCCCCC', 'Resume');
    returnButton = new MenuButton(-200, 10, 400, 50, '#888888', '#555555', '#CCCCCC', 'Return to menu');
    menuOpened = false;
    helpOpened = true;
    helpImage = Resources.images['help'];
  }

  void update(num time) {
    if (Input.escDown) {
      if (!menuOpened) {
        menuOpened = true;
      } else {
        menuOpened = false;
      }
      Input.escDown = false;
    }
    if (menuOpened) {
      resumeButton.update();
      returnButton.update();
      if (resumeButton.pressed) {
        menuOpened = false;
        resumeButton.pressed = false;
      } else if (returnButton.pressed) {
        gameState = new GameStateMenu();
        returnButton.pressed = false;
      }
    } else {
      currentLevel.update(time);
      if (!helpOpened) {
        if (Input.leftMouseDown && Input.mouseX > canvasWidth - 83 && Input.mouseX < canvasWidth - 10 &&
            Input.mouseY > 10 && Input.mouseY < 82) {
          helpOpened = true;
          Input.leftMouseDown = false;
        }
      } else if (Input.leftMouseDown && Input.mouseX > canvasWidth - 83 && Input.mouseX < canvasWidth - 10 &&
          Input.mouseY > 10 && Input.mouseY < 82) {
        helpOpened = false;
        Input.leftMouseDown = false;
      }
    }
  }


  void draw() {
    currentLevel.draw();
    if (menuOpened) {
      resumeButton.draw();
      returnButton.draw();
    } else {
      if (helpOpened) {
        bufferContext.font = '20px "Bree Serif"';
        bufferContext.fillStyle = '#000000';
        if (currentLevel.placingGear == null) {
          bufferContext.textAlign = 'left';
          bufferContext.fillText('Grab more gears down here.', 50, canvasHeight - 50);
          bufferContext.textAlign = 'right';
          bufferContext.fillText('Grab more instruments down here.', canvasWidth - 50, canvasHeight - 50);
        } else {
          bufferContext.textAlign = 'right';
          bufferContext.fillText('Throw unneeded gears in the trash.', canvasWidth - 50, canvasHeight - 110);
        }
        bufferContext.textAlign = 'right';
        bufferContext.fillText('Click the question mark to show/hide these hints.', canvasWidth - 100, 50);
        bufferContext.save();
        bufferContext.globalAlpha = 0.7;
        bufferContext.fillStyle = '#FFFFFF';
        bufferContext.fillRect(canvasWidth / 2 - 250, canvasHeight / 2 - 110, 500, 220);
        bufferContext.restore();
        bufferContext.textAlign = 'right';
        bufferContext.fillText('Move gears around', canvasWidth / 2 - 20, canvasHeight / 2 - 70);
        bufferContext.fillText('Move map around', canvasWidth / 2 - 20, canvasHeight / 2 - 40);
        bufferContext.fillText('Access menu', canvasWidth / 2 - 20, canvasHeight / 2 - 10);
        bufferContext.textAlign = 'left';
        bufferContext.fillText('[left mouse button]', canvasWidth / 2 + 20, canvasHeight / 2 - 70);
        bufferContext.fillText('[right mouse button]', canvasWidth / 2 + 20, canvasHeight / 2 - 40);
        bufferContext.fillText('[esc]', canvasWidth / 2 + 20, canvasHeight / 2 - 10);
        bufferContext.textAlign = 'center';
        bufferContext.fillText('It is possible to stack smaller gears on larger ones.', canvasWidth / 2, canvasHeight / 2 + 30);
        bufferContext.fillText('The sound of an instrument depends on', canvasWidth / 2, canvasHeight / 2 + 60);
        bufferContext.fillText('the rotational direction of its gear.', canvasWidth / 2, canvasHeight / 2 + 80);
      }
      bufferContext.save();
      bufferContext.globalAlpha = 0.5;
      if (helpOpened || (Input.mouseX > canvasWidth - 83 && Input.mouseX < canvasWidth - 10 &&
          Input.mouseY > 10 && Input.mouseY < 82)) {
        bufferContext.globalAlpha = 1;
      }
      bufferContext.drawImage(helpImage, canvasWidth - 83, 10);
      bufferContext.restore();
    }
  }

}

class GameStateChallenge extends GameState {

  int currentChallenge;
  MenuButton resumeButton, returnButton;
  bool menuOpened;
  bool helpOpened;
  ImageElement helpImage;
  ImageElement playImage;
  List<num> playRotations;

  GameStateChallenge() {
    currentLevel = new Level(true);
    currentChallenge = 0;
    newChallenge();
    resumeButton = new MenuButton(-200, -60, 400, 50, '#888888', '#555555', '#CCCCCC', 'Resume');
    returnButton = new MenuButton(-200, 10, 400, 50, '#888888', '#555555', '#CCCCCC', 'Return to menu');
    menuOpened = false;
    helpOpened = true;
    helpImage = Resources.images['help'];
    playImage = Resources.images['play'];
  }

  void newChallenge() {
    currentChallenge++;
    currentLevel.challengeTargets = new List<ChallengeTarget>();
    switch (currentChallenge) {
      case 1:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', -0.005));
        break;
      case 2:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
        break;
      case 3:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('chord', -300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', -0.005, 0.5));
        break;
      case 4:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005 / 2));
        break;
      case 5:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('chord', -300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', -0.005 / 2, 0.25));
        break;
      case 6:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('drum', -300, -100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('drum', 0.005 / 4));
        break;
      case 7:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('drum', -300, -100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005 / 2));
        currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.005 / 2, 0.5));
        break;
      case 8:
        currentLevel.looseGears.add(new Instrument('box', 300, -100));
        currentLevel.challengeTargets.add(new ChallengeTarget('box', 0.005 * 5 / 8));
        break;
      case 9:
        currentLevel.looseGears.add(new Instrument('box', 300, -100));
        currentLevel.looseGears.add(new Instrument('box', -300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('box', -0.005 * 5 / 8));
        currentLevel.challengeTargets.add(new ChallengeTarget('box', 0.005 * 5 / 16));
        break;
      case 10:
        currentLevel.looseGears.add(new Instrument('drum', 300, -100));
        currentLevel.looseGears.add(new Instrument('drum', -300, -100));
        currentLevel.challengeTargets.add(new ChallengeTarget('drum', 0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.005 * 2 / 3));
        break;
      case 11:
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('drum', -300, -100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.005 / 3));
        break;
      case 12:
        currentLevel.looseGears.add(new Instrument('chord', 300, -100));
        currentLevel.looseGears.add(new Instrument('box', -300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005 * 3 / 8));
        currentLevel.challengeTargets.add(new ChallengeTarget('box', -0.005 * 5 / 8));
        break;
      case 13:
        currentLevel.looseGears.add(new Instrument('chord', 300, -100));
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('box', -300, 100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', -0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005 / 4, 0.125));
        currentLevel.challengeTargets.add(new ChallengeTarget('box', 0.005 * 5 / 8));
        break;
      case 14:
        currentLevel.looseGears.add(new Instrument('chord', 300, -100));
        currentLevel.looseGears.add(new Instrument('chord', 300, 100));
        currentLevel.looseGears.add(new Instrument('box', -300, 100));
        currentLevel.looseGears.add(new Instrument('drum', -300, -100));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
        currentLevel.challengeTargets.add(new ChallengeTarget('chord', -0.005 * 5 / 16, 0.125));
        currentLevel.challengeTargets.add(new ChallengeTarget('box', 0.005 * 15 / 64));
        currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.005 / 3));
        break;
    }
  }

  void playChallenge(num time) {
    for (int i = 0; i < playRotations.length; i++) {
      playRotations[i] += currentLevel.challengeTargets[i].rotationSpeed.abs() * time;
      if (playRotations[i] >= PI * 2 / 5) {
        currentLevel.challengeTargets[i].sound.currentTime = 0;
        currentLevel.challengeTargets[i].sound.play();
        playRotations[i] -= PI * 2 / 5;
      }
    }
  }

  void update(num time) {
    if (Input.escDown) {
      if (!menuOpened) {
        menuOpened = true;
      } else {
        menuOpened = false;
      }
      Input.escDown = false;
    }
    if (menuOpened) {
      resumeButton.update();
      returnButton.update();
      if (resumeButton.pressed) {
        menuOpened = false;
        resumeButton.pressed = false;
      } else if (returnButton.pressed) {
        gameState = new GameStateMenu();
        returnButton.pressed = false;
      }
    } else {
      if (playRotations != null) {
        if (Input.leftMouseDown) {
          playRotations = null;
          Input.leftMouseDown = false;
        } else {
          playChallenge(time);
        }
      } else {
        if (currentLevel.challengeTargetsMet) {
          if (currentChallenge < 14 && Input.leftMouseDown) {
            currentLevel = new Level(true);
            newChallenge();
            Input.leftMouseDown = false;
          }
        } else {
          if (Input.leftMouseDown &&
              Input.mouseX > canvasWidth - 124 && Input.mouseX < canvasWidth - 10 &&
              Input.mouseY > 10 && Input.mouseY < 83) {
            playRotations = new List<num>();
            for (int i = 0; i < currentLevel.challengeTargets.length; i++) {
              playRotations.add(currentLevel.challengeTargets[i].rotationOffset * PI * 2 / 5);
            }
            Input.leftMouseDown = false;
          }
        }
        currentLevel.update(time);
        if (!helpOpened) {
          if (Input.leftMouseDown && Input.mouseX > canvasWidth - 83 && Input.mouseX < canvasWidth - 10 &&
              Input.mouseY > 100 && Input.mouseY < 172) {
            helpOpened = true;
            Input.leftMouseDown = false;
          }
        } else if (Input.leftMouseDown && Input.mouseX > canvasWidth - 83 && Input.mouseX < canvasWidth - 10 &&
            Input.mouseY > 100 && Input.mouseY < 172) {
          helpOpened = false;
          Input.leftMouseDown = false;
        }
      }
    }
  }


  void draw() {
    currentLevel.draw();
    if (menuOpened) {
      resumeButton.draw();
      returnButton.draw();
    } else {
      if (helpOpened) {
        bufferContext.font = '20px "Bree Serif"';
        bufferContext.fillStyle = '#000000';
        if (currentLevel.placingGear == null) {
          bufferContext.textAlign = 'left';
          bufferContext.fillText('Grab more gears down here.', 50, canvasHeight - 50);
        } else if (!(currentLevel.placingGear is Instrument)) {
          bufferContext.textAlign = 'right';
          bufferContext.fillText('Throw unneeded gears in the trash.', canvasWidth - 50, canvasHeight - 110);
        }
        bufferContext.textAlign = 'right';
        bufferContext.fillText('Listen to the rhythm you\'re trying to replicate.', canvasWidth - 140, 50);
        bufferContext.textAlign = 'right';
        bufferContext.fillText('Click the question mark to show/hide these hints.', canvasWidth - 100, 140);
        bufferContext.save();
        bufferContext.globalAlpha = 0.7;
        bufferContext.fillStyle = '#FFFFFF';
        bufferContext.fillRect(canvasWidth / 2 - 250, canvasHeight / 2 - 110, 500, 220);
        bufferContext.restore();
        bufferContext.textAlign = 'right';
        bufferContext.fillText('Move gears around', canvasWidth / 2 - 20, canvasHeight / 2 - 70);
        bufferContext.fillText('Move map around', canvasWidth / 2 - 20, canvasHeight / 2 - 40);
        bufferContext.fillText('Access menu', canvasWidth / 2 - 20, canvasHeight / 2 - 10);
        bufferContext.textAlign = 'left';
        bufferContext.fillText('[left mouse button]', canvasWidth / 2 + 20, canvasHeight / 2 - 70);
        bufferContext.fillText('[right mouse button]', canvasWidth / 2 + 20, canvasHeight / 2 - 40);
        bufferContext.fillText('[esc]', canvasWidth / 2 + 20, canvasHeight / 2 - 10);
        bufferContext.textAlign = 'center';
        bufferContext.fillText('It is possible to stack smaller gears on larger ones.', canvasWidth / 2, canvasHeight / 2 + 30);
        bufferContext.fillText('The sound of an instrument depends on', canvasWidth / 2, canvasHeight / 2 + 60);
        bufferContext.fillText('the rotational direction of its gear.', canvasWidth / 2, canvasHeight / 2 + 80);
      }
      bufferContext.save();
      bufferContext.globalAlpha = 0.5;
      if (helpOpened || (Input.mouseX > canvasWidth - 83 && Input.mouseX < canvasWidth - 10 &&
          Input.mouseY > 100 && Input.mouseY < 172)) {
        bufferContext.globalAlpha = 1;
      }
      bufferContext.drawImage(helpImage, canvasWidth - 83, 100);
      bufferContext.restore();
    }
    if (playRotations != null) {
      bufferContext.save();
      bufferContext.globalAlpha = 0.3;
      bufferContext.fillStyle = '#000000';
      bufferContext.fillRect(0, 0, canvasWidth, canvasHeight);
      bufferContext.restore();
    }
    if (currentLevel.challengeTargetsMet) {
      if (currentChallenge < 14) {
        bufferContext.textAlign = 'center';
        bufferContext.font = '50px "Bree Serif"';
        bufferContext.fillStyle = '#000000';
        bufferContext.fillText('Challenge won!', canvasWidth / 2, canvasHeight / 2 - 50);
        bufferContext.font = '30px "Bree Serif"';
        bufferContext.fillText('Click to continue.', canvasWidth / 2, canvasHeight / 2 + 50);
      } else {
        bufferContext.font = '80px "Bree Serif"';
        bufferContext.textAlign = 'center';
        bufferContext.fillStyle = '#000000';
        bufferContext.fillText('You\'ve won them all!', canvasWidth / 2, canvasHeight / 2 - 30);
        bufferContext.font = '50px "Bree Serif"';
        bufferContext.fillText('Good job!', canvasWidth / 2, canvasHeight / 2 + 50);
      }
    } else {
      bufferContext.save();
      bufferContext.globalAlpha = 0.5;
      if (playRotations != null || (Input.mouseX > canvasWidth - 124 && Input.mouseX < canvasWidth - 10 &&
          Input.mouseY > 10 && Input.mouseY < 83)) {
        bufferContext.globalAlpha = 1;
      }
      bufferContext.drawImage(playImage, canvasWidth - 124, 10);
      bufferContext.restore();
    }
    bufferContext.textAlign = 'left';
    bufferContext.font = '50px "Bree Serif"';
    bufferContext.fillStyle = '#000000';
    bufferContext.fillText('Challenge ${currentChallenge}', 20, 60);
  }

}

class GameStateCredits extends GameState {

  void update(num time) {
    if (Input.leftMouseDown) {
      gameState = new GameStateMenu();
      Input.leftMouseDown = false;
    }
  }

  void draw() {
    bufferContext.textAlign = 'center';
    bufferContext.font = '60px "Bree Serif"';
    bufferContext.fillStyle = '#444444';
    bufferContext.fillText('Sounds of Samos', canvasWidth / 2, canvasHeight / 2 - 180);
    bufferContext.textAlign = 'right';
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillStyle = '#000000';
    bufferContext.fillText('Programming, graphics & sound', canvasWidth / 2 - 20, canvasHeight / 2 - 70);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('Font', canvasWidth / 2 - 20, canvasHeight / 2 - 30);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('Technology', canvasWidth / 2 - 20, canvasHeight / 2 + 10);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('Special thanks to', canvasWidth / 2 - 20, canvasHeight / 2 + 70);
    bufferContext.textAlign = 'left';
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('phi', canvasWidth / 2 + 20, canvasHeight / 2 - 70);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('Bree Serif by TypeTogether', canvasWidth / 2 + 20, canvasHeight / 2 - 30);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('HTML5 & Dart', canvasWidth / 2 + 20, canvasHeight / 2 + 10);
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('you, for playing <3', canvasWidth / 2 + 20, canvasHeight / 2 + 70);
    bufferContext.textAlign = 'center';
    bufferContext.font = '20px "Bree Serif"';
    bufferContext.fillText('Click to continue.', canvasWidth / 2, canvasHeight / 2 + 150);
  }

}

class ChallengeTarget {

  String instrumentType;
  num rotationSpeed;
  num rotationOffset;
  AudioElement sound;
  bool met;

  ChallengeTarget(this.instrumentType, this.rotationSpeed, [this.rotationOffset = 0]) {
    if (rotationSpeed > 0) {
      sound = Resources.sounds['${instrumentType}_low'];
    } else {
      sound = Resources.sounds['${instrumentType}_high'];
    }
    met = false;
  }

  bool isMetBy(Instrument instrument) {
    return instrument.type == instrumentType && (instrument.rotationSpeed - rotationSpeed).abs() < 0.00001;
  }

}

class MenuButton {

  num positionX, positionY;
  num width, height;
  List<Point<num>> points;
  String color;
  String strokeColor;
  String highlightColor;
  String text;
  bool hovered;
  bool pressed;

  MenuButton(this.positionX, this.positionY, this.width, this.height, this.color, this.strokeColor, this.highlightColor, this.text) {
    points = new List<Point<num>>();
    points.add(new Point(positionX + random.nextDouble() * 20 - 10, positionY + random.nextDouble() * 10 - 5));
    points.add(new Point(positionX + width + random.nextDouble() * 20 - 10, positionY + random.nextDouble() * 10 - 5));
    points.add(new Point(positionX + width + random.nextDouble() * 20 - 10, positionY + height + random.nextDouble() * 10 - 5));
    points.add(new Point(positionX + random.nextDouble() * 20 - 10, positionY + height + random.nextDouble() * 10 - 5));
    pressed = false;
  }

  void update() {
    if (Input.mouseX >= positionX + canvasWidth / 2 && Input.mouseX < positionX + width + canvasWidth / 2 &&
        Input.mouseY >= positionY + canvasHeight / 2 && Input.mouseY < positionY + height + canvasHeight / 2) {
      if (Input.leftMouseDown) {
        pressed = true;
        Input.leftMouseDown = false;
      } else {
        hovered = true;
      }
    } else {
      hovered = false;
    }
  }

  void draw() {
    bufferContext.beginPath();
    bufferContext.moveTo(points[0].x + canvasWidth / 2, points[0].y + canvasHeight / 2);
    for (int i = 1; i < points.length; i++) {
      bufferContext.lineTo(points[i].x + canvasWidth / 2, points[i].y + canvasHeight / 2);
    }
    bufferContext.closePath();
    if (hovered) {
      bufferContext.fillStyle = highlightColor;
    } else {
      bufferContext.fillStyle = color;
    }
    bufferContext.fill();
    bufferContext.lineWidth = 3;
    bufferContext.strokeStyle = strokeColor;
    bufferContext.stroke();
    bufferContext.font = '30px "Bree Serif"';
    bufferContext.textAlign = 'center';
    bufferContext.fillStyle = '#000000';
    bufferContext.fillText(text, positionX + width / 2 + canvasWidth / 2, positionY + height - 15 + canvasHeight / 2);
  }

}