part of ld36;

class Input {

  static num mouseX, mouseY;
  static bool mouseDown;

  static void initialize() {
    mouseX = 0;
    mouseY = 0;
    canvas.onMouseMove.listen(onMouseMove);
    canvas.onMouseDown.listen(onMouseDown);
    canvas.onMouseUp.listen(onMouseUp);
  }

  static void onMouseMove(MouseEvent event) {
    mouseX = event.layer.x;
    mouseY = event.layer.y;
  }

  static void onMouseDown(MouseEvent event) {
    if (event.button == 0) {
      mouseDown = true;
    }
  }

  static void onMouseUp(MouseEvent event) {
    if (event.button == 0) {
      mouseDown = false;
    }
  }

}