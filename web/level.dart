part of ld36;

class Level {

  List<Gear> gears;
  //List<Instrument> instruments;
  Gear placingGear;

  Level() {
    gears = new List<Gear>();
    gears.add(new Gear(4, 100, 100)..rotationSpeed = 0.002);
    //instruments = new List<Instrument>();
    gears.add(new Instrument(500, 200, 'chord', 'strum'));
    placingGear = new Gear(5, Input.mouseX, Input.mouseY);
  }

  void update(num time) {
    if (placingGear != null) {
      placingGear.clearConnections();
      for (int i = 0; i < gears.length; i++) {
        num dX = Input.mouseX - gears[i].positionX;
        num dY = Input.mouseY - gears[i].positionY;
        num distance = sqrt(dX * dX + dY * dY);
        num minDistance = placingGear.radius + gears[i].radius - 15;
        num maxDistance = placingGear.radius + gears[i].radius + 15;
        if (distance > minDistance && distance < maxDistance) {
          placingGear.connect(gears[i]);
        }
        placingGear.positionX = Input.mouseX;
        placingGear.positionY = Input.mouseY;
      }
      if (Input.mouseDown && placingGear.connectedGears.length > 0) {
        gears.add(placingGear);
        placingGear.updateConnectedGears();
        placingGear = new Gear(5, Input.mouseX, Input.mouseY);
        Input.mouseDown = false;
      }
    }
    for (int i = 0; i < gears.length; i++) {
      gears[i].update(time);
    }
    /*for (int i = 0; i < instruments.length; i++) {
      instruments[i].update(time);
    }*/
    if (placingGear != null) {
      placingGear.update(time);
    }
  }

  void draw() {
    for (int i = 0; i < gears.length; i++) {
      gears[i].draw();
    }
    /*for (int i = 0; i < instruments.length; i++) {
      instruments[i].draw();
    }*/
    if (placingGear != null) {
      placingGear.draw(true);
    }
  }

}