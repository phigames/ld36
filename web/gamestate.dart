part of ld36;

abstract class GameState {

  void update(num time);

  void draw();

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

      introButton.pressed = false;
    } else if (freestyleButton.pressed) {
      gameState = new GameStateFreestyle();
      freestyleButton.pressed = false;
    } else if (challengeButton.pressed) {
      gameState = new GameStateChallenge();
      challengeButton.pressed = false;
    } else if (creditsButton.pressed) {
      //gameState = new GameStateCredits();
      creditsButton.pressed = false;
    }
  }

  void draw() {
    introButton.draw();
    freestyleButton.draw();
    challengeButton.draw();
    creditsButton.draw();
  }

}

class GameStateFreestyle extends GameState {

  MenuButton resumeButton, returnButton;
  bool menuOpened;

  GameStateFreestyle() {
    currentLevel = new Level(false);
    resumeButton = new MenuButton(-200, -60, 400, 50, '#888888', '#555555', '#CCCCCC', 'Resume');
    returnButton = new MenuButton(-200, 10, 400, 50, '#888888', '#555555', '#CCCCCC', 'Return to menu');
    menuOpened = false;
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
    }
  }


  void draw() {
    currentLevel.draw();
    if (menuOpened) {
      resumeButton.draw();
      returnButton.draw();
    }
  }

}

class GameStateChallenge extends GameState {

  int currentChallenge;
  MenuButton resumeButton, returnButton;
  bool menuOpened;
  ImageElement playImage;
  List<num> playRotations;
  bool won;

  GameStateChallenge() {
    currentLevel = new Level(true);
    currentChallenge = 0;
    newChallenge();
    resumeButton = new MenuButton(-200, -60, 400, 50, '#888888', '#555555', '#CCCCCC', 'Resume');
    returnButton = new MenuButton(-200, 10, 400, 50, '#888888', '#555555', '#CCCCCC', 'Return to menu');
    menuOpened = false;
    playImage = Resources.images['play'];
    won = false;
  }

  void newChallenge() {
    currentChallenge++;
    if (currentChallenge >= 9) {
      won = true;
    } else {
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
          currentLevel.looseGears.add(new Instrument('chord', -300, 100));
          currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
          currentLevel.challengeTargets.add(new ChallengeTarget('chord', -0.0025, 0.25));
          break;
        case 5:
          currentLevel.looseGears.add(new Instrument('chord', 300, 100));
          currentLevel.looseGears.add(new Instrument('drum', -300, -100));
          currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
          currentLevel.challengeTargets.add(new ChallengeTarget('drum', 0.00125));
          break;
        case 6:
          currentLevel.looseGears.add(new Instrument('chord', 300, 100));
          currentLevel.looseGears.add(new Instrument('drum', -300, -100));
          currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.0025));
          currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.0025, 0.5));
          break;
        case 7:
          currentLevel.looseGears.add(new Instrument('drum', 300, -100));
          currentLevel.looseGears.add(new Instrument('drum', -300, -100));
          currentLevel.challengeTargets.add(new ChallengeTarget('drum', 0.005));
          currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.005 * 2 / 3));
          break;
        case 8:
          currentLevel.looseGears.add(new Instrument('chord', 300, 100));
          currentLevel.looseGears.add(new Instrument('drum', -300, -100));
          currentLevel.challengeTargets.add(new ChallengeTarget('chord', 0.005));
          currentLevel.challengeTargets.add(new ChallengeTarget('drum', -0.005 / 3));
          break;
      }
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
          if (Input.leftMouseDown) {
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
      }
    }
  }


  void draw() {
    currentLevel.draw();
    if (menuOpened) {
      resumeButton.draw();
      returnButton.draw();
    }
    if (playRotations != null) {
      bufferContext.save();
      bufferContext.globalAlpha = 0.3;
      bufferContext.fillStyle = '#000000';
      bufferContext.fillRect(0, 0, canvasWidth, canvasHeight);
      bufferContext.restore();
    }
    if (currentLevel.challengeTargetsMet) {
      if (currentChallenge <= 8) {
        bufferContext.textAlign = 'center';
        bufferContext.font = '50px "Bree Serif"';
        bufferContext.fillStyle = '#000000';
        bufferContext.fillText('Challenge won! :)', canvasWidth / 2, canvasHeight / 2 - 50);
        bufferContext.font = '30px "Bree Serif"';
        bufferContext.fillText('Click anywhere for another one.', canvasWidth / 2, canvasHeight / 2 + 50);
      } else {
        bufferContext.font = '80px "Bree Serif"';
        bufferContext.textAlign = 'center';
        bufferContext.fillStyle = '#000000';
        bufferContext.fillText('You\'ve won them all!', canvasWidth / 2, canvasHeight / 2 - 30);
        bufferContext.font = '50px "Bree Serif"';
        bufferContext.fillText('Good job!', canvasWidth / 2, canvasHeight / 2 + 50);
      }
    } else {
      bufferContext.drawImage(playImage, canvasWidth - 124, 10);
    }
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