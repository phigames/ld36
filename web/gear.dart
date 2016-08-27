part of ld36;

class Gear {

  int number;
  num positionX, positionY;
  num rotation;
  num rotationSpeed;
  num radius;
  List<Gear> connectedGears;
  bool jammed;
  ImageElement image;
  num imageCenterX, imageCenterY;

  Gear(this.number, this.positionX, this.positionY) {
    rotation = 0;
    rotationSpeed = 0;
    radius = number * 8;
    connectedGears = new List<Gear>();
    jammed = false;
    image = Resources.images['gear_${number}'];
    switch (number) {
      case 4:
        imageCenterX = 38;
        imageCenterY = 39;
        break;
      case 5:
        imageCenterX = 48;
        imageCenterY = 46;
    }
  }

  void connect(Gear gear) {
    if (!jammed) {
      if (gear.rotationSpeed == 0) { // this == driving gear
        connectedGears.add(gear);
      } else if (this.rotationSpeed == 0) { // this == driven gear
        rotationSpeed = -gear.rotationSpeed * gear.number / number;
        connectedGears.add(gear);
      } else {
        clearConnections();
        jammed = true;
      }
    }
  }

  void updateConnectedGears() {
    for (int i = 0; i < connectedGears.length; i++) {
      if (connectedGears[i].rotationSpeed == 0) { // this == driving gear
        connectedGears[i].rotationSpeed = -rotationSpeed * number / connectedGears[i].number;
        connectedGears[i].updateConnectedGears();
      }
    }
  }

  void clearConnections() {
    connectedGears.clear();
    rotationSpeed = 0;
    jammed = false;
  }

  void update(num time) {
    rotation += rotationSpeed * time;
    updateMore(time);
  }

  void updateMore(num time) { }

  void draw([bool preview = false]) {
    bufferContext.save();
    if (preview && connectedGears.length == 0) {
      bufferContext.globalAlpha = 0.5;
    }
    bufferContext.translate(positionX, positionY);
    bufferContext.rotate(rotation);
    bufferContext.drawImage(image, -imageCenterX, -imageCenterY);
    bufferContext.restore();
    drawMore();
  }

  void drawMore() { }

}