part of ld36;

class Input {

  static num mouseX, mouseY;
  static bool leftMouseDown, rightMouseDown;
  static bool escDown;

  static void initialize() {
    mouseX = 0;
    mouseY = 0;
    canvas.onMouseMove.listen(onMouseMove);
    canvas.onMouseDown.listen(onMouseDown);
    canvas.onMouseUp.listen(onMouseUp);
    window.onKeyDown.listen(onKeyDown);
    window.onKeyUp.listen(onKeyUp);
  }

  static void onMouseMove(MouseEvent event) {
    mouseX = event.layer.x;
    mouseY = event.layer.y;
  }

  static void onMouseDown(MouseEvent event) {
    if (event.button == 0) {
      leftMouseDown = true;
    } else if (event.button == 2) {
      rightMouseDown = true;
    }
  }

  static void onMouseUp(MouseEvent event) {
    if (event.button == 0) {
      leftMouseDown = false;
    } else if (event.button == 2) {
      rightMouseDown = false;
    }
  }

  static void onKeyDown(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ESC) {
      escDown = true;
    }
  }

  static void onKeyUp(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ESC) {
      escDown = false;
    }
  }

}