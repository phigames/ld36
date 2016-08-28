part of ld36;

class Level {

  Gear motorGear;
  List<Gear> looseGears;
  Gear placingGear;
  List<GearButton> gearButtons;
  List<InstrumentButton> instrumentButtons;
  GearTrash gearTrash;
  num offsetX, offsetY;
  num offsetMovingX, offsetMovingY;
  bool challenge;
  List<ChallengeTarget> challengeTargets;
  bool challengeTargetsMet;

  Level(this.challenge) {
    motorGear = new Gear(5, 0, 0);
    motorGear.rotationSpeed = 0.005;
    looseGears = new List<Gear>();
    if (!challenge) {
      looseGears.add(new Instrument('chord', 300, 100));
      looseGears.add(new Instrument('drum', -300, -100));
      looseGears.add(new Instrument('box', -300, 100));
    }
    gearButtons = new List<GearButton>();
    gearButtons.add(new GearButton(4, 50));
    gearButtons.add(new GearButton(5, 130));
    gearButtons.add(new GearButton(6, 210));
    gearButtons.add(new GearButton(8, 290));
    if (!challenge) {
      instrumentButtons = new List<InstrumentButton>();
      instrumentButtons.add(new InstrumentButton('chord', 210));
      instrumentButtons.add(new InstrumentButton('drum', 130));
      instrumentButtons.add(new InstrumentButton('box', 50));
    }
    gearTrash = new GearTrash();
    offsetX = canvasWidth / 2;
    offsetY = canvasHeight / 2;
    offsetMovingX = Input.mouseX;
    offsetMovingY = Input.mouseY;
  }

  void resetHighlights() {
    motorGear.resetHighlight();
    for (int i = 0; i < looseGears.length; i++) {
      looseGears[i].resetHighlight();
    }
  }

  void checkChallengeTargets() {
    for (int i = 0; i < challengeTargets.length; i++) {
      challengeTargets[i].met = false;
    }
    List<Instrument> instruments = motorGear.getInstruments();
    for (int i = 0; i < instruments.length; i++) {
      for (int j = 0; j < challengeTargets.length; j++) {
        if (!challengeTargets[j].met && challengeTargets[j].isMetBy(instruments[i])) {
          challengeTargets[j].met = true;
        }
      }
    }
    for (int i = 0; i < challengeTargets.length; i++) {
      if (!challengeTargets[i].met) {
        challengeTargetsMet = false;
        return;
      }
    }
    challengeTargetsMet = true;
  }

  void update(num time) {
    if (Input.rightMouseDown) {
      offsetX += Input.mouseX - offsetMovingX;
      offsetY += Input.mouseY - offsetMovingY;
    }
    offsetMovingX = Input.mouseX;
    offsetMovingY = Input.mouseY;
    if (!(challenge && placingGear is Instrument)) {
      gearTrash.update();
    }
    resetHighlights();
    if (placingGear != null) {
      placingGear.positionX = Input.mouseX - offsetX;
      placingGear.positionY = Input.mouseY - offsetY;
      // check for top-bottom connection
      Gear gluable = motorGear.getGluableGear(placingGear);
      /*for (int i = 0; i < looseGears.length && gluable == null; i++) {
        gluable = looseGears[i].getGluableGear(placingGear);
      }*/
      if (gluable != null && gluable.number > placingGear.number + 1 && gluable.gluedGears.length == 0) {
        if (Input.leftMouseDown) {
          gluable.glue(placingGear);
          placingGear = null;
          Input.leftMouseDown = false;
        } else {
          gluable.highlight = 2;
        }
      } else {
        // check for side connection
        Gear connectable = motorGear.getConnectableGear(placingGear);
        /*for (int i = 0; i < looseGears.length && connectable == null; i++) {
          connectable = looseGears[i].getConnectableGear(placingGear);
        }*/
        if (connectable != null) {
          // check for additional side connections with loose gears
          Gear loose;
          for (int i = 0; i < looseGears.length && loose == null; i++) {
            loose = looseGears[i].getConnectableGear(placingGear);
          }
          if (Input.leftMouseDown) {
            connectable.connect(placingGear);
            if (loose != null) {
              placingGear.connect(loose);
              looseGears.remove(loose);
            }
            placingGear = null;
            if (challenge) {
              checkChallengeTargets();
            }
            Input.leftMouseDown = false;
          } else {
            connectable.highlight = 1;
            if (loose != null) {
              loose.highlight = 1;
            }
          }
        } else if (Input.leftMouseDown) {
          looseGears.add(placingGear);
          placingGear = null;
          Input.leftMouseDown = false;
        }
      }
    } else {
      // removing gears
      Gear intersecting = motorGear.getIntersectingGear(Input.mouseX - offsetX, Input.mouseY - offsetY);
      for (int i = 0; i < looseGears.length && intersecting == null; i++) {
        intersecting = looseGears[i].getIntersectingGear(Input.mouseX - offsetX, Input.mouseY - offsetY);
      }
      if (intersecting != null && intersecting != motorGear) {
        if (Input.leftMouseDown) {
          if (intersecting.parent != null) {
            if (intersecting.parent.gluedGears.contains(intersecting)) {
              intersecting.parent.gluedGears.remove(intersecting);
            } else if (intersecting.parent.connectedGears.contains(intersecting)) {
              intersecting.parent.connectedGears.remove(intersecting);
            }
            intersecting.parent = null;
          } else {
            looseGears.remove(intersecting);
          }
          intersecting.rotationSpeed = 0;
          intersecting.updateChildren();
          intersecting.releaseChildren();
          placingGear = intersecting;
          if (challenge) {
            checkChallengeTargets();
          }
          Input.leftMouseDown = false;
        } else {
          intersecting.highlight = 1;
        }
      }
    }
    motorGear.update(time);
    for (int i = 0; i < looseGears.length; i++) {
      looseGears[i].update(time);
    }
    if (placingGear != null) {
      placingGear.update(time);
    }
    for (int i = 0; i < gearButtons.length; i++) {
      gearButtons[i].update();
    }
    if (!challenge) {
      for (int i = 0; i < instrumentButtons.length; i++) {
        instrumentButtons[i].update();
      }
    }
  }

