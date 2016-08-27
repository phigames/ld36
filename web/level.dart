part of ld36;

class Level {

  Gear motorGear;
  List<Gear> looseGears;
  Gear placingGear;
  List<GearButton> gearButtons;

  Level() {
    motorGear = new Gear(5, 50, 200);
    motorGear.rotationSpeed = 0.005;
    looseGears = new List<Gear>();
    looseGears.add(new Instrument(500, 200, 'chord', 16, 72, 'chord_low', 'chord_high'));
    looseGears.add(new Instrument(600, 400, 'drum', 39, 87, 'drum_low', 'drum_high'));
    gearButtons = new List<GearButton>();
    gearButtons.add(new GearButton(4, 50, 410));
    gearButtons.add(new GearButton(5, 150, 410));
    gearButtons.add(new GearButton(8, 285, 410));
  }

  void update(num time) {
    if (placingGear != null) {
      placingGear.positionX = Input.mouseX;
      placingGear.positionY = Input.mouseY;
      motorGear.resetHighlight();
      for (int i = 0; i < looseGears.length; i++) {
        looseGears[i].resetHighlight();
      }
      // check for top-bottom connection
      Gear gluable = motorGear.getGluableGear(placingGear);
      /*for (int i = 0; i < looseGears.length && gluable == null; i++) {
        gluable = looseGears[i].getGluableGear(placingGear);
      }*/
      if (gluable != null && gluable.number > placingGear.number + 1 && gluable.gluedGears.length == 0) {
        if (Input.mouseDown) {
          gluable.glue(placingGear);
          placingGear = null;
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
          if (Input.mouseDown) {
            connectable.connect(placingGear);
            if (loose != null) {
              placingGear.connect(loose);
              looseGears.remove(loose);
            }
            placingGear = null;
          } else {
            connectable.highlight = 1;
            if (loose != null) {
              loose.highlight = 1;
            }
          }
        } else if (Input.mouseDown) {
          looseGears.add(placingGear);
          placingGear = null;
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

  GearButton(this.number, this.positionX, this.positionY) {
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
    if (Input.mouseX >= positionX - size && Input.mouseX < positionX + size &&
        Input.mouseY >= positionY - size && Input.mouseY < positionY + size) {
      highlight = true;
      if (Input.mouseDown) {
        currentLevel.placingGear = new Gear(number, Input.mouseX, Input.mouseY);
        Input.mouseDown = false;
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