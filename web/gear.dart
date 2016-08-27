part of ld36;

class Gear {

  int number;
  num positionX, positionY;
  num rotation;
  num rotationSpeed;
  num radius;
  Gear parent;
  List<Gear> gluedGears;
  List<Gear> connectedGears;
  int highlight;
  ImageElement image;
  num imageCenterX, imageCenterY;

  Gear(this.number, this.positionX, this.positionY) {
    rotation = 0;
    rotationSpeed = 0;
    radius = number * 8;
    gluedGears = new List<Gear>();
    connectedGears = new List<Gear>();
    highlight = 0;
    image = Resources.images['gear_${number}'];
    switch (number) {
      case 4:
        imageCenterX = 38;
        imageCenterY = 39;
        break;
      case 5:
        imageCenterX = 48;
        imageCenterY = 46;
        break;
      case 8:
        imageCenterX = 75;
        imageCenterY = 71;
        break;
    }
  }

  void resetHighlight() {
    highlight = 0;
    for (int i = 0; i < gluedGears.length; i++) {
      gluedGears[i].resetHighlight();
    }
    for (int i = 0; i < connectedGears.length; i++) {
      connectedGears[i].resetHighlight();
    }
  }

  Gear getGluableGear(Gear placing) {
    num dX = placing.positionX - positionX;
    num dY = placing.positionY - positionY;
    num distance = sqrt(dX * dX + dY * dY);
    num minDistance = placing.radius + radius - 15;
    if (distance < minDistance) {
      return this;
    } else {
      for (int i = 0; i < gluedGears.length; i++) {
        Gear child = gluedGears[i].getGluableGear(placing);
        if (child != null) {
          return child;
        }
      }
      for (int i = 0; i < connectedGears.length; i++) {
        Gear child = connectedGears[i].getGluableGear(placing);
        if (child != null) {
          return child;
        }
      }
      return null;
    }
  }

  Gear getConnectableGear(Gear placing) {
    num dX = placing.positionX - positionX;
    num dY = placing.positionY - positionY;
    num distance = sqrt(dX * dX + dY * dY);
    num minDistance = placing.radius + radius - 15;
    num maxDistance = placing.radius + radius + 15;
    if (distance > minDistance && distance < maxDistance) {
      return this;
    } else {
      for (int i = 0; i < gluedGears.length; i++) {
        Gear child = gluedGears[i].getConnectableGear(placing);
        if (child != null) {
          return child;
        }
      }
      for (int i = 0; i < connectedGears.length; i++) {
        Gear child = connectedGears[i].getConnectableGear(placing);
        if (child != null) {
          return child;
        }
      }
      return null;
    }
  }

  Gear getIntersectingGear(num x, num y) {
    num dX = x - positionX;
    num dY = y - positionY;
    num distance = sqrt(dX * dX + dY * dY);
    num maxDistance = radius;
    if (distance < maxDistance) {
      return this;
    } else {
      for (int i = 0; i < gluedGears.length; i++) {
        Gear child = gluedGears[i].getIntersectingGear(x, y);
        if (child != null) {
          return child;
        }
      }
      for (int i = 0; i < connectedGears.length; i++) {
        Gear child = connectedGears[i].getIntersectingGear(x, y);
        if (child != null) {
          return child;
        }
      }
      return null;
    }
  }

  void glue(Gear placing) {
    gluedGears.add(placing);
    placing.parent = this;
    placing.positionX = positionX;
    placing.positionY = positionY;
    placing.rotationSpeed = rotationSpeed;
  }

  void connect(Gear placing) {
    connectedGears.add(placing);
    placing.parent = this;
    num dX = placing.positionX - positionX;
    num dY = placing.positionY - positionY;
    num distance = sqrt(dX * dX + dY * dY);
    num targetDistance = placing.radius + radius;
    placing.positionX = positionX + dX / distance * targetDistance;
    placing.positionY = positionY + dY / distance * targetDistance;
    placing.rotationSpeed = -rotationSpeed * number / placing.number;
  }

  void updateChildren() {
    for (int i = 0; i < connectedGears.length; i++) {
      connectedGears[i].rotationSpeed = -rotationSpeed * number / connectedGears[i].number;
      connectedGears[i].updateChildren();
    }
    for (int i = 0; i < gluedGears.length; i++) {
      gluedGears[i].rotationSpeed = -rotationSpeed * number / connectedGears[i].number;
      gluedGears[i].updateChildren();
    }
  }

  void update(num time) {
    rotation += rotationSpeed * time;
    updateMore(time);
    for (int i = 0; i < gluedGears.length; i++) {
      gluedGears[i].update(time);
    }
    for (int i = 0; i < connectedGears.length; i++) {
      connectedGears[i].update(time);
    }
  }

  void updateMore(num time) { }

  void draw() {
    bufferContext.save();
    switch (highlight) {
      case 1:
        bufferContext.globalAlpha = 0.5;
        break;
      case 2:
        bufferContext.globalAlpha = 0.2;
    }
    bufferContext.translate(positionX + currentLevel.offsetX, positionY + currentLevel.offsetY);
    bufferContext.rotate(rotation);
    bufferContext.drawImage(image, -imageCenterX, -imageCenterY);
    bufferContext.restore();
    drawMore();
    for (int i = 0; i < gluedGears.length; i++) {
      gluedGears[i].draw();
    }
    for (int i = 0; i < connectedGears.length; i++) {
      connectedGears[i].draw();
    }
  }

  void drawMore() { }

}