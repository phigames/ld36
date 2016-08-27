library ld36;

import 'dart:html';
import 'dart:math';
import 'dart:web_audio';

part 'level.dart';
part 'gear.dart';
part 'instrument.dart';
part 'input.dart';
part 'resources.dart';

int canvasWidth, canvasHeight;
CanvasElement canvas, buffer;
CanvasRenderingContext2D canvasContext, bufferContext;
AudioContext audioContext;
num timePassed;
Level currentLevel;

void main() {
  canvas = querySelector('#canvas');
  canvasContext = canvas.context2D;
  buffer = new CanvasElement(width: canvasWidth, height: canvasHeight);
  bufferContext = buffer.context2D;
  updateCanvasSize();
  window.onResize.listen((e) => updateCanvasSize());
  audioContext = new AudioContext();
  timePassed = -1;
  Input.initialize();
  Resources.load();
  currentLevel = new Level();
  requestFrame();
}

void updateCanvasSize() {
  canvasWidth = window.innerWidth;
  canvasHeight = window.innerHeight;
  canvas.width = canvasWidth;
  canvas.height = canvasHeight;
  buffer.width = canvasWidth;
  buffer.height = canvasHeight;
}

void update(num time) {
  currentLevel.update(time);
}

void draw() {
  bufferContext.clearRect(0, 0, canvasWidth, canvasHeight);
  currentLevel.draw();
  canvasContext.clearRect(0, 0, canvasWidth, canvasHeight);
  canvasContext.drawImage(buffer, 0, 0);
}

void frame(num time) {
  if (timePassed == -1) {
    timePassed = time;
  } else {
    update(time - timePassed);
    timePassed = time;
    draw();
  }
  requestFrame();
}

void requestFrame() {
  window.animationFrame.then(frame);
}