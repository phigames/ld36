part of ld36;

class Instrument extends Gear {

  ImageElement instrumentImage;
  AudioElement sound;
  num playRotationInterval;
  num lastPlayRotation;

  Instrument(num positionX, num positionY, String imageKey, String soundKey) : super(5, positionX, positionY) {
    instrumentImage = Resources.images[imageKey];
    sound = Resources.sounds[soundKey].clone(false);
    playRotationInterval = PI * 2 / 5;
    lastPlayRotation = 0;
  }

  void play() {
    sound.currentTime = 0;
    sound.play();
  }

  void updateMore(num time) {
    if (rotation.abs() - lastPlayRotation >= playRotationInterval) {
      play();
      lastPlayRotation += playRotationInterval;
    }
  }

  void drawMore() {
    bufferContext.drawImage(instrumentImage, positionX - 16, positionY - 72);
  }

}