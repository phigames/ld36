part of ld36;

class Instrument extends Gear {

  ImageElement instrumentImage;
  num imageOffsetX, imageOffsetY;
  AudioElement sound1, sound2;
  num playRotationInterval;
  num lastPlayRotation;

  Instrument(num positionX, num positionY, String imageKey, this.imageOffsetX, this.imageOffsetY, String sound1Key, String sound2Key) : super(5, positionX, positionY) {
    instrumentImage = Resources.images[imageKey];
    sound1 = Resources.sounds[sound1Key].clone(false);
    sound2 = Resources.sounds[sound2Key].clone(false);
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
    if (rotation.abs() - lastPlayRotation >= playRotationInterval) {
      play();
      lastPlayRotation += playRotationInterval;
    }
  }

  void drawMore() {
    bufferContext.drawImage(instrumentImage, positionX - imageOffsetX, positionY - imageOffsetY);
  }

}