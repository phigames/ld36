library ld36;

import 'dart:html';
import 'dart:math';
import 'dart:web_audio';

part 'gamestate.dart';
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
Random random;
GameState gameState;
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
  random = new Random();
  gameState = new GameStateLoading();
  requestFrame();
}

void updateCanvasSize() {
  if (window.innerWidth > 600) {
    canvasWidth = window.innerWidth;
  } else {
    canvasWidth = 600;
  }
  if (window.innerHeight > 300) {
    canvasHeight = window.innerHeight;
  } else {
    canvasHeight = 300;
  }
  canvas.width = canvasWidth;
  canvas.height = canvasHeight;
  buffer.width = canvasWidth;
  buffer.height = canvasHeight;
}

void update(num time) {
  gameState.update(time);
}

void draw() {
  bufferContext.clearRect(0, 0, canvasWidth, canvasHeight);
  gameState.draw();
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