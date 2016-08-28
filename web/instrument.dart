part of ld36;

class Instrument extends Gear {

  String type;
  ImageElement instrumentImage;
  num imageOffsetX, imageOffsetY;
  AudioElement sound1, sound2;
  num playRotationInterval;
  num lastPlayRotation;

  Instrument(this.type, num positionX, num positionY) : super(5, positionX, positionY) {
    instrumentImage = Resources.images[type];
    if (type == 'chord') {
      imageOffsetX = 16;
      imageOffsetY = 72;
    } else if (type == 'drum') {
      imageOffsetX = 39;
      imageOffsetY = 87;
    } else if (type == 'box') {
      imageOffsetX = 62;
      imageOffsetY = 73;
    }
    sound1 = Resources.sounds['${type}_low'].clone(false);
    sound2 = Resources.sounds['${type}_high'].clone(false);
    playRotationInterval = PI * 2 / 5;
    lastPlayRotation = 0;
  }

  void play() {
    if (rotationSpeed > 0) {
      sound1.currentTime = 0;
      sound1.play();
    } else {
      sound2.currentTime = 0;
      sound2.play();
    }
  }

  void updateMore(num time) {
    if ((rotation - lastPlayRotation).abs() >= playRotationInterval) {
      play();
      lastPlayRotation += playRotationInterval * rotationSpeed.sign;
    }
  }

  void drawMore() {
    bufferContext.drawImage(instrumentImage, positionX - imageOffsetX + currentLevel.offsetX, positionY - imageOffsetY + currentLevel.offsetY);
  }

}