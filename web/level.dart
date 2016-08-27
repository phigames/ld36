part of ld36;

class Level {

  Gear motorGear;
  List<Gear> looseGears;
  Gear placingGear;
  List<GearButton> gearButtons;
  GearTrash gearTrash;
  num offsetX, offsetY;
  num offsetMovingX, offsetMovingY;

  Level() {
    motorGear = new Gear(5, 0, 0);
    motorGear.rotationSpeed = 0.005;
    looseGears = new List<Gear>();
    looseGears.add(new Instrument(300, 100, 'chord', 16, 72, 'chord_low', 'chord_high'));
    looseGears.add(new Instrument(-300, -100, 'drum', 39, 87, 'drum_low', 'drum_high'));
    gearButtons = new List<GearButton>();
    gearButtons.add(new GearButton(4, 50));
    gearButtons.add(new GearButton(5, 150));
    gearButtons.add(new GearButton(8, 285));
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

  void update(num time) {
    if (Input.rightMouseDown) {
      offsetX += Input.mouseX - offsetMovingX;
      offsetY += Input.mouseY - offsetMovingY;
    }
    offsetMovingX = Input.mouseX;
    offsetMovingY = Input.mouseY;
    gearTrash.update(time);
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
          looseGears.addAll(intersecting.gluedGears);
          looseGears.addAll(intersecting.connectedGears);
          for (int i = 0; i < intersecting.gluedGears.length; i++) {
            intersecting.gluedGears[i].parent = null;
          }
          intersecting.gluedGears.clear();
          for (int i = 0; i < intersecting.connectedGears.length; i++) {
            intersecting.connectedGears[i].parent = null;
          }
          intersecting.connectedGears.clear();
          placingGear = intersecting;
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
      gearButtons[i].update(time);
    }
  }

  void draw() {
    motorGear.draw();
    for (int i = 0; i < looseGears.length; i++) {
      looseGears[i].draw();
    }
    if (placingGear != null) {
      gearTrash.draw();
      placingGear.draw();
    }
    for (int i = 0; i < gearButtons.length; i++) {
      gearButtons[i].draw();
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
    switch (number) {
      case 4:
        size = 38;
        break;
      case 5:
        size = 48;
        break;
      case 8:
        size = 75;
        break;
    }
    highlight = false;
  }

  void update(num time) {
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
      bufferContext.drawImage(image, positionX - size, positionY - 50);
    } else {
      bufferContext.globalAlpha = 0.5;
      bufferContext.drawImage(image, positionX - size, positionY);
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

  void update(num time) {
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