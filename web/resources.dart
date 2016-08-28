part of ld36;

class Resources {

  static Map<String, ImageElement> images;
  static Map<String, AudioElement> sounds;
  static int imagesLoaded, soundsLoaded;
  static bool doneLoading;

  static void load() {
    images = new Map<String, ImageElement>();
    sounds = new Map<String, AudioElement>();
    imagesLoaded = 0;
    soundsLoaded = 0;
    loadImage('temple');
    loadImage('squares');
    loadImage('gear_4');
    loadImage('gear_4_green');
    loadImage('gear_4_blue');
    loadImage('gear_5');
    loadImage('gear_5_green');
    loadImage('gear_5_blue');
    loadImage('gear_6');
    loadImage('gear_6_green');
    loadImage('gear_6_blue');
    loadImage('gear_8');
    loadImage('gear_8_green');
    loadImage('gear_8_blue');
    loadImage('chord');
    loadImage('drum');
    loadImage('box');
    loadImage('trash');
    loadImage('play');
    loadImage('help');
    loadSound('chord_low');
    loadSound('chord_high');
    loadSound('drum_low');
    loadSound('drum_high');
    loadSound('box_low');
    loadSound('box_high');
  }

  static void loadImage(String key) {
    images[key] = new ImageElement(src: 'res/${key}.png')..onLoad.first.then((e) => onImageLoad());
  }

  static void loadSound(String key) {
    sounds[key] = new AudioElement('res/${key}.wav')..onLoadedData.first.then((e) => onSoundLoad());
  }

  static void onImageLoad() {
    imagesLoaded++;
    if (imagesLoaded == images.length && soundsLoaded == sounds.length) {
      doneLoading = true;
    }
  }

  static void onSoundLoad() {
    soundsLoaded++;
    if (imagesLoaded == images.length && soundsLoaded == sounds.length) {
      doneLoading = true;
    }
  }

}