  void draw() {
    motorGear.draw();
    for (int i = 0; i < looseGears.length; i++) {
      looseGears[i].draw();
    }
    if (placingGear != null) {
      if (!(challenge && placingGear is Instrument)) {
        gearTrash.draw();
      }
      placingGear.draw();
    } else {
      for (int i = 0; i < gearButtons.length; i++) {
        gearButtons[i].draw();
      }
      if (!challenge) {
        for (int i = 0; i < instrumentButtons.length; i++) {
          instrumentButtons[i].draw();
        }
      }
    }
  }

}

class GearButton {

  int number;
  num positionX;
  num positionY;
  num size;
  ImageElement image;
  bool highlight;

  GearButton(this.number, this.positionX) {
    positionY = canvasHeight - 30;
    image = Resources.images['gear_${number}'];
    /*switch (number) {
      case 4:
        size = 38;
        break;
      case 5:
        size = 48;
        break;
      case 6:
        size = 57;
        break;
      case 8:
        size = 75;
        break;
    }*/
    size = 40;
    highlight = false;
  }

  void update() {
    positionY = canvasHeight - 40;
    if (Input.mouseX >= positionX - size && Input.mouseX < positionX + size &&
        Input.mouseY >= positionY - size && Input.mouseY < positionY + size) {
      highlight = true;
      if (Input.leftMouseDown) {
        currentLevel.placingGear = new Gear(number, Input.mouseX, Input.mouseY);
        Input.leftMouseDown = false;
      }
    } else {
      highlight = false;
    }
  }

  void draw() {
    bufferContext.save();
    if (highlight) {
      bufferContext.drawImage(image, positionX - image.naturalWidth / 2, positionY - 50);
    } else {
      bufferContext.globalAlpha = 0.5;
      bufferContext.drawImage(image, positionX - image.naturalWidth / 2, positionY);
    }
    bufferContext.restore();
  }

}

class InstrumentButton {

  String type;
  num positionX;
  num positionY;
  num size;
  ImageElement image;
  bool highlight;

  InstrumentButton(this.type, this.positionX) {
    positionY = canvasHeight - 30;
    //size = 48;
    size = 40;
    image = Resources.images[type];
    highlight = false;
  }

  void update() {
    positionY = canvasHeight - 40;
    if (Input.mouseX >= canvasWidth - positionX - size && Input.mouseX < canvasWidth - positionX + size &&
        Input.mouseY >= positionY - size && Input.mouseY < positionY + size) {
      highlight = true;
      if (Input.leftMouseDown) {
        currentLevel.placingGear = new Instrument(type, Input.mouseX, Input.mouseY);
        Input.leftMouseDown = false;
      }
    } else {
      highlight = false;
    }
  }

  void draw() {
    bufferContext.save();
    if (highlight) {
      bufferContext.drawImage(image, canvasWidth - positionX - image.naturalWidth / 2, positionY - 50);
    } else {
      bufferContext.globalAlpha = 0.5;
      bufferContext.drawImage(image, canvasWidth - positionX - image.naturalWidth / 2, positionY);
    }
    bufferContext.restore();
  }

}

class GearTrash {

  num positionX;
  num positionY;
  ImageElement image;

  GearTrash() {
    positionX = canvasWidth - 143;
    positionY = canvasHeight - 198;
    image = Resources.images['trash'];
  }

  void update() {
    if (currentLevel.placingGear != null && Input.leftMouseDown &&
        Input.mouseX >= positionX && Input.mouseX < positionX + 143 &&
        Input.mouseY >= positionY && Input.mouseY < positionY + 198) {
      currentLevel.placingGear = null;
      currentLevel.resetHighlights();
      Input.leftMouseDown = false;
    }
  }

  void draw() {
    positionX = canvasWidth - 143;
    positionY = canvasHeight - 198;
    bufferContext.drawImage(image, positionX, positionY);
  }

}